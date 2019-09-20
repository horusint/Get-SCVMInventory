<#
.Synopsis
   this function gives you an invetory of the SCVMM 
.DESCRIPTION
   either you can get just the object for each server or also a csv and html report
.EXAMPLE
   Get-SCVMInventory -report
.EXAMPLE
   Get-SCVMInventory -VMHost hyp05
.NOTES
   Niklas Akerlund 2013-09-29
   Adapted by Martin Rojas 2016/11/08 to version 3.2.8224.0
#>
function Get-SCVMInventory
{
    [CmdletBinding()]

    Param
    (

        $VMHostGroup = "All Hosts",
        [Parameter(ValueFromPipeline=$True)][Alias('ClusterName')]
        $VMHostCluster = $null,
        $VMHost = $null,
        [switch]$report,
        [string]$path =".\",
        [string]$CSVFile = "VMdata.csv",
        [string]$HTMLReport = "VMdata.html"
    )

    Begin
    {
        if(!(Get-Module virtualmachinemanager)){
            Import-Module Hyper-V
            Import-Module virtualmachinemanager
        }
        if(Get-SCVMMServer localhost | where ProductVersion -gt 3){
            $isR2 = $true
        }else{
            $isR2 = $false
        }
    }
    Process
    {
         if ($VMHostCluster -eq $null){
            if($VMHost -eq $null){
                $VMHosts = (Get-SCVMHostGroup -Name $VMhostGroup).AllChildHosts
            }else{
                $VMHosts = Get-SCVMHost $VMHost
            }
         }else{
            $VMHosts = (Get-SCVMHostCluster -Name $VMHostCluster).Nodes
         }
            $VMs = $VMHosts | Get-SCVirtualMachine
            $reportArray = @()
            foreach ($VM in $VMs){
                Write-Verbose $VM.Name
                    $vNics = $VM.VirtualNetworkAdapters
                    $VHDConf = $VM.VirtualHardDisks
                    $driveConf = $VM.VirtualDiskDrives
                    if(($vNics[0].IPv4Addresses -ne $null)){
                        Write-Verbose $vNics[0].IPv4Addresses[0]
                        $IPAddress1 = $vNics[0].IPv4Addresses[0]

                    }else{
                        if (!$isR2){
                            if(($vNics[0].IPv4Addresses -ne $null)){
                            $IPAddress1= (Hyper-V\Get-VMNetworkAdapter -ComputerName $VM.HostName -VMName $VM.Name).IPv4Addresses[0]
                            }else{
                                $IPAddress1 = "N/A"
                            }
                        }else{
                            Write-Verbose "NO IP"
                            $IPAddress1 = "N/A"
                        }
                    }
                    if(($vNics[1].IPv4Addresses -ne $null)){
                        Write-Verbose $vNics[1].IPv4Addresses[0]
                        $IPAddress2 = $vNics[1].IPv4Addresses[0]

                    }else{
                        if (!$isR2){
                            if(($vNics[1].IPv4Addresses -ne $null)){
                            $IPAddress2= (Hyper-V\Get-VMNetworkAdapter -ComputerName $VM.HostName -VMName $VM.Name).IPv4Addresses[0]
                            }else{
                                $IPAddress2 = "N/A"
                            }
                        }else{
                            Write-Verbose "NO IP"
                            $IPAddress2 = "N/A"
                        }
                    }
                    if(($vNics[2].IPv4Addresses -ne $null)){
                        Write-Verbose $vNics[2].IPv4Addresses[0]
                        $IPAddress3 = $vNics[2].IPv4Addresses[0]

                    }else{
                        if (!$isR2){
                            if(($vNics[2].IPv4Addresses -ne $null)){
                            $IPAddress3= (Hyper-V\Get-VMNetworkAdapter -ComputerName $VM.HostName -VMName $VM.Name).IPv4Addresses[0]
                            }else{
                                $IPAddress3 = "N/A"
                            }
                        }else{
                            Write-Verbose "NO IP"
                            $IPAddress3 = "N/A"
                        }
                    }
                    if(($vNics[3].IPv4Addresses -ne $null)){
                        Write-Verbose $vNics[3].IPv4Addresses[0]
                        $IPAddress4 = $vNics[3].IPv4Addresses[0]

                    }else{
                        if (!$isR2){
                            if(($vNics[3].IPv4Addresses -ne $null)){
                            $IPAddress4= (Hyper-V\Get-VMNetworkAdapter -ComputerName $VM.HostName -VMName $VM.Name).IPv4Addresses[0]
                            }else{
                                $IPAddress4 = "N/A"
                            }
                        }else{
                            Write-Verbose "NO IP"
                            $IPAddress4 = "N/A"
                        }
                    }
                    if($VM.VMCheckpoints){
                    $Snapshots = "Yes"
                    }else{
                    $Snapshots = "No"
                    }

                    $data = [ordered]@{
                    VMName = $VM.Name
                    vCPUs = $VM.CPUCount
                    
                    MemoryAssignedMB = $VM.MemoryAssignedMB
                    Status = $VM.Status
                    OperatingSystem = $VM.OperatingSystem
                    HostName = $VM.HostName
                     TotalSizeGB = $VM.TotalSize/1GB -as [int]
                    vNics = $vNics.Count                                                         
                    VirtualNetwork1 = $vNics[0].VirtualNetwork
                    MacAddressType1 = $vNics[0].MacAddressType
                    MacAddress1 = $vNics[0].MacAddress
                    VirtualNetworkAdapterType1 = $vNics[0].VirtualNetworkAdapterType
                    VLANEnabled1 = $vNics[0].VlanEnabled
                    VLanID1 = $vNics[0].VlanID 
                    IPAddress1 = $IPAddress1

                    VirtualNetwork2 = $vNics[1].VirtualNetwork
                    MacAddressType2 = $vNics[1].MacAddressType
                    MacAddress2 = $vNics[1].MacAddress
                    VirtualNetworkAdapterType2 = $vNics[1].VirtualNetworkAdapterType
                    VLANEnabled2 = $vNics[1].VlanEnabled
                    VLanID2 = $vNics[1].VlanID 
                    IPAddress2 = $IPAddress2

                    VirtualNetwork3 = $vNics[2].VirtualNetwork
                    MacAddressType3 = $vNics[2].MacAddressType
                    MacAddress3 = $vNics[2].MacAddress
                    VirtualNetworkAdapterType3 = $vNics[2].VirtualNetworkAdapterType
                    VLANEnabled3 = $vNics[2].VlanEnabled
                    VLanID3 = $vNics[2].VlanID 
                    IPAddress3 = $IPAddress3

                    VirtualNetwork4 = $vNics[3].VirtualNetwork
                    MacAddressType4 = $vNics[3].MacAddressType
                    MacAddress4 = $vNics[3].MacAddress
                    VirtualNetworkAdapterType4 = $vNics[3].VirtualNetworkAdapterType
                    VLANEnabled4 = $vNics[3].VlanEnabled
                    VLanID4 = $vNics[3].VlanID 
                    IPAddress4 = $IPAddress4

                    NumberofVHD = $VHDConf.Count
                    VHDName = $VHDConf[0].Name
                    VHDFormatType = $VHDconf[0].VHDFormatType
                    VHDType = $VHDconf[0].VHDType
                    VHDSize = $VHDconf[0].MaximumSize/1GB -as [int]
                    VHDCurrentSize = $VHDconf[0].Size/1GB -as [int]
                    VHDBusType = $driveConf[0].BusType
                    VHDBus = $driveConf[0].Bus
                    VHDLUN = $DriveConf[0].Lun
                    VHDDatastore = $VHDconf[0].Directory

                    VHDName2 = $VHDConf[1].Name
                    VHDFormatType2 = $VHDconf[1].VHDFormatType
                    VHDType2 = $VHDconf[1].VHDType
                    VHDSize2 = $VHDconf[1].MaximumSize/1GB -as [int]
                    VHDCurrentSize2 = $VHDconf[1].Size/1GB -as [int]
                    VHDBusType2 = $driveConf[1].BusType
                    VHDBus2 = $driveConf[1].Bus
                    VHDLUN2 = $DriveConf[1].Lun
                    VHDDatastore2 = $VHDconf[1].Directory

                    VHDName3 = $VHDConf[2].Name
                    VHDFormatType3 = $VHDconf[2].VHDFormatType
                    VHDType3 = $VHDconf[2].VHDType
                    VHDSize3 = $VHDconf[2].MaximumSize/1GB -as [int]
                    VHDCurrentSize3 = $VHDconf[2].Size/1GB -as [int]
                    VHDBusType3 = $driveConf[2].BusType
                    VHDBus3 = $driveConf[2].Bus
                    VHDLUN3 = $DriveConf[2].Lun
                    VHDDatastore3 = $VHDconf[2].Directory

                    StartMemoryGB = $VM.Memory/1024
                    DynamicMemory = $VM.DynamicMemoryEnabled
                    DynamicMemoryDemandMB = $VM.DynamicMemoryDemandMB
                    DynamicMemoryStatus = $VM.DynamicMemoryStatus -as [int]
                    DynamicMemoryMinMB = $VM.DynamicMemoryMinimumMB -as [int]
                    DynamicMemoryMaxGB = $VM.DynamicMemoryMaximumMB/1024 -as [int]
                    HasSnaphots = $Snapshots
                    Owner = $VM.Owner
                    Cloud = $VM.Cloud
                    CreationTime = $VM.CreationTime
                    HasVMAdditions = $VM.HasVMAdditions
                    VMAddition = $VM.VMAddition
                   
            }
            $obj= New-Object -TypeName PSObject -property $data
            $reportArray +=$obj 
            Write-Output $obj
            }

            if($report){
                # $reportArray
                $CSVReport = $path + $CSVFile
                $HTMLReport = $path + $HTMLReport
                $reportArray | Export-Csv -Path $CSVReport -NoTypeInformation -UseCulture
                $reportArray | ConvertTo-HTML | Out-File $HTMLReport
            }
    }
    End
    {
        # Should we clean anything?
    }
}
