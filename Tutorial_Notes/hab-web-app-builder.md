https://learn.chef.io/modules/hab-web-app-builder#/habitat-deploy

* Prepare your accounts
Because this module uses your GitHub, Habitat, and Docker Hub accounts, we recommend you open a new browser window and create a tab for each of these sites:

GitHub – sign in and open your profile.
Habitat Builder – sign in with your GitHub account.
Habitat Builder GitHub app.
Docker Hub – sign in and create `habitatize` repo

- fork web-app-builder from habitat, then clone
`git clone https://github.com/MeganBohl/hab-web-app-builder.git`

`export HAB_DOCKER_OPTS="-p 8000:8000"`
`hab studio enter`
`build`

`hab svc load mbohl/habitatize`

go to http://40.124.40.145:8000
`exit`

###### Connect the web app to Builder
Sign into the Habitat Builder GitHub app.
Click Configure.
Select the GitHub org that contains your hab-web-app-builder repo.
Enter your GitHub password if prompted.
Under Repository access, enter "hab-web-app-builder", select your repo, then click Save.

`sudo nano ~/hab-web-app-builder/habitat/plan.sh`
```
pkg_name=habitatize
pkg_origin=mbohl
pkg_scaffolding="core/scaffolding-ruby"
pkg_version="0.1.0"
pkg_deps=( core/imagemagick )
```
`git commit -a -m "Update origin"`
`git push origin master`

RUN FROM DOCKER CONTAINER:
* it will automatically build in hab builder and in docker hub
`docker pull meganbohl/habitatize`
* run this command to run it as a container:
`docker run -it -p 8000:8000 meganbohl/habitatize`

*http://40.124.40.145:8000

RUN FROM STUDIO:
`hab pkg install --channel unstable $HAB_ORIGIN/habitatize`
`hab svc load $HAB_ORIGIN/habitatize`
`hab pkg install core/curl -b`
`curl localhost:8000`

#####
- fork & clone Imagemagick: `https://github.com/MeganBohl/imagemagick.git`
- build in hab studio builder site
- add dependency in `hab-web-app-builder/habitat/plan.sh`
`pkg_deps=( mbohl/imagemagick )`

`build`

```
    WARN Could not find a suitable installed package for 'mbohl/imagemagick'
ERROR: Resolving 'mbohl/imagemagick' failed, should this be built first?
```
`hab pkg search $HAB_ORIGIN/imagemagick` to get the fully-qualified name
mbohl/imagemagick/6.9.2-10/20180731192311
`hab pkg install --channel unstable mbohl/imagemagick/6.9.2-10/20180731192311`

`build` a second time to rebuild the web app
hab svc load ./results/mbohl-habitatize-0.2.0-20180731194557-x86_64-linux.hart

http://40.124.40.145:8000

###### Promot to stable

`hab pkg search $HAB_ORIGIN/imagemagick`
`hab pkg promote mbohl/imagemagick/6.9.2-10/20180731192311 stable`
Confirm stable status by running:
`hab pkg channels mbohl/imagemagick/6.9.2-10/20180731192311`
```
mbohl@chefcentos hab-web-app-builder]$ hab pkg channels mbohl/imagemagick/6.9.2-10/20180731192311
» Retrieving channels for mbohl/imagemagick/6.9.2-10/20180731192311
bldr-1038499455511478272
stable
unstable
```
push to github
`git commit -a -m "Use my ImageMagick package"`
`git push origin master`

*After it rebuilds, run the docker container:
`docker pull meganbohl/habitatize`
`docker run -it -p 8000:8000 meganbohl/habitatize`

http://40.124.40.145:8000