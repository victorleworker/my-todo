# Todo API Setup Guide

This guide explains how to set up and run the Todo API application using Docker containers.

## Prerequisites

- Docker installed on your system
- Node.js 8.15.1 (for local development)
- Git (for version control)

## Dependencies

The application relies on the following services:
- PostgreSQL 11.2 (Database)
- Redis 5.0.3 (Caching)
- Elasticsearch 8.2.0 (Search Engine)
- Node.js Express API

## Setup Instructions

### 1. Create Docker Network

First, create a Docker network to allow communication between containers:
bash
docker network create todo-net

### 2. Start PostgreSQL Container

Run PostgreSQL database container:
bash
docker run --network todo-net \
--name todo-postgres \
-p 5432:5432 \
-e POSTGRES_USER=todo \
-e POSTGRES_PASSWORD=todo1234 \
-e POSTGRES_DB=todo \
-d postgres:11.2
### 3. Start Redis Container

Run Redis cache container:
bash
docker run --network todo-net \
--name todo-redis \
-d -p 6379:6379 \
redis:5.0.3
### 4. Start Elasticsearch Container

Run Elasticsearch container:
bash
docker run --network todo-net \
--name todo-elastic \
-d -p 9200:9200 -p 9300:9300 \
-e "discovery.type=single-node" \
elasticsearch:8.2.0

### 5. Build and Run Todo API

Build the API container:
bash
docker build . -f dockerfile.dev --tag todo-api:1.0
Run the API container:
bash
docker run --name todo-api \
--network todo-net \
-it \
-v /app/node_modules \
-p 3000:3000 \
-e POSTGRES_HOST=todo-postgres \
-e POSTGRES_PORT=5432 \
-e POSTGRES_DATABASE=todo \
-e POSTGRES_USER=todo \
-e POSTGRES_PASSWORD=todo1234 \
-e REDIS_HOST=todo-redis \
-e REDIS_PORT=6379 \
-e ELASTICSEARCH_HOST=todo-elastic \
-e ELASTICSEARCH_PORT=9200 \
todo-api:1.0
## Verification

After setting up all containers, you can verify the API is working by:

1. Checking if the API is running: `http://localhost:3000`
2. Testing the PostgreSQL connection: `docker logs todo-postgres`
3. Verifying Redis connection: `docker logs todo-redis`
4. Confirming Elasticsearch is up: `http://localhost:9200`

## Troubleshooting

If you encounter issues:

1. Ensure all containers are running:
bash
docker ps
2. Check container logs:
bash
docker logs <container-name>
3. Verify network connectivity:
bash
docker network inspect todo-net

## Cleanup

To stop and remove all containers:
bash
docker stop todo-api todo-postgres todo-redis todo-elastic
docker rm todo-api todo-postgres todo-redis todo-elastic
docker network rm todo-net
```

This README provides a clear, step-by-step guide for setting up the todo-api application using Docker containers. It includes all necessary commands, prerequisites, and troubleshooting steps. The formatting is clean and organized, making it easy for users to follow the setup process.