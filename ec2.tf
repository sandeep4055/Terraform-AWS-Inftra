provider "aws" {
region = "ap-south-1"
profile = "sri"
}

resource "aws_instance" "myos" {
  ami           =  "ami-010aff33ed5991201"
  instance_type = "t2.micro"

  tags = {
    Name = "TerraForm-Instance"
  }
}

output "instance_public_ip"{
value = aws_instance.myos.public_ip
}

output "instance_subnetid"{
value = aws_instance.myos.subnet_id
}

output "instance_availability_zone"{
value = aws_instance.myos.availability_zone
}

resource "aws_ebs_volume" "my_volume" {
  availability_zone = aws_instance.myos.availability_zone
  size              = 4

  tags = {
    Name = "Terraform_volume"
  }
}

output "aws_ebs_volume_id"{
value = aws_ebs_volume.my_volume.id
}


resource "aws_volume_attachment" "ebs_attach" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.my_volume.id
  instance_id = aws_instance.myos.id
}

output "aws_ebs_volume_attach_device_name"{
value = aws_volume_attachment.ebs_attach.device_name
}

