require 'spec_helper'

describe 'nuntium::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it "installs git" do
    expect(chef_run).to install_package("git")
  end

  it "setup nuntium application" do
    expect(chef_run).to create_directory("/u/apps/nuntium")
  end
end
