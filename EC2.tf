resource "aws_instance" "ec2-server" {
  subnet_id     = aws_subnet.public_subnets[2].id
  ami           = var.ami
  instance_type = var.instance_type
  ebs_block_device {
    device_name           = "/dev/xvda"
    delete_on_termination = true
    encrypted             = true
    volume_size           = var.root_ebs_size
    volume_type           = var.root_ebs_type
    tags = {
      Name = "This is a Root Volume"
    }
  }

  key_name                    = aws_key_pair.key_pair.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2-server-sg.id, aws_security_group.ec2-rds.id]
  user_data                   = file("data.sh")
  tags = {
    name = "${var.instance_name}"
  }
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.id
}

resource "aws_ebs_volume" "extra_ebs" {
  availability_zone = var.availability_zones[2]
  size              = var.extra_ebs_size
  type              = var.extra_ebs_type
  encrypted         = true
  tags = {
    Name = "This is a Extra Volume"
  }
}

resource "aws_volume_attachment" "extra_ebs_att" {
  device_name = "/dev/xvdb"
  volume_id   = aws_ebs_volume.extra_ebs.id
  instance_id = aws_instance.ec2-server.id
}

