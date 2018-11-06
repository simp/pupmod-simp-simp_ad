# Return a hash of the output of ``realm list``, if the realm command exists
#
Facter.add(:active_directory) do
  has_weight 100

  confine :kernel => 'Linux'

  realm = Facter::Core::Execution.which('realm')
  confine { realm }

  def parse_realm(response)
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

    domains.compact
  end

  setcode do
    response = Facter::Core::Execution.exec("#{realm} list")

    parse_realm(response)
  end
end
