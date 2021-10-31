postgres_password       = ""
postgres_container_port = "5432"
postgres_target_port    = "5432"

aws_rds_pgpassword  = ""
aws_rds_hostname    = ""
aws_rds_db_username = ""
aws_rds_db_name     = ""

api_container_port = "8080"
api_service_port   = "8080"

api_image = "ashishjullia19/ws-product-nodejs"

api_replicas= "1"
postgres_replicas = "1"

api_cpu_request= "250m"
api_memory_request= "256Mi"
api_cpu_limit= "700m"
api_memory_limit= "512Mi"

postgres_cpu_request= "250m"
postgres_memory_request= "256Mi"
postgres_cpu_limit= "700m"
postgres_memory_limit= "512Mi"
