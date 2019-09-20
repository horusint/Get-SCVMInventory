# Get-SCVMInventory
Credits are from https://vniklas.djungeln.se/2013/09/29/ Niklas AkerlundGet an inventory of all VM’s from System Center Virtual Machine Manager including the vCPU’s, memory, all VHD´s, IP addresses.  Report to CSV and HTML. Adapted to work with last actuallly SCVMM version 3.2.8224
Get an inventory of all VM’s from System Center Virtual Machine Manager including the vCPU’s, memory, up to 3 VHD´s, up to 4 interfaces and IP addresses.  Report to CSV and HTML. Adapted to work with SCVMM version 3.2.8224. and at least SCVMM 2016 UR7

Thanks to @leleco for the suggestions and collaboration improvements

Example:

Get-SCVMInventory -report

Give a reports for “All Hosts”

Get-SCVMInventory -VMHost SERVER01

Give data from SERVER01 Hyper-v Host.

Publicado también en https://gallery.technet.microsoft.com/scriptcenter/Get-SCVMMInventory-Get-053afdc1
