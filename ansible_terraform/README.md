# Ansible and Terraform - a great match!

<!-- README.md file for ansible_terraform -->

This Repository shows the code used for the Live-Demo for the presentation "Ansible and Terraform - a great match!" on the Ansible-Anwendertreffen 2021.

You can also find the presentation slides [here](./Ans_Anw_ans_tf_match.pdf).

## Usage
### Requirements

- Terraform v0.14.5+
- Ansible v2.9.18+

### Variables

In order to be able to use terraform to deploy infrastructure on Azure, you need to proivde some authentication values [here](./terraform/main.tf).
```
  subscription_id - ID of the Azure subscription
  client_id       - Client ID of the application
  client_secret   - Client secret of the application
  tenant_id       = Tenant ID of the application
```
If you want to use other authentication methods then client secret, see [Authenticating to Azure](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure).

Furthermore you can change some values for the deployment [here](./terraform/terraform.tfvars).
```
vm_size                 - Size of the VM
azurerm_resource_group  - Resource group name
number_of_vms           - Number of VMs to deploy (default=1)

image_publisher         - VM image publisher 
image_offer             - VM image offer
image_sku               - VM image SKU
image_version           - VM image version
```

### Dependencies

For Ansible the following collections need to be installed:

- community.general

### Run

To execute the complete deplyoment simple run the playbook.yml similar to below.

```
ansible-playbook playbook.yml
```
### Contact

In case you want to get in touch with the developers and responsibles please
have a look at the below entries:

- mail: [ghooper@proficom.de](mailto:ghooper@proficom.de)
- site: <https://www.proficom.de/>
