# @summary Run ipa-client-install on puppet clients
#
# @note Not all parameters here are required. If the DNS is properly configured
#   on the host, nothing needs to be set besides $password. Be sure to read the
#   man page in ipa-client-install or the help for guidance
#
# @note This class supports adding a host to a domain and removing it, but not
#   changing it
#
# @see ipa-client-install(1)
#
# @param ensure
#   'present' to add host to an IPA domain, 'absent' to remove
#
# @param ip_address
#   IP address of host being connected
#
# @param hostname
#   Hostname of the host being connected
#
# @param password
#   The password used for joining. The password can be of one of two types:
#     * If $principal is set, this is the password relating to
#       that administrative user
#     * A one time password. A host-based one-time-password generated by
#       ``ipa host-add`` or the GUI
#
# @param principal
#   The administrative user krb5 principal that $password relates to, if the $password is not
#   a one time password
#
# @param server
#   IPA server to connect to
#
# @param domain
#   IPA Domain
#
# @param realm
#   IPA Realm
#
# @param no_ac
#   Run without authconfig, defaults to true, appropriate on systems
#   using ``simp/pam``
#
# @param install_options
#   Hash of other options for the ``ipa-client-install`` command.  Any key
#   here that is also a class parameters will be overwritten with the value
#   of the corresponding class parameter. Also, if the option doesn't need a
#   value, (e.g., the `debug` option), just set the value of the setting to
#   Undef or nil in Hiera.
#
#   @see ``ipa-client-install --help``
#
# @param ipa_client_ensure
#   Ensure attribute of the package resource managing the ``ipa-client`` package
#
# @param admin_tools_ensure
#   Ensure attribute of the package resource managing the ``ipa-admintools``
#   package. Only applicable on EL6.
#
class simp_ad::client::install (
  Enum['present','absent']           $ensure,
  Optional[Array[Simplib::Hostname]] $server          = undef,
  Hash                               $install_options = {},
  String $ipa_client_ensure  = simplib::lookup('simp_options::package_ensure', { 'default_value' => 'installed' }),
  String $admin_tools_ensure = simplib::lookup('simp_options::package_ensure', { 'default_value' => 'installed' }),
) {
  contain 'simp_ad::client::packages'

  # convert the hash into a string
  $expanded_options = simplib::hash_to_opts(
    $install_options,
    { 'repeat' => 'repeat' }
  )


  if $ensure == 'present' {
    unless $facts['active_directory'] {
      exec { 'realm join':
        command   => strip("realm join --unattended ${expanded_options}"),
        logoutput => true,
        path      => ['/sbin','/usr/sbin'],
        require   => Class['simp_ad::client::packages']
      }
    }
  }
  else {
    exec { 'realm leave':
      command   => 'realm leave --unattended',
      logoutput => true,
      path      => ['/sbin','/usr/sbin'],
      require   => Class['simp_ad::client::packages'],
    }
  }
}
