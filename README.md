# Fleet Management

## <p style="color:teal">Authors</p>

- [@sharantechuser](https://www.github.com/sharantechuser)


## <p style="color: orange">1. About project</p>
This application developed by using microservice architecture using docker container

### Microservices

1. angular-vehicle-tracking
2. go-redis-kafka
3. spring-ws-kafka
4. redis docker container
5. apache-kafka docker container

### angular-vehicle-tracking

A angular based application developed for UI to visualize the vehicle movement based on location co-ordinates. It uses leaflet.js library to implement openStreetMap

### go-redis-kafka

A Go microservice. This will publish the vehicle co-ordinates to apache kafka and store in redis cache as well.

### spring-ws-kafka
A spring boot application. It consumes kafka topic  and to web-socket clients. Front end service will subscribe to web-socket to read the data.

### redis docker container


### apache kafka docker container

## <p style="color: orange">2. Make buid & run</p>

``` 
make docker-run
```
## <p style="color: orange">3. Docer containers</p>

### <p style="color: orange">1. redis docker container</p>

``` 
# redis docker image
docker pull redis

# docker run redis 
docker run -d --rm --name redis -e REDIS_PASSWORD=admin -p 6379:6379 redis

# docker login to redis 
docker exec -it redis bash redis-cli
```

### <p style="color: orange">2. apache zookeeper</p>
```
#apache kafka with zookeeper
    docker run -d --rm --name myzookeeper --network vehicle-tracking-network -p 2181:2181 wurstmeister/zookeeper:latest
```

### <p style="color: orange">2. apache kafka docker container run</p>

```
# docker image 

    docker run -d --rm --name mykafka --network vehicle-tracking-network -p 9092:9092 -e KAFKA_ZOOKEEPER_CONNECT=myzookeeper:2181 -e KAFKA_ADVERTISED_LISTENERS=INSIDE://mykafka:9093,OUTSIDE://localhost:9092 -e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=INSIDE:PLAINTEXT,OUTSIDE:PLAINTEXT -e KAFKA_LISTENERS=INSIDE://0.0.0.0:9093,OUTSIDE://0.0.0.0:9092 -e KAFKA_LISTENER_NAME=INSIDE -e KAFKA_LISTENER_NAME=OUTSIDE -e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=INSIDE:PLAINTEXT,OUTSIDE:PLAINTEXT -e KAFKA_INTER_BROKER_LISTENER_NAME=INSIDE wurstmeister/kafka:latest

# docker login to container
docker exec -it kafka bash
```

### <p style="color: orange">3. angular-vehicle-tracking docker container run</p>

```
# docker image 
    docker build -t angular-vehicle-tracking .
# docker run
    docker run -d --rm --name angular-vehicle-tracking --network vehicle-tracking-network -p 8090:80 angular-vehicle-tracking
```

### <p style="color: orange">4. go-redis-kafka docker container run</p>

```
# docker build 
     docker build -t go-redis-kafka .

# docker run
    docker run -d --rm --name go-redis-kafka --network vehicle-tracking-network -p 9090:9090 -e REDIS_HOST_URL=myredis:6379 -e KAFKA_HOST_URL=mykafka:9093 -e APP_PORT=9090 go-redis-kafka
```

### <p style="color: orange">5. spring-ws-kafka docker container run</p>

```
# docker build 
    docker build -t spring-ws-kafka .

# docker run
    docker run -d --rm --name spring-ws-kafka --network vehicle-tracking-network -p 8080:8080 -e SPRING_KAFKA_BOOTSTRAP_SERVERS=mykafka:9093 spring-ws-kafka
```
