# Install the Azure PowerShell module if not already installed
# Install-Module -Name Az -Scope CurrentUser -Force

# Import the module
Import-Module Az

function Get-AzureVMData {
    param (
        [Parameter(Mandatory=$true)]
        [string]$SubscriptionId,

        [Parameter(Mandatory=$true)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory=$true)]
        [string]$VMName,

        [string]$DataKey
    )

    # Connect to your Azure account
    Connect-AzAccount

    # Set the context to the appropriate subscription
    Set-AzContext -SubscriptionId $SubscriptionId

    # Get the VM
    $vm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName

    # If a data key is specified, retrieve that key only
    if ($DataKey) {
        $vmData = $vm | Select-Object -Property $DataKey
    }
    else {
        $vmData = $vm
    }

    # Convert the VM data to a JSON string and output it
    Write-Output ($vmData | ConvertTo-Json)
}

# Usage
Get-AzureVMData -SubscriptionId 'f9b462b0-ae9b-4aa0-838d-fccd1288bc38' -ResourceGroupName 'kpmp-int-lz' -VMName 'kmpg-int-vm' -DataKey 'StorageProfile'
