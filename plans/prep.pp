plan simp_ad::prep (
  TargetSpec $nodes,
  Boolean $install_puppet = false,
) {
  # Install the puppet-agent package if Puppet is not detected.
  # Copy over custom facts from the Bolt modulepath.
  # Run the `facter` command line tool to gather node information.
  if $install_puppet {
    $nodes.apply_prep
  }

  apply($nodes) {
    package {
      'adcli':              ensure => 'installed';
      'oddjob':             ensure => 'installed';
      'oddjob-mkhomedir':   ensure => 'installed';
      'samba-common-tools': ensure => 'installed';
      'sssd':               ensure => 'installed';
    }
    if $facts['os']['release']['major'] >= 7 {
      package { 'realmd': ensure => 'insalled' }
    }
  }

  run_command("realm join --unattended ${server} ${expanded_options}")
}
