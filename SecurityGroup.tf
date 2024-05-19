
resource "aws_security_group" "alb-sg" {
  name        = "${var.albname}-sg"
  description = "Allow incoming LoadBalncing traffic"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "ec2-server-sg" {
  name        = "${var.instance_name}-sg"
  description = "Allow incoming Http Conncections"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "rds-ec2" {
  name   = "rds-ec2"
  vpc_id = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "rds-ec2-rule" {
  type                     = "ingress"
  from_port                = var.rds_port
  to_port                  = var.rds_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds-ec2.id
  source_security_group_id = aws_security_group.ec2-rds.id
}

resource "aws_security_group" "ec2-rds" {
  name   = "ec2-rds"
  vpc_id = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "ec2-rds-rule" {
  type                     = "egress"
  from_port                = var.rds_port
  to_port                  = var.rds_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2-rds.id
  source_security_group_id = aws_security_group.rds-ec2.id
}