#
# Cookbook:: shavlik
# Recipe:: scan
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# TODO: Only runs on the Protect server
# TODO: Get a list of nodes in the same or specified environments
# TODO: Use Shavlik PowerShell API to initiate a scan of said machines using `-EndpointNames` parameter of `Start-PatchScan` command

nodes = search(:node, 'chef_environment:_default')

nodes.each do |node|
  puts "Node found: #{node['fqdn']}"

  if node['fqdn'].to_s.downcase != 'shavlik'
    powershell_script 'name' do
      code <<-EOH
      Import-Module STProtect

      $scan = Start-PatchScan -EndPointNames "#{node['fqdn']}"   -UseMachineCredentials

      $scan | Watch-PatchScan

      Write-Host "Scanning of Server set 1 Complete"

      $scanDetail = $scan | Get-PatchScan

      Write-Host "Server Set 1 - Final Details: "

      $scanDetail | Format-PatchScanTable

      # Identify the set of machines with missing patches.
      $machinesMissingPatches = $scanDetail.MachineStates | where {   $_.MissingPatches -ne 0}
      if ($machinesMissingPatches.Length -ne 0)
      {
        $totalMissingPatches = 0;
        $machinesMissingPatches | ForEach-Object { $totalMissingPatches +=        $_.MissingPatches}

        Write-Host "$totalMissingPatches total missing patches will be deployed.        Starting Deploy..."

        # $deploy = $scan | Start-PatchDeploy

        # $deploy | Watch-PatchDeploy | Format-Table
      }
      EOH
    end
  end
end
