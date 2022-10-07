# Neko containers

A set of containers for building Neko with cpu, CUDA, HIP, and opencl.
The intention is to mimic the builds we have at Github Actions and enable easy local testing against
differnte architectures.

## Preliminaries

* Install apptainer

See https://apptainer.org/docs/admin/main/installation.html

For Ubuntu

sudo apt-get update
sudo apt-get install -y wget
wget https://github.com/apptainer/apptainer/releases/download/v1.1.0/apptainer_1.1.0_amd64.deb
sudo apt-get install -y ./apptainer_1.1.0_amd64.deb

* Set the APPTAINER_BIND environmental variable

Here you need to bind two directories, the one where you have neko's source, and the one where neko will be installed.
The former is bound to /neko on the container and the latter to /neko_install.
For example, this is how it can look in `bsahrc`

`export APPTAINER_BIND="/home/username/neko:/neko,/home/username/neko_install:/neko_install"`

So, here `/home/username/neko` is where you have your Neko repo, and `/home/username/neko_install` is where Neko
will be installed

* Build the containers

Clone this repo and then run the `build_all` script. This will build all the containers (.sif files).
This will take quite a while!

* Set NEKO_CONTAINER_DIR
Set this variable to the location of this repo in your bashrc.

* Add the `bin` directory in the repo to your path.
`export PATH="$NEKO_CONTAINER_DIR/bin:$PATH"`

This is optional, since the scripts in bin just run the container, which execute the compilation as defined
in the container .def file.


## Building Neko
The scripts in the bin directory will execute compilation for a given architecture.
For example, running `neko_compile_cuda` will build with CUDA, etc.

