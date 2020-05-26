# Cloud Infrastructure Configuration with Ansible
This section is for using Ansible to configure the cloud infrastructure created by terraform in [this folder](../terraform/README.md) and includes:
- installing the necessary application software
- any configuration of this software

### Prerequisites
The `hosts` file used is provided by the terraform step mentioned above.

### Running Ansible
Test connection to instances in the `hosts` file:
```
# -i is the inventory file
ansible all -i hosts -m ping
``` 