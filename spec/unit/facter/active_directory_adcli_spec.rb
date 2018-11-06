require 'spec_helper'

describe 'active_directory_adcli' do
  before :each do
    Facter.clear
  end

  context 'adcli command exists' do
    before :each do
      Facter.stubs(:value).with(:networking).returns({'domain' => 'test.case'})
      Facter::Core::Execution.stubs(:exec).with('uname -s').returns('Linux')
      Facter::Util::Resolution.stubs(:which).with('adcli').returns('/usr/sbin/adcli')
    end

    context 'and adcli info <domain> returns ok' do
      let(:expected_file) { File.read('spec/expected/adcli') }

      it 'should convert the output to a hash' do
        Facter::Core::Execution.stubs(:exec).with('/usr/sbin/adcli info test.case').returns(expected_file)
        expected_hash = {
          'test.case' => {
            'client-software'  => 'sssd',
            'configured'       => 'kerberos-member',
            'domain-name'      => 'test.case',
            'login-formats'    => '%U@test.case',
            'login-policy'     => 'allow-realm-logins',
            'realm-name'       => 'TEST.CASE',
            'required-package' => 'samba-common-tools',
            'server-software'  => 'active-directory',
            'type'             => 'kerberos'
          }
        }
        expect(Facter.fact(:active_directory).value).to eq(expected_hash)
      end
    end
  end
end
