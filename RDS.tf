resource "aws_db_instance" "rds_instance" {
  identifier             = var.db_instance_name
  allocated_storage      = var.rds_db_size
  db_name                = var.db_name
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  username               = var.db_username
  password               = random_password.password.result
  port                   = var.rds_port
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_grp.name
  vpc_security_group_ids = [aws_security_group.rds-ec2.id]
  skip_final_snapshot    = true
}

resource "aws_db_subnet_group" "db_subnet_grp" {
  name       = "${var.db_instance_name}-grp"
  subnet_ids = aws_subnet.private_subnets.*.id

  tags = {
    Name = "${var.db_instance_name}-subnet-group"
  }
}



resource "random_password" "password" {
  length      = 20
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
  special     = false
}