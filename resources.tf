data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
}

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

resource "aws_security_group" "testcc_sg" {
  name = "testcc_sg"
  description = "security group to allows inbound and outbound traffic"
  vpc_id      = "${data.aws_vpc.default.id}"
  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }
  egress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
 

  tags { 
    Name = "testcc_sg" 
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
    security_groups = [ "${aws_security_group.testcc_sg.name}" ]
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
        Name = "Terraform "
    }
}

