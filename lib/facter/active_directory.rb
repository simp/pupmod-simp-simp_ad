# Return a hash of the output of ``realm list``
#
Facter.add(:active_directory) do
  confine :kernel => 'Linux'

  realm = Facter::Core::Execution.which('realm')
  confine { realm }

  setcode do
    # domain   = Facter.value(:domain)
    # response = Facter::Core::Execution.exec("#{realm} list -v #{domain}")
    response = Facter::Core::Execution.exec("#{realm} list")

    domains = {}
    domain_name = nil
    domain_data = {}
    response.lines.each do |line|
      if line =~ /^\w+/
        domain_name = line.strip
        domain_data = {}
      else
        key, value = line.split(': ').map(&:strip)
        domain_data[key] = value
      end
      domains[domain_name] = domain_data
    end

    domains
  end
end
