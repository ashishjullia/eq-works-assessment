# EQWorks Assessment

## 1. Containerization - Run and Setup the Stack

```bash
$ git clone https://github.com/ashishjullia/eq-works-assessment.git
```
```bash
$ cd eq-works-assessment
.
[-rw-rw-r--]  ./LICENSE
[-rw-rw-r--]  ./README.md
[-rwxrwxr-x]  ./clean.sh
[-rw-rw-r--]  ./docker-compose.yml
[drwxrwxr-x]  ./env-templates
[-rw-rw-r--]  ./env-templates/app.env.template
[-rw-rw-r--]  ./env-templates/stack.env.template
[-rwxrwxr-x]  ./main.sh
[drwxrwxr-x]  ./ws-product-nodejs
[-rw-rw-r--]  ./ws-product-nodejs/Dockerfile
[-rw-rw-r--]  ./ws-product-nodejs/index.js
[-rw-rw-r--]  ./ws-product-nodejs/package-lock.json
[-rw-rw-r--]  ./ws-product-nodejs/package.json
````
Create a universal "services.env" file in the "eq-works-assessment" directory.

```bash
$ touch services.env
```

### Now, paste all the variables names to "services.env" file and populate it with the values of your choice.
##### Note: Although, it can be made dynamic still try to keep the "DB_PGPORT=5432" and "PORT=8080".

```bash
# Provide "postgres remote host url" and "password" for that
export PGPASSWORD=
export PGHOST=

# Provide directory names
export DATA_DIRECTORY=
export DB_FILES_DIRECTORY=

# Application level - provide values considering the "nodejs application".
export DB_PGUSER=
export DB_PGNAME=
export DB_PGPASS=
export DB_PGPORT=
export PORT=

# Docker-Compose level env variables
export POSTGRES_PASSWORD=
export POSTGRES_DATA_CONTAINER_NAME=
export APP_CONTAINER_NAME=
```

## Create/Start the stack
```bash
$ ./main.sh
```


### To view/confirm the stack is up and running:
Before running the following command, make sure you are in the "eq-works-assessment" directory.
```bash
$ sudo docker-compose ps
```

##### Note: Beware of the "clean.sh" file, only run this when you want to completely clean your system from docker files/images/volumes (High Risk)

## 2. Continuous integration and deployment
In order to look for a successful run, please visit -> [https://github.com/ashishjullia/eq-works-assessment/actions](https://github.com/ashishjullia/eq-works-assessment/actions)

## 3. Infrastructure codification
Before running the following command(s), make sure you've "minikube" and "terraform" installed on your machine.
```bash
$ cd terraform
```
In "terraform/terraform.tfvars", make sure to input the values of variables mentioned and then run the following command.

```bash
$ terraform init
```

```bash
$ terraform apply
```

In order to access the "API" and its endpoints running under the minikube (kubernetes) cluster, please follow:
```bash
$ minikube service nodeapp -n eq
```
It will return an IP:PORT, you can access the API on that.

## 4. API performance testing

The testing tool used here is "JMeter".

#### Specification of the runtime resources (CPU/Memory):
```bash
api_cpu_request= "250m"
api_memory_request= "256Mi"
api_cpu_limit= "700m"
api_memory_limit= "512Mi"

postgres_cpu_request= "250m"
postgres_memory_request= "256Mi"
postgres_cpu_limit= "700m"
postgres_memory_limit= "512Mi"
```
#### Summary of potential bottlenecks (across all containerized services):
For the "runtime resources" mentioned above, I performed 3 different steps for 3 different "test configurations" as follows:
> 2000 users (threads) - 1 loop - successful run (no errors)
>> 2500 users (threads) - 1 loop - successful run (no errors)
>>> 3000 users (threads) - 1 loop - successful run (with a few errors) (bottleneck)

![2000 users (threads) - 1 loop - successful run (no errors)](./images/Image1.png?raw=true "2000 users (threads) - 1 loop - successful run (no errors)")

##### Note: Please find the "images" in the "images/" directory.
#### Tuning/scaling suggestions and companion Terraform CLI commands to achieve them:
Using the command below (example), the cluster underlying can be scale-up defining the values for variables mentioned in "terraform.tfvars" files
```bash
$ cd terraform/
```
```bash
$ terraform apply -var api_replicas="1" -var api_cpu_limit="500m" -var api_memory_limit="512Mi" -var api_cpu_request="500m" -var postgres_memory_limit="512Mi" -var postgres_cpu_request="500m"
```
#### Note: Because of resources constraint on my machine, I was able to give up these much resources to pods inside the "minikube cluster". 

## License
[MIT](https://choosealicense.com/licenses/mit/)
