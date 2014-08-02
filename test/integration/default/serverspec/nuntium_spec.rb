require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe file('/u/apps/nuntium') do
  it { should be_directory }
end

