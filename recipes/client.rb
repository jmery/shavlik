#
# Cookbook:: shavlik
# Recipe:: client
#
# Copyright:: 2017, The Authors, All Rights Reserved.

install_file = 'STPlatformUpdater.exe'
server = 'shavlik'
port = '3121'
policy = 'My_Agent_Policy'
auth = 'PASSPHRASE'
passphrase = 'welcome' # POC only; should be secured in chef-vault

remote_file "#{Chef::Config['file_cache_path']}/#{install_file}" do
  source "https://s3.amazonaws.com/jmery/aig/#{install_file}"
  checksum '01b4f38ec7afcf4f40e1148466a6457f53acbc5f8bbed5cfee08abb267bd7a86'
  action :create
end

windows_package 'Shavlik Protect Agent' do
  source "#{Chef::Config['file_cache_path']}/#{install_file}"
  installer_type :custom
  options "/wi:\"/qn /l*v install.log SERVERURI=https://#{server}:#{port} POLICY=#{policy} AUTHENTICATIONTYPE=#{auth} PASSPHRASE=#{passphrase}\""
end

# Gems we need to query Shavlik for status from chef
chef_gem 'dbi'
chef_gem 'dbd-odbc'
chef_gem 'ruby-odbc'
