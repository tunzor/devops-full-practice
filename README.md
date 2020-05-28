# DevOps Practice Project
This is meant to be a project that uses several DevOps technologies to setup and configure an environment, build and deploy an app, and setup monitoring for it.

## Plan
1. Stand up cloud infrastructure with [terraform](https://www.terraform.io/)
2. Configure cloud machines with [ansible](https://www.ansible.com/)
3. Use [github actions](https://github.com/features/actions) to build and deploy an app to the cloud machines
4. Setup monitoring with a tool

## Usage
*All of the below commands assume you start in the same directory as this readme*
1. Use `terraform` to setup infrastructure on `GCP`
```
cd terraform
terraform apply [-auto-approve] [-var="ssh_user=$USER"]
```
2. Run the `ansible` playbook to configure instances
```
cd ansible
ansible-playbook -i hosts playbook.yml
```