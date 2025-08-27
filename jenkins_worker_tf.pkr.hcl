packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

#cambiar source_ami, subnet_id y vpc_id a los de tu cuenta
source "amazon-ebs" "jenkins_worker" {
  ami_name                  = "jenkins-worker-terraform"
  associate_public_ip_address = true
  instance_type             = "t2.micro"
  region                    = "us-east-1"
  source_ami                = "ami-04da39936a45cd166"
  ssh_username              = "ubuntu"
  subnet_id                 = "subnet-00ad2edb2c1755a05"
  vpc_id                    = "vpc-019b3b09474aee60a"

  run_tags = {
    owner    = "slorcadelgado"
    bootcamp = "devops"
  }

  tags = {
    owner    = "slorcadelgado"
    bootcamp = "devops"
  }
}

build {
  sources = ["source.amazon-ebs.jenkins_worker"]

  provisioner "shell" {
    inline = [
      "wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null",
      "gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main\" | sudo tee /etc/apt/sources.list.d/hashicorp.list",
      "sudo apt update",
      "sudo apt-get install terraform -y"
    ]
  }
}
