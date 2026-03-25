# Neko containers

A set of containers for building Neko with cpu, CUDA, HIP, and opencl.
The intention is to mimic the builds we have at Github Actions and enable easy local testing against
different architectures.

## Preliminaries

* Install apptainer

  See https://apptainer.org/docs/admin/main/installation.html

  For Ubuntu
````
sudo apt-get update
sudo apt-get install -y wget
wget https://github.com/apptainer/apptainer/releases/download/v1.1.0/apptainer_1.1.0_amd64.deb
sudo apt-get install -y ./apptainer_1.1.0_amd64.deb
````

* Set the `APPTAINER_BIND` environmental variable

  Here you need to bind two directories, the one where you have neko's source, and the one where neko will be installed.
  The former is bound to /neko on the container and the latter to /neko_install.
  For example, this is how it can look in `bsahrc`
 
  `export APPTAINER_BIND="/home/username/neko:/neko,/home/username/neko_install:/neko_install"`

  So, here `/home/username/neko` is where you have your Neko repo, and `/home/username/neko_install` is where Neko
  will be installed

* Build the containers

  Clone this repo and then run the `build_all` script. This will build all the containers (.sif files).
  This will take quite a while!

* Set `NEKO_CONTAINER_DIR`

  Set this variable to the location of this repo; in your bashrc.

* Add the `bin` directory in the repo to your path.
  `export PATH="$NEKO_CONTAINER_DIR/bin:$PATH"` also in your bashrc.

  This is optional, since the scripts in bin just run the container, which execute the compilation as defined
  in the container .def file.

## macOS via Lima

Apptainer does not run natively on macOS, so on macOS you need to run it inside a Linux VM. A simple setup is to use
Lima and do all container builds from inside the guest.

1. Install Lima on the macOS host. Consult their homepage for instructions.

2. Create and start a Linux VM.

   A plain Ubuntu VM is enough. For example:

````
limactl start template://ubuntu
````

   If you want the VM name used below, create it as `apptainer`.

3. Enter the VM and install Apptainer there.

````
limactl shell apptainer
sudo apt-get update
sudo apt-get install -y apptainer
````

   If your Ubuntu release does not provide a suitable Apptainer package, install it by another Linux-supported method,
   but make sure you use binaries built for the guest architecture. On Apple Silicon, the Lima guest is typically
   `arm64/aarch64`.

4. Build and run the containers from inside the Lima guest, not from macOS.

   The macOS home directory is mounted into the VM, so your checkout should appear under `/Users/...` inside Lima as
   well. Then build as usual:

````
limactl shell apptainer
cd /Users/username/path/to/neko_containers
./build_all.sh
````

5. Set the bind mounts in the Lima shell before using the helper scripts.

````
export APPTAINER_BIND="/Users/username/path/to/neko:/neko,/Users/username/path/to/neko_install:/neko_install"
export NEKO_CONTAINER_DIR="/Users/username/path/to/neko_containers"
export PATH="$NEKO_CONTAINER_DIR/bin:$PATH"
````

6. Compile Neko from inside the Lima guest.

````
limactl shell apptainer
neko_compile_cpu
````

Notes for Apple Silicon:

* `HIP/ROCm` containers do not currently build in an `arm64` Lima guest because AMD's Ubuntu repositories used here
  only provide `amd64` packages.
* The `Intel oneAPI` container also does not build in an `arm64` Lima guest because Intel's apt repository does not
  provide the required packages for that architecture.
* `CPU`, `CUDA`, and `OpenCL` containers can still be built in Lima on macOS, subject to the hardware and drivers
  available inside the guest.

## Building Neko
The scripts in the bin directory will execute compilation for a given architecture.
For example, running `neko_compile_cuda` will build with CUDA, etc.
