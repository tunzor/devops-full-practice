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
variable "desired_frontend_vms" {
    default = 3
}
variable "desired_backend_vms" {
    default = 3
}
# Terraform will prompt for ssh_user's value before running;
# it can be defaulted like the ssh_key path below
variable "ssh_user" {}
variable "ssh_key" {
    default = "~/.ssh/id_rsa.pub"
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

resource "google_compute_firewall" "frontend-in" {
    name = "allow-frontend-in"
    network = var.default_network
    allow {
        protocol = "tcp"
        ports = ["5002", "22"]
    }

    depends_on = [
        google_compute_network.tf-devops-net
    ]
}

resource "google_compute_firewall" "backend-in" {
    name = "allow-backend-in"
    network = var.default_network
    allow {
        protocol = "tcp"
        ports = ["5003", "22"]
    }

    depends_on = [
        google_compute_network.tf-devops-net
    ]
}

# Frontend instances
resource "google_compute_instance" "gce_frontend_instances" {
    # Create several vms
    count = var.desired_frontend_vms
    name = "fe-vm-${count.index}"

    machine_type = var.default_machine
    zone = var.default_zone

    boot_disk {
        # Using debian as python comes installed on it;
        # necessary for ansible
        initialize_params {
            image = "debian-cloud/debian-9"
        }
    }

    metadata = {
        ssh-keys = "${var.ssh_user}:${file(var.ssh_key)}"
    }

    metadata_startup_script = "for i in {1..100}; do echo \"printing $i\"; done"

    network_interface {
        network = var.default_network
        # Leaving access_config empty will assign the instance an ephemeral IP
        access_config {}
    }

    depends_on = [
        google_compute_firewall.frontend-in
    ]
}

# backend instances
resource "google_compute_instance" "gce_backend_instances" {
    # Create several vms
    count = var.desired_backend_vms
    name = "be-vm-${count.index}"

    machine_type = var.default_machine
    zone = var.default_zone

    boot_disk {
        # Using debian as python comes installed on it;
        # necessary for ansible
        initialize_params {
            image = "debian-cloud/debian-9"
        }
    }

    metadata = {
        ssh-keys = "${var.ssh_user}:${file(var.ssh_key)}"
    }

    metadata_startup_script = "for i in {1..100}; do echo \"printing $i\"; done"

    network_interface {
        network = var.default_network
        access_config {}
    }

    depends_on = [
        google_compute_firewall.backend-in
    ]
}

resource "local_file" "inventory" {
    filename = "../ansible/hosts"
    content = join("\n",
        ["[all:vars]",
        "ansible_ssh_user=${var.ssh_user}",
        "[frontend]",
        join("\n", google_compute_instance.gce_frontend_instances.*.network_interface.0.access_config.0.nat_ip),
        "[backend]",
        join("\n", google_compute_instance.gce_backend_instances.*.network_interface.0.access_config.0.nat_ip)
        ])

    depends_on = [
        google_compute_instance.gce_frontend_instances,
        google_compute_instance.gce_backend_instances
    ]
}