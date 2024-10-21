# PowerShell script to change/create VM attributes using PowerCLI on ESX v8

# Import PowerCLI module (uncomment if not already loaded in your environment)
# Import-Module VMware.PowerCLI

# Variables for VM attributes
$VMName = "VMHOSTNAME"
$SvrRITM = "RITM1234566"
$SvrRequester = "John Doe"
$AppPOC = "John Doe"
$AppPrj = "Special Db Server"
$AppSG = "DBA SQL Team"

# Function to set custom attributes for a VM
function Set-VMCustomAttributes {
    param (
        [Parameter(Mandatory=$true)]
        [string]$VMName,
        [hashtable]$Attributes
    )

    $vm = Get-VM -Name $VMName -ErrorAction SilentlyContinue

    if ($vm) {
        foreach ($key in $Attributes.Keys) {
            $attribute = Get-CustomAttribute -Name $key -ErrorAction SilentlyContinue
            if (-not $attribute) {
                New-CustomAttribute -Name $key -TargetType VirtualMachine
            }
            Set-Annotation -Entity $vm -CustomAttribute $key -Value $Attributes[$key]
        }
        Write-Host "Attributes set successfully for VM: $VMName"
    } else {
        Write-Host "VM not found: $VMName"
    }
}

# Connect to vCenter or ESXi host (replace with your server details)
# Connect-VIServer -Server your_server_name -User your_username -Password your_password

# Example usage (uncomment and modify as needed)
# $vmName = "YourVMName"
# $attributes = @{
#     "Server RITM" = $SvrRITM
#     "Server Requester" = $SvrRequester
#     "Application POC" = $AppPOC
#     "Application Project" = $AppPrj
#     "Application Support Group" = $AppSG
# }
# Set-VMCustomAttributes -VMName $vmName -Attributes $attributes

# Disconnect from vCenter or ESXi host
# Disconnect-VIServer -Server * -Force -Confirm:$false
