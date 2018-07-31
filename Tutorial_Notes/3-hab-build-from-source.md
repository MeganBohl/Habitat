http://40.124.40.145:8000
`git clone https://github.com/learn-chef/habitat-building-dependencies`

#### Re-create error of adding .jpg into habitatize app
`hab studio enter`
`hab pkg export docker ./results/mbohl-habitatize-0.1.0-20180726154640-x86_64-linux.hart`
`export HAB_ORIGIN=xxxx`
`echo $HAB_ORIGIN`
`docker run -p 8000:8000 $HAB_ORIGIN/habitatize`

look at docker logs:
`docker ps` to find container 
`docker logs f99120c2995f`
    ```
    habitatize.default(O): 2018-07-26 16:08:38 - Magick::ImageMagickError - no decode delegate for this image format `JPEG' @ error/constitute.c/ReadImage/501:
    ```
#### Create new imagemagick pkg with .jpg dependency
`mkdir imagemagick`
`touch imagemagick/plan.sh`
* add core imagemagick plan only changing origin to mbohl
build in hab studio
`build imagemagick`
* Build ImageMagick with JPEG support
`hab pkg search jpeg`
    * Installing packages that you eventually do not use will not affect your build. An installed package is not automatically included in the build unless it is specifically added to the plan file as a runtime or build dependency.
`hab pkg install core/libjpeg-turbo`
`hab pkg provides jconfig.h` # need to make sure the package provides jconfig.h for jpegs

* add core/libjpeg-turbo to imagemagick/plan.sh  since the pkg does provide jconfig.h
`build imagemagick` 

rebuild habitatize
in studio: `hab pkg export docker ./results/mbohl-habitatize-0.2.0-20180726163607-x86_64-linux.hart`
`export HAB_ORIGIN=xxxxx`
`echo $HAB_ORIGIN`
`docker run -p 8000:8000 $HAB_ORIGIN/habitatize`

