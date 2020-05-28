# Cloud Infrastructure Setup with Terraform
This section is for setting up cloud infrastructure on GCP with terraform and will include:
- virtual machines (`f1-micro` in `us-east1` region)
- firewall rules to limit incoming traffic to necessary ports

## Prerequisite
Ensure that the `GCP` project and the service account are setup.
1. Create the project, attach to billing account, activate, and enable `GCE`
```
gcloud projects create devops-full-practice

gcloud [alpha|beta] billing accounts projects link devops-full-practice --billing-account XXXXX-XXXXX-XXXXX

gcloud config set project devops-full-practice

gcloud services enable compute.googleapis.com
```
2. Setup service account in the project and give it the owner role (NOTE: owner role probably is too privileged for this)
```
gcloud iam service-accounts create devops-master

gcloud projects add-iam-policy-binding devops-full-practice --member "serviceAccount:devops-master@devops-full-practice.iam.gserviceaccount.com" --role "roles/owner"
```
3. Generate the service account credentials `json` file for use later
```
gcloud iam service-accounts keys create creds.json --iam-account devops-master@devops-full-practice.iam.gserviceaccount.com
```

## Running Terraform
When run, the `terraform` plan in this directory will:
1. Create a network called `devops-net`
2. Create two firewall rules (one for frontend and backend) to allow traffic on specific ports
    - `5002` is for the app frontend
    - `5003` is for the app backend
    - `22` for ssh access (for ansible)
3. Create a number of instances on the `devops-net` network with public IP addresses and firewall rules above applied (`desired_frontend_vms` and `desired_backend_vms` variables in `main.tf`)
4. Add the local user's public ssh key to the metadata of the instances to allow `ssh` access (terraform will ask for the user's id to save into the variable `ssh_user` if it's not passed as a CLI variable as outlined below; did this so as not to check in user information)

Run it from this directory with:
```
# Initialize terraform
terraform init

# Show changes to be applied
# Optional [-var="ssh_user=$USER"] sets the terraform
# variable ssh_user to environment variable $USER;
# if not used, terraform will prompt user for value
# when running
terraform plan [-var="ssh_user=$USER"]

# Apply the changes 
# Optional [-auto-approve] will skip the verfication confirmation
terraform apply [-auto-approve] [-var="ssh_user=$USER"]
```

Once finished, all resources can be destroyed with:
```
terraform destroy [-auto-approve] [-var="ssh_user=$USER"]
```
---

## Notes
### Background
Terraform is a tool for building and managing infrastructure. It codifies the infrastructure resources into configuration files (`.tf` extension) that allows for easy versioning, sharing, and collaboration. 

### How It Works
At a high level, Terraform reads your config, checks the state of the resources in it, and applies any changes to the current state to bring it to the desired state outlined in your config file.

### Common commands
`terraform init` will initialize a working directory containing `.tf` files; this should be run first after creating a config file

`terraform refresh` will cause Terraform to check the current state of resources and update the `.tfstate` file it maintains

`terraform plan` will perform a `terraform refresh` and output a list of changes necessary to bring it to the desired state; `-out` can optionally be added to save the output to a file

`terraform apply` will perform a `terraform plan` and prompt the user for confirmation that the changes should be applied to bring the current state to the desired state; `-auto-approve` can optionally be added to automatically approve the action

`terraform destroy` functions the same as `terraform apply` except it will delete any resources from the config file that still exist

### Config Files
[Configuration files](https://www.terraform.io/docs/configuration/syntax.html) (`.tf`) are written in the [Hashicorp Config Language](https://github.com/hashicorp/hcl) (`HCL`) and generally follow the structure of:
```
HCL_KEYWORD ["RESOURCE_TYPE"] "LOCAL_OBJECT_NAME" {}

Examples:
variable "my_instance_name" {
    default = "hello_world"
}

resource "google_compute_instance" "my_gce_instance" {
    ...
}
``` 

Defined variables can be used with the `var` prefix:
```
resource "google_compute_instance" "my_gce_instance" {
    name = var.my_instance_name
}
```