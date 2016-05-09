# Parallel-OBLIMAP-Scanning
Create a parallel implementation of OBLIMAP's scanning phase to enable rapid coupling of ice models with General Circulation Models (GCM) using adaptive grids

# Decription
# Short 1 paragraph on the science motivation
Ice caps are part of the climate system and interact with the atmosphere and
ocean via various feedback mechanisms. In order to simulate this coupled
system General Circulation Models (GCM's) are coupled with ice dynamical
models. Our OBLIMAP-package is designed for this purpose and after its first
open source release (see http://www.geosci-model-dev.net/3/13/2010/gmd-3-13-2010.html) 
we will submit OBLIMAP 2.0 as a GMD model paper including the
code and a manual this spring. With OBLIMAP 2.0 fast embedded on-line
coupling of an ice model within a GCM is now possible due to a dramatic
performance gain.

# Short 1-2 paragraphs on the coding task as you see it now and/or describe the computational challenege in high level terms
OBLIMAP 2.0 is a sequential code and consists of two main phases: the
scanning phase and the fast mapping phase. Despite the large performance gain
for the scanning phase, it would be computational expensive if frequent coupling
requires the scanning phase over and over again. For non-adaptive grids the
scanning phase is only once required (as preprocessing), but for adaptive grids
the scanning phase would be required for each adaptation of the grid.

By combining the current fast scanning mode with a parallel MPI implementation
we expect that the time consumption of OBLIMAP's scanning phase reduces
sufficiently, in order to allow on-line coupling with adaptive grids, which we expect
to be a near future demand.

# Code
# Link to any existing code to be used along with a description
The code of the external OBLIMAP-package will be added on a new oblimap Github project. 
OBLIMAP's first release (2010) will be added as the basic version, therafter OBLIMAP 2.0
will follow.

# Data

# Link to any existing data sources that will be used and/or briefly describe the data sources (format, file size, total required data quantity 
Netcdf files, maximum size a few GB's.

# Tools

# List any tools you anticipate using (eg Python/MPI/etc) 
OBLIMAP is written in Fortran90 and later, using netcdf. OBLIMAP compiles and
runs for instance with gfortran and ifort. The netcdf files are usually visualized
with ncview and by python scripts. In certain cases the preprocessing uses nco
tools.

See [this](https://help.github.com/articles/basic-writing-and-formatting-syntax/) page for help on formatting README files like this one on GitHub
