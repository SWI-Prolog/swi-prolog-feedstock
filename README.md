# Building SWI-Prolog using Conda

This   repository   is   an   attempt  to   build   SWI-Prolog   using
[Conda](https://docs.conda.io/).  We use `conda-forge`  to get all the
dependencies.  The  `anaconda` suite  can build SWI-Prolog  except for
xpce  that depends  on  several  X11 packages  that  do  not exist  in
`anaconda` and the native UUID library that depends on `ossuuid`.

Platform notes

## Linux

Initially build and tested on Linux.   Provides a complete system.

## MacOS M1

Issues

  - `ossuuid` is missing, so using partial pure Prolog UUID library
    rather than native
  - `libdb` package provides X64 `.dylib` libraries.  Dropped `bdb` package
  - Building using GMP crashes.  This is also the problem for the non-conda
    build, so we revert to the bundled LibBF


## Install miniconda

Download and  prepare miniconda.   Note that we  require `conda-forge`
for packages.   As is, this  conflicts with `defaults` for  building a
package, claiming a merge conflict  related to mpi.  There are several
suggesting for working  around that.  For me it worked  to disable the
`defaults` channel.

Download from https://docs.conda.io/projects/miniconda/en/latest/

    conda config --append channels conda-forge
    conda config --set channel_priority strict
    conda config --remove channels defaults
    conda upgrade -c conda-forge --all
    conda install conda-build
    conda install conda-verify


## Building

    conda build . 2>&1 | tee build.log
    conda create -n swipl
    conda activate swipl
    conda install --use-local swi-prolog
    conda build purge


## Some Conda doc links

  - https://docs.conda.io/projects/conda-build/en/latest/user-guide/tutorials/build-pkgs.html
  - https://docs.conda.io/projects/conda-build/en/stable/user-guide/recipes/debugging.html
  - https://conda-forge.org/docs/maintainer/knowledge_base.html
