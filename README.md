# EQWorks Assessment

## Run and Setup the Stack

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

## License
[MIT](https://choosealicense.com/licenses/mit/)
