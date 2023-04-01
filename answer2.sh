#!/bin/bash

# set your Azure subscription ID, resource group name, and VM name
subscription_id='<subscription_id>'
resource_group_name='<resource_group_name>'
vm_name='<vm_name>'

# get the VM metadata with Azure CLI and output it in JSON format
az vm get-instance-view --subscription $subscription_id --resource-group $resource_group_name --name $vm_name --query "instanceView.vmAgent.extensionHandlers[0].properties.settings.protectedSettings.commandToExecute" -o json
