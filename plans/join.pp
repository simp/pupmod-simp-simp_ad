# Join nodes to an AD domain
#
# @param nodes
#   The normal nodes definition for plans
#
# @param server
#   The AD server to connect to
#
# @param options
#   Hash of other options for the `realm join` command. If the option doesn't
#   need a value, (e.g., the `debug` option), set the value of the setting to
#   Undef.
#
#   If the `stdin_password` option is set, set `password_from_stdin` to fake
#   interactivity with the realm join command and send a password over
#   plaintext. Please see the `one-time-password` option as a more secure
#   alternative.
#
plan simp_ad::join (
  TargetSpec $nodes,
  Simplib::Hostname $server,
  Hash $options = {},
) {

  # convert the hash into a string
  $expanded_options = simplib::hash_to_opts(
    $options,
    { 'repeat' => 'repeat' }
  )

  if $options['stdin_password'] {
    $password = $options['password_from_stdin']
    run_command("echo -n '${password}' | realm join --unattended ${server} ${expanded_options}")
  }
  else {
    run_command("realm join --unattended ${server} ${expanded_options}")
  }
}
