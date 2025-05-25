#!/bin/bash
apptainer build neko_base.sif neko_base.def
apptainer build neko_cpu.sif neko_cpu.def
apptainer build neko_cuda.sif neko_cuda.def
apptainer build neko_hip.sif neko_hip.def
apptainer build neko_opencl.sif neko_opencl.def
