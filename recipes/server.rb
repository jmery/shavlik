#
# Cookbook:: shavlik
# Recipe:: server
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Prereqs
# Visual C++ 2015 x64 (probably just runtime)
# SKIP - No reboot required; Shavlik installs this just fine
# windows_package node['shavlik']['vc_runtime']['name'] do
#   # checksum node['shavlik']['vc_runtime']['sha256sum']
#   source node['shavlik']['vc_runtime']['url']
#   installer_type :custom
#   options '/q'
# end

# WMF 4.0
include_recipe 'powershell::powershell4'

# .NET Framework 4.6.2
ms_dotnet_framework '4.6.2' do
  action :install
  include_patches true
  perform_reboot true
  require_support true
end

install_file = 'ShavlikProtect_Alpha_9.3.3329.exe'

remote_file "#{Chef::Config['file_cache_path']}/#{install_file}" do
  source "https://s3.amazonaws.com/jmery/aig/#{install_file}"
  checksum '482b3f9c7ce4481402f167a50c30a2ad46a9d7c8f47ef36328c9a68540d76307'
  action :create
end

# TODO: Firewall rule for port 3121 & 3122 for agent communication

windows_package 'Shavlik Protect' do
  source "#{Chef::Config['file_cache_path']}/#{install_file}"
  installer_type :custom
  options '/quiet'
end

# SQL Server 2014 Express
# node.default['sql_server']['accept_eula'] = true
# node.default['sql_server']['version'] = '2014'
# node.default['sql_server']['server_sa_password'] = 'Cod3(an!' # Testing only; # should be encrypted in chef-vault
#
# include_recipe 'sql_server::server'
