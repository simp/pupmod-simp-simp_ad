require 'spec_helper'

describe 'simp_ad::client::install' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts
      end

      # context 'with ensure => present and $facts[ipa] absent' do
      #   context 'with minimal parameters' do
      #     let(:params) {{
      #       ensure: 'present'
      #     }}
      #     it { is_expected.to compile.with_all_deps }
      #     it { is_expected.to create_class('simp_ad::client::install') }
      #     it { is_expected.to create_package('realmd') }
      #     it { is_expected.to create_package('adcli') }
      #     it { is_expected.to create_package('samba-common-tools') }
      #     it { is_expected.to create_exec('realm join') \
      #       .with_command('realm join --unattended') }
      #   end
      #
      #   context 'with all explicit parameters' do
      #     let(:params) {{
      #       ensure: 'present',
      #       server: 'ad.example.local',
      #       install_options: { 'verbose' => :undef },
      #       samba_ensure: 'latest',
      #       realmd_ensure: 'latest',
      #       adcli_ensure: 'latest',
      #     }}
      #     it { is_expected.to compile.with_all_deps }
      #     expected = [
      #       'realm join --unattended',
      #       'ad.example.local',
      #       '--verbose',
      #     ].join(' ')
      #     it { is_expected.to create_exec('realm join').with_command(expected) }
      #   end
      # end
      #
      # context 'with ensure => present and $facts[ad] present' do
      #   let(:params) {{
      #     ensure: 'present',
      #     server: 'testad.example.local'
      #   }}
      #   let(:facts) { super().merge(
      #     active_directory: {
      #       domain: 'testad.example.local'
      #     }
      #   )}
      #
      #   it { is_expected.to compile.with_all_deps }
      #   it { is_expected.not_to create_exec('realm join') }
      #
      #   context 'but it has the wrong domain' do
      #     let(:facts) { super().merge(
      #       active_directory: {
      #         domain: 'ad.example.local'
      #       }
      #     )}
      #     it { is_expected.to compile.and_raise_error(/This host is already a member of domain/) }
      #   end
      # end
      #
      # context 'with parameters from a hash' do
      #   let(:params) {{
      #     ensure: 'present',
      #     password: 'password',
      #     server: ['ad.domain.example.local'],
      #     domain: 'domain.example.local',
      #     realm: 'DOMAIN.EXAMPLE.LOCAL',
      #     install_options: {
      #       mkhomedir: :undef,
      #       keytab: '/etc/krb5.keytab'
      #     }
      #   }}
      #   it { is_expected.to compile.with_all_deps }
      #   it { is_expected.to create_class('simp_ad::client::install') }
      #   it { is_expected.to create_package('realmd') }
      #   it { is_expected.to create_package('adcli') }
      #   it { is_expected.to create_package('samba-common-tools') }
      #   expected = [
      #     'realm join --unattended',
      #     '--mkhomedir',
      #     '--keytab=/etc/krb5.keytab',
      #   ].join(' ')
      #   it { is_expected.to create_exec('realm join').with_command(expected) }
      # end
      #
      # context 'with ensure => absent' do
      #   let(:params) {{
      #     ensure: 'absent'
      #   }}
      #   it { is_expected.to compile.with_all_deps }
      #   it { is_expected.to create_package('realmd') }
      #   it { is_expected.to create_package('adcli') }
      #   it { is_expected.to create_package('samba-common-tools') }
      #   it { is_expected.not_to create_exec('realm join') }
      #   it { is_expected.to create_exec('realm leave') \
      #     .with_command('realm leave --unattended --uninstall') }
      #   it { is_expected.to create_reboot_notify('realm leave') }
      # end
    end
  end
end
