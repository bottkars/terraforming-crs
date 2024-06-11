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



admib

reg delete "HKEY_LOCAL_MACHINE\Software\Microsoft\Terminal Server” /v “DisableDriveRedirection"  /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v fDisableCdm  /f



