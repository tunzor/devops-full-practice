variable "project_key" {
    default = "devops-full-practice"
}
variable "default_region" {
    default = "us-east1"
}
variable "default_zone" {
    default = "us-east1-b"
}
variable "default_machine" {
    default = "f1-micro"
}
variable "default_network" {
    default = "devops-net"
}

provider "google" {
    credentials = file("creds.json")
    project = var.project_key
    region = var.default_region
}

# NETWORKING
resource "google_compute_network" "tf-devops-net" {
    name = var.default_network
}

resource "google_compute_firewall" "web-in" {
    name = "allow-port-80"
    network = var.default_network
    allow {
        protocol = "tcp"
        ports = ["80"]
    }

    depends_on = [
        google_compute_network.tf-devops-net
    ]
}

# INSTANCES
resource "google_compute_instance" "test1" {
    name = "test1-vm"
    machine_type = var.default_machine
    zone = var.default_zone

    boot_disk {
        initialize_params {
            image = "centos-cloud/centos-8"
        }
    }

    metadata_startup_script = "for i in {1..100}; do echo \"printing $i\"; done"

    network_interface {
        network = var.default_network
    }

    depends_on = [
        google_compute_firewall.web-in
    ]
}