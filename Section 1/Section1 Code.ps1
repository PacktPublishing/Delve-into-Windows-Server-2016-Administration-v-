# On your Hyper-V Host
# Create Your Hyper-V Switch
New-VMSwitch -SwitchName "Lab Switch" -SwitchType Internal
New-NetIPAddress -IPAddress 10.2.0.1 -PrefixLength 24 -InterfaceAlias "vEthernet (Lab Switch)"
New-NetNat -Name LabNAT -InternalIPInterfaceAddressPrefix 10.2.0.0/24

