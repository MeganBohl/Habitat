#### Build a Habitat package with source that needs a patch
Build a Habitat package from an archive that uses a different build chain and requires you to diff and patch the source to correctly build.

`git clone https://github.com/learn-chef/hab-patching-source`

###### Habitat package's core build phases are:

1. Download source
2. Verify source
3. Unpack source
4. Build source
5. Install source
6. Copy configuration
7. Add build hooks
8. Sign and seal package

`hab enter studio`
`hab plan init`


###### Download Source 
The default behavior for packaging is to assume you are downloading a package. This is not always the case. Your packages may be delivered through different means because of an air-gapped environment, the original application's source code repository has shutdown, or this packaging process runs on the same system where the artifacts are stored.
To change the default behavior requires you to override the `do_download` function which retrieves the file from the `pkg_source` setting and copies the file into the `$HAB_CACHE_SRC_PATH` directory.
Within the project directory you will find the application source in an archive named `knock-knock-0.1.0.tar.gz`. Recall that within the Habitat studio the /src directory maps to your current working directory where you entered the studio. So the archive can be found at `/src/knock-knock-0.1.0.tar.gz or /src/${pkg_filename}`.

The `pkg_filename` setting defaults to be a combination of two plan settings - pkg_name and pkg_version. If the archive's name was different you would want to modify the pkg_filename.

Override the do_download function to copy the archive into `$HAB_CACHE_SRC_PATH` directory.
```
pkg_filename="${pkg_name}-${pkg_version}.tar.gz"

do_download() {
    cp /src/${pkg_filename} $HAB_CACHE_SRC_PATH
}
```
###### Verify source
In this phase the archive is compared against the checksum value defined in the pkg_shasum setting. A checksum for this archive exists in a file named `~/hab-patching-source/CHECKSUM`
`pkg_shasum="$(cat /src/CHECKSUM)"`

###### Build source
The 'build source' phase requires you to define how the application is built. Not all software uses the traditional build tools of `configure` and `make`. Application binaries may be compiled with different tools like Java's `javac` or Rust's `cargo`. To understand how this source is built requires you to view the unpacked source. Unfortunately the build process will automatically clean up all unpacked source in `$HAB_CACHE_SRC_PATH` when it completes successfully or with a failure. To view the unpacked source requires you to pause the build during this phase.

The attach function can be added anywhere in your plan file to create this pause, or break point, during a build and allow you to explore. Using the `attach` function is a debugging technique that will assist you when developing Habitat packages.
```
do_build() {
    attach
}
```
pkg_name=knock-knock
pkg_origin=learn-chef
pkg_version="0.1.0"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_license=('Apache-2.0')
pkg_filename="${pkg_name}-${pkg_version}.tar.gz"
pkg_shasum="$(cat /src/CHECKSUM)"

do_download() {
    cp /src/${pkg_filename} $HAB_CACHE_SRC_PATH
}

do_build() {
    attach
}

- Without a pkg_source setting defined in the plan, the current working directory within the do_build function is /src. However, the unpacked source code exists in $HAB_CACHE_SRC_PATH/$pkg_name-$pkg_version. Examine the unpacked source code at $HAB_CACHE_SRC_PATH/$pkg_name-$pkg_version
`ls $HAB_CACHE_SRC_PATH/$pkg_name-$pkg_version`
```
Cargo.toml  README  src
```
- view the contents of the README file
`cat $HAB_CACHE_SRC_PATH/$pkg_name-$pkg_version/README`
```
# Build Instructions

* Install Rust
* To build, run `cargo build --release`
* To install, copy the binary found at `target/release/knock-knock`
```
- Now you know how the application is built. Halt the build process by entering the exit-program command.

Update the plan to define a build dependency on `core/rust`, add a runtime dependency on `core/gcc-libs`, and change the `do_build`function to move into the unpacked source directory and run the cargo command.
```
pkg_build_deps=( core/rust )
pkg_deps=( core/gcc-libs )

do_build() {
    cd $HAB_CACHE_SRC_PATH/$pkg_name-$pkg_version
    cargo build --release
}
```
###### Install source
```
do_install() {
    cd $HAB_CACHE_SRC_PATH/$pkg_name-$pkg_version
    mkdir -p $pkg_prefix/bin
    cp target/release/$pkg_name $pkg_prefix/bin
}
```

enter studio, run `build`

###### Patching source code

do_download() {
    cp /src/${pkg_filename} $HAB_CACHE_SRC_PATH
}

do_build() {
    cd $HAB_CACHE_SRC_PATH/$pkg_name-$pkg_version
    attach
    cargo build --release
}

do_install() {
    cd $HAB_CACHE_SRC_PATH/$pkg_name-$pkg_version
    mkdir -p $pkg_prefix/bin
    cp target/release/$pkg_name $pkg_prefix/bin
}

When the build stops at the attach function, `cp src/main.rs /src`
- a copy of main.rs now exists in the project directory, update this file (/src/main.rs) to fix the issue - i.e. replace Orderin with Ordering.

- within the paused build, run the `diff src/main.rs /src/main.rs` command to generate the difference
```
[1] knock-knock(do_build)> diff src/main.rs /src/main.rs
--- src/main.rs
+++ /src/main.rs
@@ -1,5 +1,5 @@
 use std::io;
-use std::cmp::Orderin;
+use std::cmp::Ordering;

 fn main() {
     println!("Knock, knock!");
```
- Run the diff command again, but export the results to a file within the /src directory.
`diff src/main.rs /src/main.rs > /src/$pkg_name-$pkg_version-ordering.patch`

-The patch file has been created. Apply the patch.
`patch -p1 < /src/$pkg_name-$pkg_version-ordering.patch`
```
[3] knock-knock(do_build)> patch -p1 < /src/$pkg_name-$pkg_version-ordering.patch
patching file src/main.rs
```
- With patching, the default behavior is to look for the file to patch from within the directory you execute the patch command. For that to work, you would need to change to the `$HAB_CACHE_SRC_PATH/$pkg_name-$pkg_version/src` directory and run `patch < /src/$pkg_name-$pkg_version-ordering.patch`.

When you want to preserve some or all of the file path provided in the patch file you use the -p or strip flag. The -p flag will strip away the specified number of directory components from the path in the patch file. Recall the diff displayed on the second line +++ /src/main.rs. If you were to use:

`-p0`, the path would remain intact and attempt to patch a file named /src/main.rs
`-p1`, the path would remove the / and attempt to patch a file named src/main.rs
`-p2`, the patch would remove the /src/ and attempt to patch a file named main.rs
From within the paused build, run the exit command to continue the build execution. The application should successfully build the package. This tells you that the patch you created and applied will successfully build the application.

* Update the plan to remove attach and include the patch command.
```
do_build() {
    cd $HAB_CACHE_SRC_PATH/$pkg_name-$pkg_version
    patch -p1 < /src/$pkg_name-$pkg_version-ordering.patch
    cargo build --release
}

do_install() {
    cd $HAB_CACHE_SRC_PATH/$pkg_name-$pkg_version
    mkdir -p $pkg_prefix/bin
    cp target/release/$pkg_name $pkg_prefix/bin
}
```

###### Packaging a command-line application
- While the package successfully builds **it still does not provide access to the binary knock-knock**. You can verify that by running the `hab pkg binlink` command.
`hab pkg binlink mbohl/knock-knock`  -no output

- A plan can define an array of directories within the package where binaries can be found. This array is assigned to the `pkg_bin_dirs` setting. The build will automatically create all the pkg_bin_dirs directories.

Update the plan file to set the pkg_bin_dirs to the bin directory and remove the directory creation in the do_install function.
```
pkg_name=knock-knock
pkg_origin=learn-chef
pkg_version="0.1.0"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_license=('Apache-2.0')
pkg_filename="${pkg_name}-${pkg_version}.tar.gz"
pkg_shasum="$(cat /src/CHECKSUM)"
pkg_build_deps=( core/rust )
pkg_deps=( core/gcc-libs )
pkg_bin_dirs=( bin )
```
