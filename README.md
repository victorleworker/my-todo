I'll help you create a comprehensive README for running the Docker services. Here's a well-structured README:

```markdown
# Todo Application Docker Setup Guide

A containerized todo application built with Angular frontend, Node.js backend, and multiple supporting services.

## Prerequisites

- Docker
- Docker Compose
- Git (for cloning the repository)

## Services Architecture

The application consists of the following services:
- `todo-view`: Angular frontend application (port 4200)
- `todo-api`: Node.js backend API (port 3000)
- `todo-proxy`: Nginx reverse proxy (port 80)
- `todo-postgres`: PostgreSQL database (port 5432)
- `todo-redis`: Redis cache (port 6379)
- `todo-elastic`: Elasticsearch service (port 9200)

## Setup Instructions

### 1. Create Docker Network

First, create a Docker network to enable communication between containers:

```bash
docker network create todo-net
```

### 2. Start Supporting Services

Start PostgreSQL:
```bash
docker run --network todo-net \
  --name todo-postgres \
  -p 5432:5432 \
  -e POSTGRES_USER=todo \
  -e POSTGRES_PASSWORD=todo1234 \
  -e POSTGRES_DB=todo \
  -d postgres:11.2
```

Start Redis:
```bash
docker run --network todo-net \
  --name todo-redis \
  -d -p 6379:6379 \
  redis:5.0.3
```

Start Elasticsearch:
```bash
docker run --network todo-net \
  --name todo-elastic \
  -d -p 9200:9200 -p 9300:9300 \
  -e "discovery.type=single-node" \
  elasticsearch:8.2.0
```

### 3. Build and Run Application Services

Build and run the backend API:
```bash
# Build API image
docker build . -f dockerfile.dev --tag todo-api:1.0

# Run API container
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
```

Build and run the frontend:
```bash
# Build frontend image
docker build . -f dockerfile.dev --tag todo-view:1.0

# Run frontend container
docker run --name todo-view \
  --network todo-net \
  -it \
  -v ${PWD}:/usr/src/app \
  -v /usr/src/app/node_modules \
  -p 4200:4200 \
  todo-view:1.0
```

Build and run the proxy:
```bash
# Build proxy image
docker build . -f dockerfile.dev --tag todo-proxy:1.0

# Run proxy container
docker run --name todo-proxy \
  --network todo-net \
  -it \
  -p 8080:80 \
  todo-proxy:1.0
```

## Verification

1. Access the application at: `http://localhost:8080`
2. API endpoint: `http://localhost:8080/api`
3. Check service health:
   - PostgreSQL: `docker logs todo-postgres`
   - Redis: `docker logs todo-redis`
   - Elasticsearch: `http://localhost:9200`

## Troubleshooting

If you encounter issues:

1. Check container status:
```bash
docker ps -a
```

2. View container logs:
```bash
docker logs <container-name>
```

3. Verify network connectivity:
```bash
docker network inspect todo-net
```

## Cleanup

To stop and remove all containers:
```bash
# Stop containers
docker stop todo-proxy todo-view todo-api todo-postgres todo-redis todo-elastic

# Remove containers
docker rm todo-proxy todo-view todo-api todo-postgres todo-redis todo-elastic

# Remove network
docker network rm todo-net
```

## Development Notes

- The frontend runs with hot-reload enabled
- API changes require container restart
- Proxy configuration is in nginx.config
```

This README provides a complete guide for setting up and running all the Docker services in your todo application. It includes all necessary commands, environment variables, and troubleshooting steps.
