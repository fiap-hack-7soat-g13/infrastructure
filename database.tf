resource "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  name   = "security-group"
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_db_instance" "default" {
  identifier             = "database-1"
  instance_class         = "db.t4g.micro"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "16.3"
  username               = var.db_username
  password               = var.db_password
  publicly_accessible    = true
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.default.id]
}
provider "postgresql" {
  host     = aws_db_instance.default.address
  username = aws_db_instance.default.username
  password = aws_db_instance.default.password
}
resource "postgresql_database" "user_api" {
  name = "user_api"
}
resource "postgresql_database" "video_api" {
  name = "video_api"
}
