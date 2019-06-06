
data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name = "name"

    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}



resource "aws_key_pair" "deployer" {
  key_name = "deploy"
  public_key = "${file(var.aws_pub_key)}"
}

resource "aws_instance" "testcc_vm" {
    
    ami = "${data.aws_ami.amazon_linux.id}"
    instance_type = "${var.aws_instance_type}"
    availability_zone = "${lookup(var.aws_availability_zones, count.index)}"

    key_name = "${aws_key_pair.deployer.key_name}"
    vpc_security_group_ids  = [ "${var.sg_id}"]
    subnet_id = "${var.subnet_id}"
    associate_public_ip_address = true

    connection {
        user = "ec2-user"
        private_key = "${file(var.aws_private_key)}"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo yum install -y docker",
            "sudo service docker start",
        ]
    }

    tags {
        Name = "Terraform"
    }
}

