variable "postgres_password" {
  description = "Postgres database password"
  type        = string
  sensitive   = true
}

variable "aws_rds_pgpassword" {
  description = "Password to connect to AWs RDS"
  type        = string
  sensitive   = true
}


variable "postgres_container_port" {
  description = "Postgres Container (inside Pod) Port"
  type        = string
}

variable "postgres_target_port" {
  type = string
}

variable "aws_rds_hostname" {
  description = "Postgres Container (inside Pod) Port"
  type        = string
}

variable "aws_rds_db_username" {
  description = "Postgres Container (inside Pod) Port"
  type        = string
}

variable "aws_rds_db_name" {
  description = "Postgres Container (inside Pod) Port"
  type        = string
}

variable "api_container_port" {
  description = "API Container (inside Pod) Port"
  type        = string
}

variable "api_service_port" {
  description = "API Kubernetes Service Port"
  type        = string
}

variable "api_image" {
  description = "API Image Path"
  type        = string
}

variable "api_replicas" {
  description = "API Replicas"
  type        = string
}

variable "postgres_replicas" {
  description = "Postgres Replicas"
  type        = string
}
