terraform {
  backend "s3" {
    bucket = "terraform-state-c0496bfa"
    key    = "infrastructure"
    region = "us-east-1"
  }
  required_providers {
    postgresql = {
      source = "cyrilgdn/postgresql"
    }
    rabbitmq = {
      source = "cyrilgdn/rabbitmq"
    }
  }
}
provider "aws" {
  region = var.region
}
data "aws_vpc" "default" {
  default = true
}
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
resource "aws_mq_broker" "default" {
  broker_name                = "default"
  engine_type                = "RabbitMQ"
  engine_version             = "3.13"
  host_instance_type         = "mq.t3.micro"
  auto_minor_version_upgrade = true
  publicly_accessible        = true
  user {
    username = var.mq_username
    password = var.mq_password
  }
}
provider "rabbitmq" {
  endpoint = aws_mq_broker.default.instances.0.console_url
  username = var.mq_username
  password = var.mq_password
}
resource "rabbitmq_queue" "video_received" {
  name = "video_received"
  settings {
    durable = true
  }
}
resource "rabbitmq_queue" "video_status_changed" {
  name = "video_status_changed"
  settings {
    durable = true
  }
}
