# Ruby LibECP

Ruby LibECP is a wrapper around LibECP, an elliptic-curve cryptography library
for producing and verifying ECDSA signatures.


## Installation

Use the gem in a project managed with Bundler adding it into Gemfile:

    gem "cf-ruby-libecp"

### Build

This gem is a native extension gem. The native library will be compiled on your
platform automatically at install time.

The required packages to build the gem are:

- GMP, a multiprecision arithmetic library.
- GCC, a compiler for C, C++, Java, Fortan and other program code that can be
used in Unix.

#### Debian-based distributions

    $ sudo apt-get install libgmp3-dev build-essential

#### OS X with Homebrew

    $ brew install gmp

#### OS X with MacPorts

    $ sudo port install gmp


## Usage example

    require "libecp"

    LibEcp.private_key(LibEcp.gen_uid(1234), "coinfloor")


## Licence

Released under the Apache License Version 2.0.
