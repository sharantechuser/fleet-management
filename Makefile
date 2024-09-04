KAFKA_HOST = mykafka:9093
REDIS_HOST = myredis:6379
DOCKER_NETWORK = --network vehicle-tracking-network

# spring-ws-kafka
SPRING_WS_KAFKA_SVC_NAME = spring-ws-kafka
SPRING_WS_KAFKA_IMAGE_NAME = spring-ws-kafka
SPRING_WS_KAFKA_CONTAINER_PORT ?= 8080

# go-redis-kafka
GO_REDIS_KAFKA_SVC_NAME = go-redis-kafka
GO_REDIS_KAFKA_IMAGE_NAME = go-redis-kafka
GO_REDIS_KAFKA_CONTAINER_PORT = 9090

# angular-vehicle-tracking
ANGULAR_VEHICLE_TRACKING_SVC_NAME = angular-vehicle-tracking
ANGULAR_VEHICLE_TRACKING_IMAGE_NAME = angular-vehicle-tracking
ANGULAR_VEHICLE_TRACKING_CONTAINER_PORT = 80
ANGULAR_VEHICLE_TRACKING_OUT_PORT = 8090
ANGULAR_VEHICLE_TRACKING_ENV = production


docker-run: spring-ws-kafka-run go-redis-kafka-run angular-vehicle-tracking-run

# -------------------------------------- spring-ws-kafka

spring-ws-kafka-run: spring-ws-kafka-image spring-ws-kafka-image-run

spring-ws-kafka-image:
	docker build --build-arg CONTAINER_PORT=$(SPRING_WS_KAFKA_CONTAINER_PORT) -t $(SPRING_WS_KAFKA_IMAGE_NAME) .

spring-ws-kafka-image-run:
	docker run -d --rm --name $(SPRING_WS_KAFKA_SVC_NAME) $(DOCKER_NETWORK) -p $(SPRING_WS_KAFKA_CONTAINER_PORT):$(SPRING_WS_KAFKA_CONTAINER_PORT) -e SPRING_KAFKA_BOOTSTRAP_SERVERS=$(KAFKA_HOST) $(SPRING_WS_KAFKA_IMAGE_NAME)

# -------------------------------------- go-redis-kafka

go-redis-kafka-run: go-redis-kafka-image go-redis-kafka-image-run

go-redis-kafka-image:
	docker build --build-arg CONTAINER_PORT=$(GO_REDIS_KAFKA_CONTAINER_PORT) -t $(GO_REDIS_KAFKA_IMAGE_NAME) .

go-redis-kafka-image-run:
	docker run -d --rm --name $(GO_REDIS_KAFKA_SVC_NAME) $(DOCKER_NETWORK) -p $(GO_REDIS_KAFKA_CONTAINER_PORT):$(GO_REDIS_KAFKA_CONTAINER_PORT) -e REDIS_HOST_URL=$(REDIS_HOST) -e KAFKA_HOST_URL=$(KAFKA_HOST) -e APP_PORT=$(GO_REDIS_KAFKA_CONTAINER_PORT) $(GO_REDIS_KAFKA_IMAGE_NAME)

# -------------------------------------- angular-vehicle-tracking
angular-vehicle-tracking-run: docker-image docker-image-run

angular-vehicle-tracking-image:
	docker build --build-arg CONTAINER_PORT=$(ANGULAR_VEHICLE_TRACKING_CONTAINER_PORT) --build-arg ENV=$(ANGULAR_VEHICLE_TRACKING_ENV) -t $(ANGULAR_VEHICLE_TRACKING_IMAGE_NAME) .

angular-vehicle-tracking-image-run:
	docker run -d --rm  --name $(ANGULAR_VEHICLE_TRACKING_SVC_NAME) $(ANGULAR_VEHICLE_TRACKING_DOCKER_NETWORK) -p $(ANGULAR_VEHICLE_TRACKING_OUT_PORT):$(ANGULAR_VEHICLE_TRACKING_CONTAINER_PORT) $(ANGULAR_VEHICLE_TRACKING_IMAGE_NAME)