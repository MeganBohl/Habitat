### Reconfigure Habitat services through repackaging and live updates
 
[In this module](https://learn.chef.io/modules/hab-custom-config#/habitat-build), you'll repackage an application with updated configuration and then perform a configuration upgrade for an application running as a service
`git clone https://github.com/learn-chef/hab-custom-config`

#### Re-package application configuration
`hab studio enter`
`build`
`hab pkg config mbohl/habitatize`

* A package's configuration data is stored in TOML format. TOML allows you to define keys (e.g. lang, port) and assign them values (e.g. "en_US.UTF-8", 8000). TOML also supports the ability to group settings in tables (i.e. [app]).

Copy the default configuration into habitat/default.toml.
`hab pkg config mbohl/habitatize > habitat/default.toml`

- update the habitat/default.toml to port = 9000
```
lang = "en_US.UTF-8"
rack_env = "production"

[app]
port = 9000
```
`build`

`hab svc load mbohl/habitatize`
run `sup-log` to view 
install curl to verify the pkg is available on the selected port `hab pkg install core/curl -b`
`curl 127.0.0.1:9000`

#### Upgrade the configuration of the running service
* To apply a configuration update, you must provide:

1. The network address of a Habitat Supervisor.
2. The application's service group.
3. A version number. (any positive integer that it is higher than the version number provided in a previous configuration update.)
4. The configuration.
![Supervisor ring](/Images/Habitat_supervisor_ring.png)
When a Habitat Supervisor launches, it creates or joins a peer-to-peer network called the supervisor ring. The supervisor ring allows the Supervisors to share details about the services that they are managing. A configuration update sent to one Supervisor, through the `--peer ` flag, will eventually be delivered to all Supervisors within the ring.

When a service is started, it automatically joins a service group. By default, the service group name is calculated from the package name and default group name. In this instance, when you started this application as a service it automatically joined the service group called `habitatize.default`.

##### Apply an update with a file
update habit/default.toml w/port 10000

`hab config apply habitatize.default 1 habitat/default.toml`
```
[1][default:/src:0]# hab config apply habitatize.default 1 habitat/default.toml
» Setting new configuration version 1 for habitatize.default
Ω Creating service configuration
↑ Applying via peer 127.0.0.1:9632
★ Applied configuration
```
`curl 127.0.0.1:10000` shows output

##### Apply an update through a pipe

Apply a configuration update to the habitatize.default service group as version 2 piped from `echo -ne "[app]\nport=11000"`

`echo -ne "[app]\nport=11000" | hab config apply habitatize.default 2`
The echo commands `-ne` flag enables you to correctly formate TOML, as it will interpret the `\n` as a newline.