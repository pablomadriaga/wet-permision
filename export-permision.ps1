#Get the Permissions 


$sourceVI = Read-Host -Prompt "Incregre el Vcenter"


#Conectarse al Vcenter
try {
    Connect-VIServer $sourceVI -ErrorAction Stop | Out-Null
}#Fin del Try
catch {
    Write-Host "No se puede conectar con el servidor" -ForegroundColor Yellow
    Break
}#Fin del Catch
 

$datacenter = Read-Host -Prompt "Incregre el Datacenter"

$folderperms = get-datacenter $datacenter -Server $sourceVI | Get-Folder | Get-VIPermission
$vmperms = Get-Datacenter $datacenter -Server $sourceVI | get-vm | Get-VIPermission

$permissions = get-datacenter $datacenter -Server $sourceVI | Get-VIpermission

        $report = @()
            foreach($perm in $permissions){
               $row = "" | select EntityId, FolderName, Role, Principal, IsGroup, Propagate
               $row.EntityId = $perm.EntityId
               $Foldername = (Get-View -id $perm.EntityId).Name
               $row.FolderName = $foldername
               $row.Principal = $perm.Principal
               $row.Role = $perm.Role
               $row.IsGroup = $perm.IsGroup
               $row.Propagate = $perm.Propagate
               $report += $row
            }

            foreach($perm in $folderperms){
               $row = "" | select EntityId, FolderName, Role, Principal, IsGroup, Propagate
               $row.EntityId = $perm.EntityId
               $Foldername = (Get-View -id $perm.EntityId).Name
               $row.FolderName = $foldername
               $row.Principal = $perm.Principal
               $row.Role = $perm.Role
               $row.IsGroup = $perm.IsGroup
               $row.Propagate = $perm.Propagate
               $report += $row
            }

            foreach($perm in $vmperms){
                $row = "" | select EntityId, FolderName, Role, Principal, IsGroup, Propagate
                $row.EntityId = $perm.EntityId
                $Foldername = (Get-View -id $perm.EntityId).Name
                $row.FolderName = $foldername
                $row.Principal = $perm.Principal
                $row.Role = $perm.Role
                $row.IsGroup = $perm.IsGroup
                $row.Propagate = $perm.Propagate
                $report += $row
            }

        $report | export-csv "c:\perms-$($datacenter).csv" -NoTypeInformation


Disconnect-VIServer * -Force -Confirm:$false