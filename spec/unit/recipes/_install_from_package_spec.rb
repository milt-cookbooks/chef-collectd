require 'spec_helper'

describe 'collectd::_install_from_package' do
  let(:chef_runner) { ChefSpec::Runner.new }
  let(:chef_run) { chef_runner.converge(described_recipe) }
  let(:node) { chef_runner.node }

  context 'on Debian' do
    before { node.automatic['platform_family'] = 'debian' }

    it 'should include apt on debian' do
      expect(chef_run).to include_recipe('apt')
    end
  end

  context 'on RedHat' do
    before { node.automatic['platform_family'] = 'rhel' }

    it 'should include yum-epel' do
      expect(chef_run).to include_recipe('yum-epel')
    end
  end

  it 'runs a execute kill collectdmon' do
    expect(chef_run).to_not run_execute('kill_collectdmon')
  end

  it 'installs the collectd package' do
    expect(chef_run).to install_package('collectd')
  end
end

