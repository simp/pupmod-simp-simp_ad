require 'spec_helper'
require 'yaml'

def yaml_load(file)
  YAML.safe_load(File.read("spec/unit/facter/expected/#{file}.yaml"))
end

describe 'active_directory' do
# describe Facter::Util::Fact do
  before :each do
    Facter.clear
    Facter.fact(:domain).stubs(:value).returns('test.case')
    Facter::Core::Execution.expects(:exec).with('uname -s').returns('Linux')
  end

  context 'neither commands' do
    it 'should be nil' do
      Facter::Core::Execution.expects(:which).with('realm').returns(nil)
      Facter::Core::Execution.expects(:which).with('adcli').returns(nil)

      expect(Facter.fact(:active_directory).value).to eq(nil)
    end
  end

  context 'adcli but no realm command' do
    it 'have a fact that matches the expected' do
      adcli_file    = File.read('spec/expected/adcli')
      expected_hash = yaml_load('adcli_only')

      Facter::Core::Execution.expects(:which).with('realm').returns(nil)
      Facter::Core::Execution.expects(:which).with('adcli').returns('/usr/sbin/adcli')
      Facter::Core::Execution.expects(:exec).with('/usr/sbin/adcli info test.case', timeout: 15).returns(adcli_file)

      expect(Facter.fact(:active_directory).value).to eq(expected_hash)
    end
  end


  context 'both commands exist' do
    it 'have a fact that matches the expected' do
      adcli_file    = File.read('spec/expected/adcli')
      realm_file    = File.read('spec/expected/two_realms')
      expected_hash = yaml_load('default')

      Facter::Core::Execution.expects(:which).with('realm').returns('/usr/sbin/realm')
      Facter::Core::Execution.expects(:which).with('adcli').returns('/usr/sbin/adcli')
      Facter::Core::Execution.expects(:exec).with('/usr/sbin/adcli info test.case', timeout: 15).returns(adcli_file)
      Facter::Core::Execution.expects(:exec).with('/usr/sbin/realm list', timeout: 15).returns(realm_file)

      expect(Facter.fact(:active_directory).value).to eq(expected_hash)
    end
  end
end
