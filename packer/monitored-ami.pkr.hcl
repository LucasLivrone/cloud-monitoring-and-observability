packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ami" {
  ami_name      = "monitored-ami"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-041feb57c611358bd" # Amazon Linux 2023
  ssh_username  = "ec2-user"
}

build {
  name    = "monitored-ami"
  sources = [
    "source.amazon-ebs.ami"
  ]


  # Install Docker & Docker-Compose
  provisioner "shell" {
    script = "./scripts/docker_setup.sh"
  }

  # Load docker-compose.yml
  provisioner "file" {
    source      = "./docker/docker-compose.yml"
    destination = "/home/ec2-user/docker-compose.yml"
  }

  # Load docker-compose.yml
  provisioner "file" {
    source      = "./docker/prometheus.yml"
    destination = "/home/ec2-user/prometheus.yml"
  }
}
