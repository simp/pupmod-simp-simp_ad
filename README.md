[![License](https://img.shields.io/:license-apache-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0.html)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/73/badge)](https://bestpractices.coreinfrastructure.org/projects/73)
[![Puppet Forge](https://img.shields.io/puppetforge/v/simp/simp_ad.svg)](https://forge.puppetlabs.com/simp/simp_ad)
[![Puppet Forge Downloads](https://img.shields.io/puppetforge/dt/simp/simp_ad.svg)](https://forge.puppetlabs.com/simp/simp_ad)
[![Build Status](https://travis-ci.org/simp/pupmod-simp-simp_ad.svg)](https://travis-ci.org/simp/pupmod-simp-simp_ad)


#### Table of Contents

* [Description](#description)
  * [This is a SIMP module](#this-is-a-simp-module)
* [Setup](#setup)
  * [What simp_ad affects](#what-simp_ad-affects)
* [Usage](#usage)
* [Development](#development)
  * [Acceptance tests](#acceptance-tests)

## Description

This is a module for managing ``simp_ad`` server and client installations.

### This is a SIMP module

This module is a component of the [System Integrity Management Platform](https://simp-project.com), a
compliance-management framework built on Puppet.

If you find any issues, they may be submitted to our [bug tracker](https://simp-project.atlassian.net/).

## Setup

### What simp_ad affects

The ``simp_ad`` module is quite minimal at the moment, it can only join and
remove hosts from an IPA domain.

## Usage

There are no puppet classes in this module yet. It only contains tasks.

### Tasks

Join a domain using `realm`:

```shell
bolt task run simp_ad::join --nodes <nodes> server=ad.example.com stdin_password=admin_password options='--verbose'
```

Other options can be added to the `options` parameter, like `options='--automatic-id-mapping=no --verbose'`

Leave a domain:

```shell
bolt task run simp_ad::leave --nodes <nodes> domain=<domain> options='--automatic-id-mapping=no --verbose'
```

## Development

Please read our [Contribution Guide](http://simp-doc.readthedocs.io/en/stable/contributors_guide/index.html).

### Acceptance tests

This module includes [Beaker](https://github.com/puppetlabs/beaker) acceptance
tests using the SIMP [Beaker Helpers](https://github.com/simp/rubygem-simp-beaker-helpers).
By default the tests use [Vagrant](https://www.vagrantup.com/) with
[VirtualBox](https://www.virtualbox.org) as a back-end; Vagrant and VirtualBox
must both be installed to run these tests without modification. To execute the
tests run the following:

```shell
bundle install
bundle exec rake beaker:suites
```

**NOTE:** When testing this module, you will probably want to run with
``BEAKER_destroy=no``, install the ``simp_ad`` client locally and connect to the
running VM to ensure proper functionality.

Please refer to the [SIMP Beaker Helpers documentation](https://github.com/simp/rubygem-simp-beaker-helpers/blob/master/README.md)
for more information.
