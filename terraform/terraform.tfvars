postgres_password       = "testpassword"
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
