hab origin key upload --pubfile ~/.hab/cache/keys/mbohl-20180723170042.pub

get sample app:
`git clone https://github.com/learn-chef/habitat-building-with-scaffolding.git`

- Habitat plan describes everything that's needed to build and package an app. The resulting package is often called an artifact.
`hab plan init`
    - hab plan init created a few files and directories for your project, including a **plan.sh** file. The Habitat plan exists in the habitat directory. So not only does the automation travel with your application, but your Habitat plan also travels with your application's source code.
    - Also notice that hab plan init detected that the application is written in Ruby. It was able to do so because the project conforms to a number of standard conventions that are common to Ruby web applications. 
        * For example, it has a **Gemfile**, which provides Bundler a list of all the gems necessary for this project to run. 
        * It also has a Rackup configuration file, **config.ru**, that provides a way to run the app.

    The hab plan init output tells us that it is using a scaffolding package based on the detected application. Think of scaffolding as a standard way to build a specific kind of application. You'll learn more about scaffolding in a bit. Besides Ruby, Habitat can detect other kinds of applications.
    [Learn more about Scaffolding](https://github.com/habitat-sh/core-plans/blob/master/scaffolding-ruby/doc/reference.md)

```
plan.sh

pkg_name=habitize #changed
pkg_origin=mbohl
pkg_version="0.1.0"
pkg_scaffolding="core/scaffolding-ruby"
pkg_deps=( core/imagemagick )  #added
```

#### Build the Package
`hab studio enter`

- first time you run (or when you upgrade your hab version), Habitat downloads the Docker images needed to create it. Hab runs Docker container & logs you into Studio.

- Studio imports your origin keys, then runs a Supervisor (process mgr. that runs Hab artifacts) in the background.

- Studio is a cleanroom separate from your workstation. This helps ensure the packages are built consistently.

run `build`
`cd /hab/pkgs/mbohl/habitize/0.1.0/20180725204856`
`hab svc load $HAB_ORIGIN/habitize`
**If you create a new Studio instance, your package will not be installed. To install it, run `hab pkg install PACKAGE_PATH`, replacing PACKAGE_PATH with the path to the your package in the results directory.**

- The supervisor starts the process in the background, run `sup-log` to see the logs

- Run `wget -qO- localhost:8000` to  verify it's running (will show html output in studio)

#### Export to Docker

`hab pkg export docker ./results/mbohl-habitize-0.1.0-20180725211615-x86_64-linux.hart`

`docker images | grep habitize`
`export HAB_ORIGIN=xxxx`
`echo $HAB_ORIGIN`
`docker run -p 8000:8000 $HAB_ORIGIN/habitize`

f99120c2995f