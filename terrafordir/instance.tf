data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["${var.image_name}"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "jenkins" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.cicd_sg.name]
  key_name        = "stagingServer"

  tags = {
    Name = "Jenkins_server"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    timeout     = "4m"
  }

  provisioner "file" {
    source      = "./scripts/jenkinsSetup.sh"
    destination = "/home/ubuntu/jenkinsSetup.sh"
  }
  provisioner "file" {
    source      = "./scripts/nodeSetup.sh"
    destination = "/home/ubuntu/nodeSetup.sh"
  }

  provisioner "file" {
    source      = "./scripts/JCasC.yml"
    destination = "/home/ubuntu/JCasC.yml"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/ubuntu/jenkinsSetup.sh",
      "/home/ubuntu/jenkinsSetup.sh",
      "sudo mkdir /var/lib/jenkins/config",
      "sudo mv /home/ubuntu/JCasC.yml /var/lib/jenkins/config/",
      "sudo chmod +x /home/ubuntu/nodeSetup.sh",
      "/home/ubuntu/nodeSetup.sh"
    ]
  }

}


resource "aws_instance" "stageProd" {
  count           = 2
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.cicd_sg.name]
  key_name        = "stagingServer"

  tags = {
    Name = count.index == 0 ? "staging" : "production"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    timeout     = "4m"
  }

  provisioner "file" {
    source      = "./scripts/nodeSetup.sh"
    destination = "/home/ubuntu/nodeSetup.sh"
  }

  provisioner "file" {
    source      = "./scripts/deployStaging.sh"
    destination = "/home/ubuntu/deployStaging.sh"
  }

  provisioner "file" {
    source      = "./scripts/deployProd.sh"
    destination = "/home/ubuntu/deployProd.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/ubuntu/nodeSetup.sh",
      "sudo chmod +x /home/ubuntu/deployStaging.sh",
      "sudo chmod +x /home/ubuntu/deployProd.sh",
      "/home/ubuntu/nodeSetup.sh"
    ]
  }
}