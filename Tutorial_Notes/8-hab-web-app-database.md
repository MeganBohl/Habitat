#### Build a web application that uses a database
Build a web application that dynamically binds to a running database installation.

`git clone https://github.com/learn-chef/national-parks-java.git`

Export environment variable"
`export HAB_DOCKER_OPTS="-p 8080:8080"`

- Recall that the Studio runs in a Docker container. This environment variable configures port forwarding from port 8080 on your system to port 8080 in the container. You'll use this to access the web app (which runs in the Studio) from a browser on your host system.

`hab studio enter`
- Install tree
`hab pkg install -b core/tree`

run `tree` to see how the package's source code is installed
```
|-- README.md
|-- national-parks.json
|-- pom.xml
`-- src
    `-- main
        |-- java
        |   `-- io
        |       `-- chef
        |           `-- nationalparks
        |               |-- domain
        |               |   `-- NationalPark.java
        |               |-- mongo
        |               |   `-- DBConnection.java
        |               `-- rest
        |                   |-- JaxrsConfig.java
        |                   `-- NationalParksResource.java
        `-- webapp
            |-- WEB-INF
            |   `-- web.xml
            |-- images
            |   |-- greenClinic.png
            |   |-- greenicon.png
            |   |-- redClinic.png
            |   `-- redicon.png
            |-- index.html
            `-- snoop.jsp
```
- To build and run the app, you might follow these steps.

  * Install Maven.
  * Install Tomcat and Java.
  * Run mvn package
  * Copy the .war file to where it will run.
  * Run Catalina to start the app.
  * Install MongoDB.
  * Import the sample national parks data into the database.
You'll write Habitat plans to carry out these steps.

###### Build the app
In this stage, we'll accomplish these tasks:
  * Install Maven.
  * Install Tomcat and Java.
  * Run mvn package
  * Copy the .war file to where it will run.
  * Run Catalina to start the app.

1. Create the plan
`hab plan init`
    - Because no scaffolding exists for this kind of application, you'll build out the plan manually.

###### Define build behavior
in `habitat/plan.sh`

```
pkg_name=national-parks
pkg_origin=mbohl
pkg_version="0.1.0"
pkg_maintainer="The Chef Training Team <training@chef.io>"
pkg_license=('Apache-2.0')
pkg_build_deps=( core/maven )
pkg_deps=( core/tomcat8 core/jre8 )
pkg_svc_user=root

do_build() {
  mvn package
}

do_install() {
  cp target/$pkg_name.war $pkg_prefix
}
```
* Define build dependencies

The `pkg_build_deps` variable includes `core/maven` as a build dependency. Recall that a build dependency describes the software required to build your application, as opposed to software that's required to run it.

This project requires Maven only to build the project. Build dependencies are not included in your Habitat package.

* Define run-time dependencies

The `pkg_deps variable` includes `core/tomcat8` and `core/jre8` as run-time dependencies. Tomcat and the Java Runtime Environment (JRE) are required to run the application.

* Define build phases

`do_build` and `do_install` are build phase callbacks.

The `do_build` phase runs `mvn` package. mvn package uses the settings defined by pom.xml to compile and package the app. The POM file specifies that the application should be packaged as a WAR file, a common format used to distribute compiled Java code.

The `do_install` phase copies the resulting .war file from the target directory to the packaging location. The packaging location is the directory Habitat packages into a .hart file. `$pkg_prefix` defines the absolute package path. We don't define this variable, so Habitat uses the default, `/hab/pkgs/learn-chef/national-parks/`.

###### Define runtime behavior

At this point, `plan.sh` defines how to build the .war file and copy that file to the packaging location. When the package is installed, several things still need to happen.

- Copy the contents of the Tomcat root directory to the package's service directory.
- Copy the .war file from the package directory the package's Tomcat root webapps directory.
- Run Catalina.

* To accomplish these tasks, you need to define the `init` hook to establish a Tomcat root and a `run` hook to start the service

- init hook: script that runs when your app needs to initialize itself 
- run hook: shell script that Habitat executes when it is time to launch your application.

###### Create `habitat/hooks/init` and add this content.
- init hook: script that runs when your app needs to initialize itself 
```
#!/bin/bash

exec 2>&1

echo "Preparing TOMCAT_HOME..."

# Create a Tomcat root for this app in the package's service directory
cp -a {{pkgPathFor "core/tomcat8"}}/tc {{pkg.svc_var_path}}/

echo "Done preparing TOMCAT_HOME"
```
1. defines the Bash interpreter. `#!/bin/bash `
2. redirects 2 (Standard Error) to 1 (Standard Output). We recommend you do so to ensure all output is captured in the Habitat Supervisor's log. `exec 2>&1`
3. prints "Preparing TOMCAT_HOME..." to help you locate this event in the Supervisor log. `echo "Preparing TOMCAT_HOME..."`
4. copies the tomcat source code found in the core/tomcat8 package's tc directory to the service directory's var directory, pkg.svc_var_path, to ensure that the core/tomcat8 package remains unmodified `# Create a Tomcat root for this app in the package's service directory`
`cp -a {{pkgPathFor "core/tomcat8"}}/tc {{pkg.svc_var_path}}/`
5. prints "Done preparing TOMCAT_HOME" to help you locate this event in the Supervisor log. `echo "Done preparing TOMCAT_HOME"`

###### Create `habitat/hooks/run` and add this content.
- run hook: shell script that Habitat executes when it is time to launch your application.
`sudo nano habitat/hooks/run`
```
#!/bin/bash  # 1

exec 2>&1    # 2

echo "Starting Apache Tomcat"  # 3

export TOMCAT_HOME={{pkg.svc_var_path}}/tc     # 4

cp {{pkg.path}}/*.war $TOMCAT_HOME/webapps    #  5

exec ${TOMCAT_HOME}/bin/catalina.sh run
```


1. defines the Bash interpreter. `#!/bin/bash`
2. redirects 2 (Standard Error) to 1 (Standard Output). We recommend you do so to ensure all output is captured in the Habitat Supervisor's log. `exec 2>&1`
3. prints "Starting Apache Tomcat" to help you locate this event in the Supervisor log. `echo "Starting Apache Tomcat"`
4. exports the TOMCAT_HOME environment variable, which is used by the commands that follow. `export TOMCAT_HOME={{pkg.svc_var_path}}/tc`
5. copies the .war file from the package directory to Tomcat's webapps directory. `cp {{pkg.path}}/*.war $TOMCAT_HOME/webapps`
6. starts Catalina `exec ${TOMCAT_HOME}/bin/catalina.sh run`

run `build`

Then run 
`tree -L 2 target` to see some of the files the mvn package generated in the target directory
```
target
|-- classes
|   `-- io
|-- generated-sources
|   `-- annotations
|-- maven-archiver
|   `-- pom.properties
|-- maven-status
|   `-- maven-compiler-plugin
|-- national-parks
|   |-- META-INF
|   |-- WEB-INF
|   |-- images
|   |-- index.html
|   `-- snoop.jsp
`-- national-parks.war
```

`tree /hab/pkgs/mbohl/national-parks`
```
/hab/pkgs/mbohl/national-parks
`-- 0.1.0
    `-- 20180730205752
        |-- BUILDTIME_ENVIRONMENT
        |-- BUILDTIME_ENVIRONMENT_PROVENANCE
        |-- BUILD_DEPS
        |-- BUILD_TDEPS
        |-- DEPS
        |-- FILES
        |-- IDENT
        |-- MANIFEST
        |-- RUNTIME_ENVIRONMENT
        |-- RUNTIME_ENVIRONMENT_PROVENANCE
        |-- RUNTIME_PATH
        |-- SVC_GROUP
        |-- SVC_USER
        |-- TARGET
        |-- TDEPS
        |-- TYPE
        |-- config
        |-- default.toml
        |-- hooks
        |   |-- init
        |   `-- run
        `-- national-parks.war
```
`hab svc load mbohl/national-parks`
`hab pkg install -b core/curl`
`curl -IL http://127.0.0.1:8080/national-parks`

http://40.124.40.145:8080/national-parks
- can see the map, but no nat'l parks, because we have no db set up

###### Load the database
`hab pkg install -b core/git`
`git merge origin/mongodb`
`tree mongodb`
```
mongodb
|-- README.md
|-- config
|   |-- mongod.conf
|   `-- mongos.conf
|-- default.toml
|-- hooks
|   |-- init
|   `-- post-run
`-- plan.sh
```
* The configuration loads location data about each national park from national-parks.json.

- Recall that the Supervisor acts much like a process manager. The Supervisor is responsible for two things:

    1. Starting and monitoring the service that's defined in the Habitat package.
    2. Receiving and acting upon configuration changes from other Supervisors.
Supervisors join to form a peer-to-peer network, or ring. A rumor is a piece of data that's shared with all the members of a ring. Habitat uses a gossip protocol to circulate rumors throughout the ring. For example, when a peer joins or leaves the network, a rumor is circulated among each Supervisor in the ring.
`build`
`build mongodb`
`hab svc load mbohl/mongodb-parks`
`hab pkg binlink core/mongodb`
* run this command to display the "nationalparks" table from the database:
`mongo 127.0.0.1/demo --eval "db.nationalparks.find().pretty()"`
```
MongoDB shell version v3.6.4
connecting to: mongodb://127.0.0.1:27017/demo
MongoDB server version: 3.6.4
```
###### Connect the app to the database
- run `hab sup status` to see what services are running
```
package                                    type        state  elapsed (s)  pidgroup
mbohl/national-parks/0.1.0/20180730205752  standalone  up     2594         28537national-parks.default
mbohl/mongodb-parks/3.2.9/20180730212735  standalone  up  117  30795  mongodb-parks.default
```
`hab svc unload mbohl/national-parks`

* Update habitat/plan.sh to connect to the MongoDB database
The catalina run command reads configuration options from the CATALINA_OPTS environment variable. The National Parks app configuration needs to provide database connection info, include the IP address and port, through this variable.

To consume this port configuration from the National Parks app, you use the pkg_binds variable. This variable maps, or binds, configuration keys for external services to names the dependent configuration can use.

In your National Parks plan file, habitat/plan.sh, before the do_build callback, define the pkg_binds variable, making the entire file look like this.

`habitat/plan.sh`
```
pkg_name=national-parks
pkg_origin=learn-chef
pkg_version="0.1.0"
pkg_maintainer="The Chef Training Team <training@chef.io>"
pkg_license=('Apache-2.0')
pkg_build_deps=( core/maven )
pkg_deps=( core/tomcat8 core/jre8 )
pkg_svc_user=root

pkg_binds=(
  [database]="port"
)

do_build() {
  mvn package
}

do_install() {
  cp target/$pkg_name.war $pkg_prefix
}
```
The [database]="port" part means that any rumor containing the key "port" should be mapped to the "database" configuration key. If more than one "port" key is gossiped around the ring, database would contain multiple entries, one for each member of the ring.

add `export CATALINA_OPTS="-DMONGODB_SERVICE_HOST={{bind.database.first.sys.ip}} -DMONGODB_SERVICE_PORT={{bind.database.first.cfg.port}}"` to habitat/hooks/run 

Notice bind.database.first.sys.ip and bind.database.first.cfg.port. Both of these are examples of template data.

`bind.database.first` gets the first member of the ring who exposes database info. We expect only one MongoDB instance in the ring.
`bind.database.first.sys.ip` gets the IP address of the system running the MongoDB service.
`bind.database.first.cfg.port` gets the port number from the exported MongoDB configuration.

`build`
`ls results`

there are 2 build results
`cat results/last_build.env`  will show most recent results

`hab svc load mbohl/national-parks/0.1.0/20180731163350 --bind database:mongodb-parks.default`
`hab sup status `will show both the natl parks app & mongodb running

TOMORROW:
curl -IL http://127.0.0.1:8080/national-parks
& open in browser