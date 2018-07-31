## Build a legacy application with Habitat 
[hab-build-a-legacy-app](https://learn.chef.io/modules/hab-build-a-legacy-app#/habitat-build)

`mkdir webapp`
- create file `hello-world`:
```
echo "Content-type: text/plain; charset=iso-8859-1"
echo ""

echo "Hello World!!"
echo "Time is: $(date)"
```
**`hab plan init`**

Habitat examines your application but is unable to find scaffolding that would assist you in building your package. It instead creates:

* a habitat directory with a **plan** file, `plan.sh`.
* a **configuration** directory, `habitat/config`.
* a file to store default **configuration** values, `habitat/default.toml`.
* an application lifecycle **hooks** directory, `habitat/hooks`. (Scripts)to control how your application behaves throughout its lifecycle, for example, how it is initialized, updated, and shut down. For example, during initialization you might need to move files into the svc directory. Or perhaps at shutdown you might remove temporary files that you no longer need.

Habitat can package everything your application needs to run. 
The **core build phases** that happen when you build a Habitat package:

1. **Download source**
    Here, there's nothing to download, as the source code is defined in the `hello-world` script. Override this phase by defining the `do_download` callback to take no action.A callback that returns 0 means that function completed successfully.

```
do_download() {
  return 0
}
```

2. **Verify source**
    If a plan defines pkg_source, then this phase ensures that the downloaded archive matches the provided checksum in pkg_shasum. This application does not need to be verified. Remove the pkg_source from the plan.
3. **Unpack source**
    If a plan defines a pkg_source then this phase extracts the downloaded and verified archive. This application does not need to be unpacked and pkg_source has already been removed from the plan.
4. **Build source**
    This phase configures and builds the application. This legacy application relies on httpd, which is provided by the core/httpd package. Override the default build phase by defining the do_build callback to take no action.
```
do_build() {
  return 0
}
```
5. **Install source**
    After the source has been built, this phase installs the results into the package. The ~/webapp/hello-world script is the complete application. Override the do_install callback to copy the script file into the package.


```
do_install() {
  cp hello-world $pkg_prefix/
}
```
The current working directory inside of the do_install function is /src. This is the same directory that is mounted when you enter the Studio. The hello-world script is copied into the package. The package's path is constructed when it is built and then stored in the plan variable$pkg_prefix.

* add apache depencies:
```
pkg_deps=(core/httpd)
pkg_svc_user="root"
pkg_svc_group="root"
pkg_svc_run="httpd -DFOREGROUND -f $pkg_svc_config_path/httpd.conf"
```
- `pkg_deps` defines your run-time dependencies. The parenthesis () means it's an array. The core/httpd package installs Apache HTTP Server.
- `pkg_svc_user` and pkg_svc_group define that the service needs to run as root. This is because the web app serves content on port 80; any service that uses port 1024 or less requires root access.
- `pkg_svc_run` describes how to run the application when the Supervisor starts.
6. **Copy configuration**
download apache config file: `curl -o habitat/config/httpd.conf https://raw.githubusercontent.com/learn-chef/habitat-build-plan-legacy/master/habitat/config/httpd.conf`
dl default.toml file: `curl -o habitat/default.toml https://raw.githubusercontent.com/learn-chef/habitat-build-plan-legacy/master/habitat/default.toml`

* In `habitat/config/httpd.conf` locate the User and Group directives. The double curly braces {{ }} show Handlebars syntax. When the Supervisor starts your service, it reads the values for {{cfg.user}} and {{cfg.group}} from default.toml. Open your default.toml file and you'll see that the values for user and group are both "hab". When the Supervisor starts, it fills in the template with its values. You can also use the hab config apply command to alter your application's configuration at run time. 

7. **Add build hooks**
    This phase sets up lifecycle event handlers, or hooks, to perform certain actions during a service's runtime.

    Specifically, this phase copies the contents of the habitat/hooks directory into the package's config directory, $pkg_prefix/hooks. A hook is essentially a shell script. For this application you create the init hook and rely on the run hook generated automatically.

    The init hook is executed when the service is started but before the service runs.

```
webapp/habitat/hooks/init
#!/bin/bash

addgroup {{cfg.group}}
adduser --disabled-password --ingroup {{cfg.user}} {{cfg.group}}

chmod 755 {{pkg.svc_data_path}}

mkdir -p {{pkg.svc_data_path}}/htdocs
mkdir -p {{pkg.svc_data_path}}/cgi-bin

cp {{pkg.path}}/hello-world {{pkg.svc_data_path}}/cgi-bin/
chmod 755 {{pkg.svc_data_path}}/cgi-bin/hello-world
```
* The run hook for this application describes how the service is run and is automatically generated from the plan file's pkg_svc_run value: httpd -DFOREGROUND -f $pkg_svc_config_path/httpd.conf

8. **Sign and seal package**
This phase signs the package. For this application, no specific action is required here.

#### Build the package
`hab studio enter`
`build`
`ls results/*.hart`
    results/mbohl-webapp-0.1.0-20180726212217-x86_64-linux.hart
`hab svc load mbohl/webapp`
`sup-log`
install curl: `hab pkg install core/curl -b`
`curl http://127.0.0.1/cgi-bin/hello-world`

```
pkg_name=webapp
pkg_origin=learn-chef
pkg_version="0.1.0"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_license=('Apache-2.0')
pkg_deps=(core/httpd)
pkg_svc_user="root"
pkg_svc_group="root"
pkg_svc_run="httpd -DFOREGROUND -f $pkg_svc_config_path/httpd.conf"

do_download() {
  return 0
}

do_build() {
  return 0
}

do_install() {
  cp hello-world $pkg_prefix/
}
```
To see the content type header, run:
`curl -D - http://127.0.0.1/cgi-bin/hello-world`
```
HTTP/1.1 200 OK
Date: Thu, 26 Jul 2018 21:37:58 GMT
Server: Apache/2.4.27 (Unix) OpenSSL/1.0.2n
Transfer-Encoding: chunked
Content-Type: text/plain; charset=iso-8859-1

Hello World!!
```
