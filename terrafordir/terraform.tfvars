# Region and Access Crendentials
region     = "us-east-1"
access_key = ""
secret_key = ""

# Instance Info
instance_type = "t2.micro"
image_name    = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"

# Key-Pair Info (set the private and public key path which is gererated in step 2)
key_name         = "cicdKey"
private_key_path = "/home/appychip/Desktop/cicd/terrafordir/id_rsa"
public_key_path  = "/home/appychip/Desktop/cicd/terrafordir/id_rsa.pub"

# EC2 Security Group Info
instance_security_group_name = "cicd_demo_sg"
inbound_ports                = [80, 8080, 22, 443, 4000]

