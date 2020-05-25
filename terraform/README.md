# Cloud Infrastructure Setup with Terraform
This section is for setting up cloud infrastructure on GCP with terraform and will include:
- virtual machines (`f1-micro` in `us-east1` region)
- firewall rules to limit incoming traffic to necessary ports

## Pre-requisite
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
2. Create a firewall rule to allow traffic on port `80`
3. Create an instance on the `devops-net` network

Run it from this directory with:
```
# Initialize terraform
terraform init

# Optional command to see changes being applied
terraform plan

# Apply the changes 
# Optional [-auto-approve] will skip the verfication confirmation

terraform apply [-auto-approve]
```

Once finished, all resources can be destroyed with:
```
terraform destroy [-auto-approve]
```