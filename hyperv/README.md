# HyperV Tutorial
Author:   Pedric Kng  
Updated:  25 Jul 2019

# Listing
* [Cloning machines on HyperV](#Cloning-machines-on-HyperV)
* [Hyperv NAT network with internet sharing](#Hyperv-NAT-network-with-internet-sharing)


***
## Cloning machines on HyperV
Steps on how to clone VM on HyperV. Note that this only applies to HyperV Manager on Desktop

1. Export the image via HyperV Manager
2. Create a folder structure containing
 - Snapshots -- Stores the snapshots
 - Virtual Hard Disks -- Stores the virtual machine hdd
 - Virtual Machines -- Stores the virtual machine configuration
3. Import the Virtual Machine via HyperV Manager
  * Populate the folder destination using the above structure

***

## Hyperv NAT network with internet sharing

1. Create a Hyperv virtual switch of 'internal' type.

2. List virtual switch
  ```powershell
  Get-VMSwitch
  ```

3. List network adapter, note the switch interface index.
```powershell
Get-NetAdapter
```

4. Get NAT ip address of virtual switch
```powershell

// List NAT ip address

Get-NetIPAddress -InterfaceIndex 62

// Setup NAT gateway ip address

New-NetIPAddress -IPAddress <NAT Gateway IP> -PrefixLength <NAT Subnet Prefix Length> -InterfaceIndex <ifIndex>

E.g., New-NetIPAddress -IPAddress 192.168.137.1 -PrefixLength 24 -InterfaceIndex 62

// If a different NAT gateway ip address is already in-place, remove it using below command

Remove-NetIPAddress -IPAddress 172.20.240.1 -InterfaceIndex 62

```

5. Create the NAT network

```powershell

// List NAT network

Get-NetNat

// To remove all NAT network

Get-NetNat | Remove-NetNat

// Create NAT network

New-NetNat -Name <NAT network name> -InternalIPInterfaceAddressPrefix <NAT IP address range/NAT Subnet Prefix Length>

E.g., New-NetNat -Name MyNATnetwork -InternalIPInterfaceAddressPrefix 192.168.137.0/24

```

6. Check Internet Connection Sharing

[Internet Adapter] > Properties > Sharing > 'Allow other network users to connect this computer's internet connection'