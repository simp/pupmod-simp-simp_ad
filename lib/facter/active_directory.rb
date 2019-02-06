# Return a hash of the output of ``realm list``, if the realm command exists
#
Facter.add(:active_directory) do
  confine :kernel => 'Linux'

  realm_exec = Facter::Core::Execution.which('realm')
  adcli_exec = Facter::Core::Execution.which('adcli')

  # prefer realm, but it's ok if we have to use adcli
  confine do
    realm_exec || adcli_exec
  end

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
        if domain_data.has_key? key
          domain_data[key] = [domain_data[key], value].flatten
        else
          domain_data[key] = value
        end
      end
      domains[domain_name] = domain_data
    end

    domains[nil] = nil
    domains.compact
  end

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

    domains[nil] = nil
    domains.compact
  end

  def get_status(realm,adcli)
    realm_connected = !realm['configured'].nil?
    adcli_connected = adcli.values.first['domain-controller-usable'] == 'yes'

    if realm_connected || adcli_connected
      'connected'
    else
      'disconnected'
    end
  end

  setcode do
    domain = Facter.value(:domain)
    adcli = {}
    realm = {}
    first_realm = {}

    if !adcli_exec.nil?
      adcli_resp = Facter::Core::Execution.exec("#{adcli_exec} info #{domain}", timeout: 15)
      adcli      = parse_adcli(adcli_resp)
    end

    if !realm_exec.nil?
      realm_resp  = Facter::Core::Execution.exec("#{realm_exec} list", timeout: 15)
      realm       = parse_realm(realm_resp)
      first_realm = realm.values.first
    end

    # require 'pry';binding.pry
    out = {}
    out['domain'] = first_realm['domain-name'] || adcli.keys.first
    out['status'] = get_status(first_realm,adcli)
    out['realm']  = realm
    out['adcli']  = adcli

    out
  end
end
