require 'tiny_tds'

print 'test'

client = TinyTds::Client.new username: 'vagrant@shavlik',
                             password: 'vagrant',
                             host: 'shavlik',
                             port: 1433,
                             database: 'Protect'

results = client.execute("SELECT DISTINCT
   patch.[QNumber] AS [QNumber],
   patch.[Bulletin] AS [Bulletin Id],
   patch.[ReleasedOn] AS [Released On],
   product.[Name] AS [Product Name],
   product.[ServicePackName] AS [Service Pack Name],
   installState.[Value] AS [Install state],
   patchScan.[StartedOn] AS [ScanDate],
   machine.[Name] AS [Machine Name],
   machine.[Domain] AS Domain,
   locale.[name] AS [Language Name],
   machine.[LastKnownIP] AS [IP Address],
   machine.[LastPatchAssessedOn] AS [Scan Date],
   detectedPatchState.[InstalledOn] AS [Installed On]
   FROM
      [Reporting].[PatchScan] AS patchScan
   INNER JOIN
      [Reporting].[AssessedMachineState] AS assessedMachineState ON
          assessedMachineState.[PatchScanId] = patchScan.[Id]
   INNER JOIN
      [Reporting].[Machine] AS machine ON
          machine.[LastAssessedMachineStateId] = assessedMachineState.[id]
   INNER JOIN
      [Reporting].[DetectedPatchState] AS detectedPatchState ON
          detectedPatchState.[AssessedMachineStateId] =
   assessedMachineState.[Id]
   INNER JOIN
      [Reporting].[Patch] AS patch ON
          detectedPatchState.[PatchId] = patch.[Id]
   INNER JOIN
      [Reporting].[InstallState] AS installState ON
          installState.[Id] = detectedPatchState.[InstallStateId]
   INNER JOIN
      [Reporting].[Product] AS product ON
          product.[Id] = detectedPatchState.[ProductId]
   LEFT OUTER JOIN
      [sys].[syslanguages] AS locale ON
          machine.[Language] = locale.[lcid] /* machine.[Language] is used
   to index into [sys].[syslanguages] */
   WHERE
   (
   detectedPatchState.[InstallStateId] = 3 OR /* Installed Patch */
          detectedPatchState.[InstallStateId] = 4
   ) ORDER BY
       patch.[Bulletin],
      patch.[QNumber],
      machine.[Name]")

results.each do |row|
  puts row
end
