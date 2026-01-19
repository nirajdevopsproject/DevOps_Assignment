# RDS Subnet Group (PRIVATE subnets only)
resource "aws_db_subnet_group" "main" {
  name       = "rds-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "rds-subnet-group"
  }
}

resource "aws_db_instance" "postgres" {
engine = "postgres"
engine_version = "15"
instance_class = "db.t3.micro"
allocated_storage = 20


db_name = "appdb"
username = "admin"
password = "password123"


multi_az = true
backup_retention_period = 7
vpc_security_group_ids = [aws_security_group.rds_sg.id]
db_subnet_group_name = aws_db_subnet_group.main.name
}