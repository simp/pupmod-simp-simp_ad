# Force nodes to leave an AD domain
#
# @param nodes
#   The normal nodes definition for plans
#
# @param domain
#   The specific AD domain to leave, defaulting to the domain of the system
#
# @param options
#   Hash of other options for the `ipa-client-install` command. If the
#   option doesn't need a value, (e.g., the `debug` option), set the
#   value of the setting to Undef.
#
#   If the `stdin_password` option is set, set `password_from_stdin` to
#   fake interactivity with the realm join command and send a password
#   over plaintext. Please see the `one-time-password` option as a more
#   secure alternative.
#
plan simp_ad::leave (
  TargetSpec $nodes,
  Simplib::Hostname $domain = $facts['networking']['domain'],
  Hash $options = {},
) {
  # convert the hash into a string
  $expanded_options = simplib::hash_to_opts(
    $options,
    { 'repeat' => 'repeat' }
  )

  run_command("realm leave --unattended ${domain} ${expanded_options}")
}
