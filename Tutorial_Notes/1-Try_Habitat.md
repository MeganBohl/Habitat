# Habitat
http://40.124.40.145:8000
https://learn.chef.io/modules/try-habitat#/demos-and-quickstarts
##### Habitat works with both new and existing applications. You can use Habitat to:

- Build packages that include everything that's needed for your application to run.
- Deploy your application on any platform, including bare metal, a VM, the cloud, Docker, Mesos, Kubernetes, and more.
- Manage your running application and respond to configuration changes made by other services in the same network.
    * Simply put, Habitat enables you to package your application and not worry about where it's going to be deployed until you're ready to deploy it. If you decide to switch runtime environments, for example, from a VM to Docker containers, you don't need to repackage or rewrite your app – the same Habitat package can run in both environments.
`export HAB_ORIGIN=xxxxx`
`echo $HAB_ORIGIN`
`exportHAB_AUTH_TOKEN=xxxx`
`echo $HAB_AUTH_TOKEN`
* Install habitat:
`curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | sudo bash`
`hab cli setup`
`hab --version`

* Install Docker
```
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
```
```
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
```
`sudo yum-config-manager --enable docker-ce-edge`
`sudo yum-config-manager --enable docker-ce-test`

- You can disable the edge or test repository by running the yum-config-manager command with the --disable flag. To re-enable it, use the --enable flag. The following command disables the edge repository.
`sudo yum-config-manager --disable docker-ce-edge`

`sudo yum install docker-ce`
`sudo groupadd docker`
`sudo gpasswd -a $USER docker`
`newgrp docker`

** Start Docker** `sudo systemctl start docker`
* Test Docker: `sudo docker run hello-world`


- Install Docker Compose: 
`sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose`

`sudo chmod +x /usr/local/bin/docker-compose`

#### Build the package
`git clone https://github.com/learn-chef/hab-two-tier.git`
`cd hab-two-tier`
view `tree`
.
├── docker-compose.yml
├── haproxy
│   ├── config
│   │   └── haproxy.conf
│   ├── default.toml
│   └── plan.sh
├── README.md
└── webapp
    ├── config
    │   └── httpd.conf
    ├── default.toml
    ├── hello-world
    ├── hooks
    │   └── init
    └── plan.sh
* enter the Habitat Studio `hab studio enter`
    The Habitat Studio is an interactive Linux environment that acts as a "clean room" for creating Habitat packages. There is no other software in the Studio other than what you define.
    The Studio runs in a chroot environment. This environment is often called a "Unix jail" or "chroot jail". The use of chroot is common in virtualized environments such as containers. In fact, the Studio runs in a Docker container that contains no other software. This helps ensure that the package you create includes only what you need.
`build haproxy `
show results: `ls ./results`
- In this example:
```
[2][default:/src:0]# ls ./results
last_build.env  mbohl-haproxy-1.6.11-20180723170308-x86_64-linux.hart
```
        - mbohl is the origin name.
        - haproxy is the package name.
        - 1.6.11 is the version.
        - the number that follows is the release.
        - x86_64 is the target architecture.
        - linux is the target platform.
        - .hart is the file extension, which stands for "Habitat artifact".

`build webapp`
* Before you export your Habitat packages to Docker, let's run the webapp package in the Studio. This step isn't required, but it's a good way to see Habitat in action.
`hab svc load $HAB_ORIGIN/webapp`

* Habitat packages run under what's called the Supervisor.

Think of the Supervisor as a process manager, much like PID 1 in Linux. The Supervisor is responsible for two things:

Starting and monitoring the service that's defined in the Habitat package.
Receiving and acting upon configuration changes from other Supervisors.
[7][default:/src:1]# `hab sup status`
```
package                            type        state  elapsed (s)  pid    group
mbohl/webapp/0.2.0/20180723170617  standalone  up     103          37086  webapp.default
```
* Access the webapp
`hab pkg install core/curl -b`
`curl -s 127.0.0.1 | grep 'The time is'`

* upload webapp & haproxy packages to builder
`hab pkg upload ./results/$HAB_ORIGIN-webapp-0.2.0-20180723170617-x86_64-linux.hart`
`hab pkg upload ./results/$HAB_ORIGIN-haproxy-1.6.11-20180723170308-x86_64-linux.hart`

* Verify the packages are on builder
go to: bldr.habitat.sh

* promote webapp package to stable:
`hab pkg promote $HAB_ORIGIN/webapp/0.2.0/20180723170617 stable`
###### Create Docker images

By default, this command pulls down the latest stable release from Builder:
`hab pkg export docker $HAB_ORIGIN/webapp`

* Create a Docker image for the HAProxy load balancer. Here, you provide the -c argument to specify the latest unstable release because you have not yet promoted the haproxy package to the stable channel.
`hab pkg export docker -c unstable $HAB_ORIGIN/haproxy`
`logout` of Habstudio

`docker images` shows images created in hab studio

* Start the 
`docker-compose -p habquickstart up -d`


The -d switch starts the services in the background. You can run `docker-compose logs -f` to see the service logs.
`docker ps`
http://40.124.40.145:8000

`curl -s http://127.0.0.1:8000 | grep 'The time is'`

##### Add a 3rd webserver
- first look at the haproxy config file: `docker exec habquickstart_load-balancer_1 cat /hab/svc/haproxy/config/haproxy.conf`
```
global
    maxconn 32

defaults
    mode http
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

frontend http-in
    bind *:80
    default_backend default

backend default
    option httpchk GET /
    server 172.18.0.3 172.18.0.3:80
    server 172.18.0.4 172.18.0.4:80
```

- Create the 3rd webserver: 
`docker run --network=habquickstart_default --name web-3 -d $HAB_ORIGIN/webapp --peer web-1`
- The --network argument joins the container to the same network as your load balancer and web servers. The --name argument names the container "web-3". The -d flag runs the container in the background.

- Refresh your browser or run curl a few times and you'll see that the load balancer alternates among all three of your web servers.

`curl -s http://127.0.0.1:8000 | grep 'The time is'`

-As a verification step, you can run docker exec again. You see that the HAProxy configuration includes all three web servers.
`docker exec habquickstart_load-balancer_1 cat /hab/svc/haproxy/config/haproxy.conf`
```
global
    maxconn 32

defaults
    mode http
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

frontend http-in
    bind *:80
    default_backend default

backend default
    option httpchk GET /
    server 172.18.0.3 172.18.0.3:80
    server 172.18.0.5 172.18.0.5:80
    server 172.18.0.4 172.18.0.4:80
```
- Remove the 3rd webserver
`docker rm -f web-3`

- Tearing down:
    - Stop the containers:
    `docker-compose -p habquickstart down`
- Delete Docker images:
    use to find image ids: `docker images | grep $HAB_ORIGIN`
    `docker image rm -f 4123927afdbb 009bb563754b`
