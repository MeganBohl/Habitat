#### Make your Habitat applications configurable
`cd webapp`
`hab studio enter`
- run `hab pkg config to see which parameters are tunable
`hab pkg config $HAB_ORIGIN/webapp`
- These configuration values are used to generate the Apache configuration file. You'll find them in your project's `default.toml` file.

##### Make the CGI script configurable
`cat hello-world`
```
#ORIGINAL hello-world SCRIPT
#!/bin/bash

echo "Content-type: text/plain; charset=iso-8859-1"
echo ""

echo "Hello World!!"
echo "Time is: $(date)"
```

**Goals are to:**

**1.** Modify the CGI script to make the greeting configurable.


```
#!/bin/bash

echo "Content-type: text/plain; charset=iso-8859-1"
echo ""

GREETING=$(grep greeting webapp.conf |awk -F "=" '{print $2}'|tr -d \")


echo $GREETING
echo "Time is: $(date)"
```

* the grep greeting `webapp.conf` part returns any line in the file `webapp.conf` that contains the word *"greeting"*. The remaining parts of that line remove the equals sign and space characters. The result is held in the GREETING variable.

**2.** Provide a default value for the greeting.
in `habitat/config/webapp.conf` add:
```
# Sets the message of the day that will be displayed publicly.
greeting = "{{cfg.webapp.greeting}}"
```
* This configuration uses Handlebars syntax to read the cfg.webapp.greeting configuration variable.

The `cfg` part means that the value is set in a TOML file. Recall that default configuration values are read from `default.toml`.

in `default.toml` add:
```
[webapp]
greeting = "Hello from default.toml!!"
```

**3.** Copy the configuration file.

- So far, webapp.conf exists in the config directory in your Habitat project. During the build process, all files in the config directory are added to the package.
- in your `hello-world` script, The grep greeting webapp.conf part reads from webapp.conf in the current directory. Recall that the init hook copies the hello-world script to the cgi-bin directory. `cp {{pkg.path}}/hello-world {{pkg.svc_data_path}}/cgi-bin/`. Therefore you need to copy webapp.conf to the cgi-bin directory so the hello-world script can access it.

* There are two cases where webapp.conf needs to be copied to cgi-bin:

1. When the **application initializes** (the init hook).
2. Any time the **configuration is updated** (the reconfigure hook).

###### Update the INIT Hook
* Modify your copy of `habitat/hooks/init` like this.

```
#!/bin/bash

addgroup {{cfg.group}}
adduser --disabled-password --ingroup {{cfg.user}} {{cfg.group}}

chmod 755 {{pkg.svc_data_path}}

mkdir -p {{pkg.svc_data_path}}/htdocs
mkdir -p {{pkg.svc_data_path}}/cgi-bin

cp {{pkg.path}}/hello-world {{pkg.svc_data_path}}/cgi-bin/
chmod 755 {{pkg.svc_data_path}}/cgi-bin/hello-world

cp {{pkg.svc_config_path}}/webapp.conf {{pkg.svc_data_path}}/cgi-bin/webapp.conf
chmod 755 {{pkg.svc_data_path}}/cgi-bin/webapp.conf
```
* When your package is installed, `webapp.conf` is copied to pkg.svc_config_path. This init script copies webapp.conf to the cgi-bin directory.

###### Create the RECONFIGURE hook
- Next, create the reconfigure hook, `habitat/hooks/reconfigure`, like this:
```
#!/bin/bash

cp {{pkg.svc_config_path}}/webapp.conf {{pkg.svc_data_path}}/cgi-bin/webapp.conf
chmod 755 {{pkg.svc_data_path}}/cgi-bin/webapp.conf
```
* From the Studio, run build to rebuild your package.
`hab enter studio`
`build`
start supervisor: `hab svc load $HAB_ORIGIN/webapp`
install curl: `hab pkg install core/curl -b`
`curl http://127.0.0.1/cgi-bin/hello-world`
###### Update the configuration
`sudo nano ~/webapp/update.toml`

```
[webapp]
greeting = "Hello, Megan!!"
```

`hab config apply webapp.default 1 update.toml`
* Recall that Supervisors join to form a peer-to-peer network, or ring. Here, hab config apply applies the configuration that you provided in update.toml to each member of the ring.

The `1` defines the version number for this configuration. Every configuration update has a unique ID.
The `webapp.default` part defines the service group, a concept we have not yet discussed.

- run `curl` to see the changes 
`curl http://127.0.0.1/cgi-bin/hello-world`