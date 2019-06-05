variable "access_key" {
	default = "KI"
}
variable "secret_key" {
	default = "RO"
}
variable "aws_region" {
    default = "us-east-1"
}

variable "aws_private_key" {
	default = "master"
}

variable "aws_pub_key" {
	default = "master.pub"
}

variable "aws_amis" {
    default = {
        us-east-1 = "ami-26c43149" # north virginia
    }
}
variable "aws_instance_type" {
	default = "t2.micro"

}

variable "aws_availability_zones" {
    default = {
        "0" = "us-east-1a"
        "1" = "us-east-1b"
        "2" = "us-east-1c"
    }
}

