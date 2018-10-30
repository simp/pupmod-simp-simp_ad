# Class to contain packages required for simp::simp_ad::install
#
# @api private
#
class simp_ad::client::packages {
  assert_private()

  include 'oddjob'
  include 'oddjob::mkhomedir'

  package {
    'samba-common-tools': ensure => $simp_ad::client::install::samba_ensure;
    'realmd':             ensure => $simp_ad::client::install::realmd_ensure;
    'adcli':              ensure => $simp_ad::client::install::adcli_ensure;
  }

}
