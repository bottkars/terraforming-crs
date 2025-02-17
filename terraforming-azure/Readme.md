
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.94 |
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 3.4.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~>3.1 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~>2.2.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 3.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_common_rg"></a> [common\_rg](#module\_common\_rg) | ./modules/rg | n/a |
| <a name="module_cs"></a> [cs](#module\_cs) | ./modules/cybersense | n/a |
| <a name="module_ddve"></a> [ddve](#module\_ddve) | ./modules/ddve | n/a |
| <a name="module_jumphost"></a> [jumphost](#module\_jumphost) | ./modules/cis-jump | n/a |
| <a name="module_networks"></a> [networks](#module\_networks) | ./modules/networks | n/a |
| <a name="module_ppcr"></a> [ppcr](#module\_ppcr) | ./modules/ppcr | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_CR_DDVE_SubnetAddressSpace"></a> [CR\_DDVE\_SubnetAddressSpace](#input\_CR\_DDVE\_SubnetAddressSpace) | n/a | `string` | `"10.0.0.16/28"` | no |
| <a name="input_CR_DDVE_subnet_id"></a> [CR\_DDVE\_subnet\_id](#input\_CR\_DDVE\_subnet\_id) | n/a | `any` | `null` | no |
| <a name="input_CS_Image_Id"></a> [CS\_Image\_Id](#input\_CS\_Image\_Id) | n/a | `string` | `"/subscriptions/2763ec59-6bb9-45bd-a62c-468bd0177ba2/resourceGroups/cr_general_rg/providers/Microsoft.Compute/galleries/cr_general_gallary/images/ie_cs_vm_gen1/versions/0.0.2"` | no |
| <a name="input_CS_MgmtNumber"></a> [CS\_MgmtNumber](#input\_CS\_MgmtNumber) | n/a | `number` | `16` | no |
| <a name="input_JumpHost_SubnetAddressSpace"></a> [JumpHost\_SubnetAddressSpace](#input\_JumpHost\_SubnetAddressSpace) | n/a | `string` | `"10.0.0.0/28"` | no |
| <a name="input_JumpHost_subnet_id"></a> [JumpHost\_subnet\_id](#input\_JumpHost\_subnet\_id) | n/a | `any` | `null` | no |
| <a name="input_PPCR_Image_Id"></a> [PPCR\_Image\_Id](#input\_PPCR\_Image\_Id) | n/a | `string` | `"/subscriptions/2763ec59-6bb9-45bd-a62c-468bd0177ba2/resourceGroups/cr_general_rg/providers/Microsoft.Compute/galleries/cr_general_gallary/images/cyber_recovery_mgmnt_host/versions/19.16.02"` | no |
| <a name="input_PPCR_MgmtNumber"></a> [PPCR\_MgmtNumber](#input\_PPCR\_MgmtNumber) | n/a | `number` | `16` | no |
| <a name="input_ProductionClientIpAddress"></a> [ProductionClientIpAddress](#input\_ProductionClientIpAddress) | Input the IP address to for the Production Clients that will access the Jump Host Ex. 10.0.0.30 | `any` | n/a | yes |
| <a name="input_azure_environment"></a> [azure\_environment](#input\_azure\_environment) | The Azure cloud environment to use. Available values at https://www.terraform.io/docs/providers/azurerm/#environment | `string` | `"public"` | no |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | n/a | `any` | `null` | no |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | n/a | `any` | `null` | no |
| <a name="input_common_location"></a> [common\_location](#input\_common\_location) | Name of a common resource group location for all but network resources | `any` | `null` | no |
| <a name="input_common_resource_group_name"></a> [common\_resource\_group\_name](#input\_common\_resource\_group\_name) | Name of a common resorce group for all but network resources | `any` | `null` | no |
| <a name="input_create_common_rg"></a> [create\_common\_rg](#input\_create\_common\_rg) | Create a common RG | `bool` | `false` | no |
| <a name="input_create_cybersense"></a> [create\_cybersense](#input\_create\_cybersense) | n/a | `bool` | `false` | no |
| <a name="input_create_networks"></a> [create\_networks](#input\_create\_networks) | Create Cyber Vault Networks | `bool` | `false` | no |
| <a name="input_customTags"></a> [customTags](#input\_customTags) | n/a | `map` | `{}` | no |
| <a name="input_ddve_MgmtNumber"></a> [ddve\_MgmtNumber](#input\_ddve\_MgmtNumber) | n/a | `number` | `4` | no |
| <a name="input_ddve_ReplNumber"></a> [ddve\_ReplNumber](#input\_ddve\_ReplNumber) | n/a | `number` | `9` | no |
| <a name="input_ddve_count"></a> [ddve\_count](#input\_ddve\_count) | will deploy DDVE when number greater 0. Number indicates number of DDVE Instances | `number` | `0` | no |
| <a name="input_ddve_initial_password"></a> [ddve\_initial\_password](#input\_ddve\_initial\_password) | the initial Password for Datadomain. It will be exposed to output as DDVE\_PASSWORD for further Configuration. <br>As DD will be confiured with SSH, the Password must be changed from changeme | `string` | `"Change_Me12345_"` | no |
| <a name="input_ddve_meta_disks"></a> [ddve\_meta\_disks](#input\_ddve\_meta\_disks) | n/a | `list(string)` | <pre>[<br>  "1023",<br>  "1023"<br>]</pre> | no |
| <a name="input_ddve_networks_resource_group_name"></a> [ddve\_networks\_resource\_group\_name](#input\_ddve\_networks\_resource\_group\_name) | Bring your own Network resourcegroup. the Code will read the Data from the resourcegroup name specified here | `string` | `null` | no |
| <a name="input_ddve_resource_group_name"></a> [ddve\_resource\_group\_name](#input\_ddve\_resource\_group\_name) | Bring your own resourcegroup. the Code will read the Data from the resourcegroup name specified here | `string` | `null` | no |
| <a name="input_ddve_tcp_inbound_rules_Inet"></a> [ddve\_tcp\_inbound\_rules\_Inet](#input\_ddve\_tcp\_inbound\_rules\_Inet) | inbound Traffic rule for Security Group from Internet | `list(string)` | <pre>[<br>  "22",<br>  "443"<br>]</pre> | no |
| <a name="input_ddve_type"></a> [ddve\_type](#input\_ddve\_type) | DDVE Type, can be: '16 TB DDVE', '32 TB DDVE', '96 TB DDVE', '256 TB DDVE','16 TB DDVE PERF', '32 TB DDVE PERF', '96 TB DDVE PERF', '256 TB DDVE PERF' | `string` | `"16 TB DDVE"` | no |
| <a name="input_ddve_version"></a> [ddve\_version](#input\_ddve\_version) | DDVE Version, can be: '7.7.525', '7.10.115', '7.10.120', '7.13.020', '7.10.1015.MSDN', '7.10.120.MSDN', '7.7.5020.MSDN', '7.13.0020.MSDN' | `string` | `"7.13.020"` | no |
| <a name="input_ddvelist"></a> [ddvelist](#input\_ddvelist) | n/a | `list` | <pre>[<br>  {<br>    "ddve_meta_disks": [<br>      1000,<br>      1000<br>    ],<br>    "ddve_type": "16 TB DDVE",<br>    "ddve_version": "7.13.0020.MSDN"<br>  },<br>  {<br>    "ddve_meta_disks": [<br>      1000,<br>      1000,<br>      1000,<br>      1000,<br>      1000,<br>      1000,<br>      1000,<br>      1000,<br>      1000,<br>      1000<br>    ],<br>    "ddve_type": "96 TB DDVE",<br>    "ddve_version": "7.13.020"<br>  },<br>  {<br>    "ddve_meta_disks": [<br>      1000,<br>      1000,<br>      1000,<br>      1000<br>    ],<br>    "ddve_type": "32 TB DDVE"<br>  },<br>  {<br>    "ddve_meta_disks": [<br>      2000,<br>      2000,<br>      2000,<br>      2000,<br>      2000,<br>      2000,<br>      2000,<br>      2000,<br>      2000,<br>      2000,<br>      2000,<br>      2000,<br>      2000<br>    ],<br>    "ddve_type": "256 TB DDVE"<br>  }<br>]</pre> | no |
| <a name="input_jumpHost_MgmtNumber"></a> [jumpHost\_MgmtNumber](#input\_jumpHost\_MgmtNumber) | n/a | `number` | `10` | no |
| <a name="input_jumphost_networks_resource_group_name"></a> [jumphost\_networks\_resource\_group\_name](#input\_jumphost\_networks\_resource\_group\_name) | n/a | `string` | `"csc-edub-ashci-rg"` | no |
| <a name="input_jumphost_resource_group_name"></a> [jumphost\_resource\_group\_name](#input\_jumphost\_resource\_group\_name) | n/a | `any` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `any` | `null` | no |
| <a name="input_ppcr_networks_resource_group_name"></a> [ppcr\_networks\_resource\_group\_name](#input\_ppcr\_networks\_resource\_group\_name) | n/a | `string` | `"csc-edub-ashci-rg"` | no |
| <a name="input_ppcr_resource_group_name"></a> [ppcr\_resource\_group\_name](#input\_ppcr\_resource\_group\_name) | n/a | `any` | `null` | no |
| <a name="input_resourcePrefix"></a> [resourcePrefix](#input\_resourcePrefix) | n/a | `string` | `"PPCR"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | n/a | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | n/a | `any` | `null` | no |
| <a name="input_vnetAddressSpace"></a> [vnetAddressSpace](#input\_vnetAddressSpace) | n/a | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vnet_id"></a> [vnet\_id](#input\_vnet\_id) | n/a | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_atos_account"></a> [atos\_account](#output\_atos\_account) | n/a |
| <a name="output_ddev_ssh_public_key"></a> [ddev\_ssh\_public\_key](#output\_ddev\_ssh\_public\_key) | n/a |
| <a name="output_ddve_private_ip"></a> [ddve\_private\_ip](#output\_ddve\_private\_ip) | The private ip address for all jumphost |
| <a name="output_ddve_ssh_private_key"></a> [ddve\_ssh\_private\_key](#output\_ddve\_ssh\_private\_key) | n/a |
| <a name="output_jumphost_private_ip"></a> [jumphost\_private\_ip](#output\_jumphost\_private\_ip) | The private ip address for all jumphost |
| <a name="output_ppcr_private_ip"></a> [ppcr\_private\_ip](#output\_ppcr\_private\_ip) | The private ip address for all ppcr |
| <a name="output_ppcr_ssh_private_key"></a> [ppcr\_ssh\_private\_key](#output\_ppcr\_ssh\_private\_key) | n/a |
| <a name="output_ppcr_ssh_public_key"></a> [ppcr\_ssh\_public\_key](#output\_ppcr\_ssh\_public\_key) | n/a |
| <a name="output_privatelink"></a> [privatelink](#output\_privatelink) | The private ip address for the Private link |

##




### Image Terms


```azcli
az vm image accept-terms --offer=cis-windows-server --plan=cis-windows-server2019-l2-gen1 --publisher=center-for-internet-security-inc
```

```azcli
az vm image accept-terms --urn=center-for-internet-security-inc:cis-windows-server:cis-windows-server2019
-l2-gen1:3.0.1
```

terraform output ppcr_ssh_private_key
## Usage

```powershell
cd $HOME
mkdir -p .ssh
notepad .\.ssh\ppcr_key.
mv .\.ssh\ppcr_key.txt .\.ssh\ppcr_key

scp -i .\.ssh\ppcr_key azureuser@10.0.5.30:/home/azureuser/azure_cr/cis-regedit.exe C:/Users/azureuser
ssh -i .\.ssh\ppcr_key azureuser@10.0.5.30


cd C:/Users/azureuser/Desktop
.\cis-regedit.exe enableFileTransfer c
```



sudo passwd root
sudo su -
/opt/dellemc/cr/bin/crsetup.sh --reset





admib

reg delete "HKEY_LOCAL_MACHINE\Software\Microsoft\Terminal Server” /v “DisableDriveRedirection"  /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v fDisableCdm  /f



