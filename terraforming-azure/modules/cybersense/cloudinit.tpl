#cloud-config
runcmd:
 - sudo -s
 - cd /home/azureuser/azure_cr/staging
 - ./crsetup.sh --silent azure