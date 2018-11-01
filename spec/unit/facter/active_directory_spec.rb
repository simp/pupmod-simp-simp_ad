require 'spec_helper'

describe 'active_directory' do
  before :each do
    Facter.clear
  end

  context 'realm command exists' do
    before :each do
      Facter::Core::Execution.stubs(:exec).with('uname -s').returns('Linux')
      Facter::Util::Resolution.stubs(:which).with('realm').returns('/usr/sbin/realm')
    end

    context 'and realm list returns one realm' do
      let(:expected_file) { File.read('spec/expected/one_realm') }

      it 'should convert the output to a hash' do
        Facter::Core::Execution.stubs(:exec).with('/usr/sbin/realm list').returns(expected_file)
        expected_hash = {
          "test.case" => {
            "client-software"  => "sssd",
            "configured"       => "kerberos-member",
            "domain-name"      => "test.case",
            "login-formats"    => "%U@test.case",
            "login-policy"     => "allow-realm-logins",
            "realm-name"       => "TEST.CASE",
            "required-package" => "samba-common-tools",
            "server-software"  => "active-directory",
            "type"             => "kerberos"
          }
        }
        expect(Facter.fact(:active_directory).value).to eq(expected_hash)
      end
    end

    context 'and realm list returns two realms' do
      let(:expected_file) { File.read('spec/expected/two_realms') }

      it 'should convert the output to a hash with two keys' do
        Facter::Core::Execution.stubs(:exec).with('/usr/sbin/realm list').returns(expected_file)
        expected_hash = {
          "test.case" => {
            "client-software"  => "sssd",
            "configured"       => "kerberos-member",
            "domain-name"      => "test.case",
            "login-formats"    => "%U@test.case",
            "login-policy"     => "allow-realm-logins",
            "realm-name"       => "TEST.CASE",
            "required-package" => "samba-common-tools",
            "server-software"  => "active-directory",
            "type"             => "kerberos"
          },
          "test2.case" => {
            "client-software"  => "sssd",
            "configured"       => "kerberos-member",
            "domain-name"      => "test2.case",
            "login-formats"    => "%U@test2.case",
            "login-policy"     => "allow-realm-logins",
            "realm-name"       => "TEST2.CASE",
            "required-package" => "samba-common-tools",
            "server-software"  => "active-directory",
            "type"             => "kerberos"
          }
        }
        expect(Facter.fact(:active_directory).value).to eq(expected_hash)
      end
    end
  end
end
