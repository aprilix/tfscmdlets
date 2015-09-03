<#
#>
Function Remove-TfsTeamProjectCollection
{
	[CmdletBinding(ConfirmImpact="High", SupportsShouldProcess=$true)]
	Param
	(
		[Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
		[object] 
		$Collection,

		[Parameter()]
		[object] 
		$Server,
	
		[Parameter()]
		[timespan]
		$Timeout = [timespan]::MaxValue,

		[Parameter()]
		[System.Management.Automation.Credential()]
		[System.Management.Automation.PSCredential]
		$Credential
	)

	Process
	{
		$tpc = Get-TfsTeamProjectCollection -Collection $Collection -Server $Server -Credential $Credential

		if ($PSCmdlet.ShouldProcess($tpc.Name, "Delete Team Project Collection"))
		{
			Write-Progress -Id 1 -Activity "Delete team project collection" -Status "Deleting $($tpc.Name)" -PercentComplete 0
		
			try
			{
				$configServer = $tpc.ConfigurationServer
				$tpcService = $configServer.GetService([type] 'Microsoft.TeamFoundation.Framework.Client.ITeamProjectCollectionService')
				$collectionInfo = $tpcService.GetCollection($tpc.InstanceId)

				$collectionInfo.Delete()
			}
			finally
			{
				Write-Progress -Id 1 -Activity "Delete team project collection" -Completed
			}
		}
	}
}