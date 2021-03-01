#Get the Permissions 


$VI = Read-Host -Prompt "Incregre el Vcenter"


#Conectarse al Vcenter
try {
    Connect-VIServer $VI -ErrorAction Stop | Out-Null
}#Fin del Try
catch {
    Write-Host "No se puede conectar con el servidor" -ForegroundColor Yellow
    Break
}#Fin del Catch
 

$datacenter = Read-Host -Prompt "Incregre el Datacenter"





$permissions = @()
$permissions = Import-Csv "c:\perms-$($datacenter).csv"

foreach ($perm in $permissions) {
    $entity = ""
    $entity = New-Object VMware.Vim.ManagedObjectReference

    switch -wildcard ($perm.EntityId)
        {
            Folder* {
            $entity.type = "Folder"
            $entity.value = ((get-datacenter $datacenter | get-folder $perm.Foldername).ID).Trimstart("Folder-")
        }
            VirtualMachine* {
            $entity.Type = "VirtualMachine"
            $entity.value = ((get-datacenter $datacenter | Get-vm $perm.Foldername).Id).Trimstart("VirtualMachine-")
        }
}
$setperm = New-Object VMware.Vim.Permission
$setperm.principal = $perm.Principal
    if ($perm.isgroup -eq "True") {
        $setperm.group = $true
    } else {
        $setperm.group = $false
    }
$setperm.roleId = (Get-virole $perm.Role).id
    if ($perm.propagate -eq "True") {
        $setperm.propagate = $true
    } else {
        $setperm.propagate = $false
    }

$doactual = Get-View -Id 'AuthorizationManager-AuthorizationManager'
$doactual.SetEntityPermissions($entity, $setperm)
}

Disconnect-VIServer * -Force -Confirm:$false