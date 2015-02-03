# Ruby LibECP

Ruby LibECP is a wrapper around the LibECP library, an elliptic-curve
cryptography library for signing, verifying signatures and generating keys.


## Installation

Use the gem in a project managed with Bundler adding it into Gemfile:

    gem "cf-ruby-libecp"


## Usage example

    require "libecp"

    LibEcp.private_key(LibEcp.gen_uid(1234), "coinfloor")


### Build

In order to use this gem, you need to compile the native library on your
platform, creating the `libecp.so` file.

The required libraries to build the `libecp.so` file are:

- GMP, a multiprecision arithmetic library.
- GCC, a compiler for C, C++, Java, Fortan and other program code that can be
used in Unix.

You must check out the submodule by executing this command:

    $ git submodule update --init

#### Debian based distributions

    $ sudo apt-get install libgmp3-dev build-essential

    $ make lib/libecp.so

#### OS X with Homebrew

    $ brew install gmp

    $ make lib/libecp.so

#### OS X with MacPorts

    $ sudo port install gmp

    $ make lib/libecp.so


## Licence

Released under the Apache License Version 2.0.
