#Aws-Webserver-Git-teraform

provider "aws" {
region = "ap-south-1"
profile = "sri"
}

resource "aws_instance" "myos" {
  ami           =  "ami-010aff33ed5991201"
  instance_type = "t2.micro"
  security_groups = ["webserver-teraform"]
  key_name = "SRI"
  tags = {
    Name = "TerraForm-Webserver"
  }
}

resource "null_resource" "null_remote"{
connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("C:/Users/hi/Documents/ARTH/CLOUDCOMPUTING/AWS/KEYS/SRI.pem")
    host     = aws_instance.myos.public_ip
  }

provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo yum install php -y",
      "sudo systemctl start httpd"
    ]
  }
}

resource "aws_ebs_volume" "my_volume" {
  availability_zone = aws_instance.myos.availability_zone
  size              = 4

  tags = {
    Name = "Terraform_volume"
  }
}

resource "aws_volume_attachment" "ebs_attach" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.my_volume.id
  instance_id = aws_instance.myos.id
}

resource "null_resource" "null_volume_format_mount1"{
connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("C:/Users/hi/Documents/ARTH/CLOUDCOMPUTING/AWS/KEYS/SRI.pem")
    host     = aws_instance.myos.public_ip
  }

provisioner "remote-exec" {
    inline = [
      "sudo mkfs.ext4 /dev/xvdh",
      "sudo mount /dev/xvdh /var/www/html",
      "sudo yum install git -y",
      "sudo git clone https://github.com/sandeep4055/Terraform-AWS-Inftra.git /var/www/html/web",

    ]
  }
}

resource "null_resource" "local_execution"{

provisioner "local-exec" {
	command = "chrome http://13.233.194.108/web/php-test-web.php"
	}
}






