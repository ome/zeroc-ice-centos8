CentOS 8 Zeroc Ice Builder
==========================

Builds Zeroc Ice 3.6 for CentOS 8.
Ice 3.6 is built from source and a wheel is also created.
Includes libdb 5.3.

This can be used to create installable binary packages as an alternative to compiling from source using pip.

    docker build -t builder .
    docker run --rm -v $PWD/dist:/dist builder

To build a different version of Ice:

    docker run --rm -v $PWD/dist:/dist builder VERSION

Packages will be copied to `$PWD/dist`.
