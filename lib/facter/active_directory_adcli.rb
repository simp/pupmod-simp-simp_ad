# Return a hash of the output of ``adcli info <domain>``, if the realm command
# doesn't exist, but ``adcli`` does. ``realm`` is preferred.
#
Facter.add(:active_directory) do
  has_weight 50

  confine :kernel => 'Linux'

  adcli = Facter::Core::Execution.which('adcli')
  confine { adcli }

  def parse_adcli(response)
    domains = {}
    domain_name = nil
    domain_data = {}
    response.lines.each do |line|
      case line
      when /^\[\w+\]/
      when /^\[\computer\]/
        next
      when /domain-name/
        domain_name = line.strip.split(' = ').last
        domain_data = {}
      else
        key, value = line.split(' = ').map(&:strip)
        domain_data[key] = value
      end
      domains[domain_name] = domain_data
    end

    domains.compact
  end

  setcode do
    domain   = Facter.value(:networking)['domain']
    response = Facter::Core::Execution.exec("#{adcli} info #{domain}")

    parse_adcli(response)
  end
end
