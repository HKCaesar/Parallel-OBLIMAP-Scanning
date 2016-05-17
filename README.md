# Parallel-OBLIMAP-Scanning
Create a parallel implementation of OBLIMAP's scanning phase to enable rapid coupling of ice models with General Circulation Models (GCM) using adaptive grids

# Scientific motivation
Ice caps are part of the climate system and interact with the atmosphere and
ocean via various feedback mechanisms. In order to simulate this coupled
system General Circulation Models (GCM's) are coupled with ice dynamical
models. Our OBLIMAP-package is designed for this purpose and after its first
open source release (see http://www.geosci-model-dev.net/3/13/2010/gmd-3-13-2010.html) 
we will submit OBLIMAP 2.0 as a GMD model paper including the
code and a manual this spring. With OBLIMAP 2.0 fast embedded on-line
coupling of an ice model within a GCM is now possible due to a dramatic
performance gain.

# Coding task as initially intended: the computational challenge
OBLIMAP 2.0 is a sequential code and consists of two main phases: the
scanning phase and the fast mapping phase. Despite the large performance gain
for the scanning phase, it would be computational expensive if frequent coupling
requires the scanning phase over and over again. For non-adaptive grids the
scanning phase is only once required (as preprocessing), but for adaptive grids
the scanning phase would be required for each adaptation of the grid.

By combining the current fast scanning mode with a parallel MPI implementation
we expect that the time consumption of OBLIMAP's scanning phase reduces
sufficiently, in order to allow on-line coupling with adaptive grids, which we expect
to be a near future demand. Using more processors the fast scan method could be left 
out totally, and the full scan method will be parallelized using one processor for each 
destination grid point. The latter approach holds even for unstructered grids.

# Code
The OBLIMAP 1.0 code (release 2010) is available at the Github project: https://github.com/treerink/oblimap-1.0
The OBLIMAP 2.0 code and manual (release 2016) are available at the Github project: https://github.com/treerink/oblimap-2.0
In this project OBLIMAP 2.0 will be subject of parallelization.

# Data formats and data links
OBLIMAP uses Netcdf files, maximum size of the files is a few GB's.

# Tools
OBLIMAP is written in Fortran90 and later, using netcdf. OBLIMAP compiles and
runs for instance with gfortran and ifort. The netcdf files are usually visualized
with ncview and by python scripts. In certain cases the preprocessing uses nco
tools. We expect that the parallelization requires MPI, but for instance open-mp 
might be suited as well, we hope to find out such things.

See [this](https://help.github.com/articles/basic-writing-and-formatting-syntax/) page for help on formatting README files like this one on GitHub
