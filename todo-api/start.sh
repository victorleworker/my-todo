#! /bin/bash
# Wait for Elasticsearch to be ready
max_attempts=60  # Increased attempts
attempt=1

while [ $attempt -le $max_attempts ]; do
    if curl -s http://todo-elastic:9200; then
        echo "Elasticsearch is ready!"
        break
    fi
    echo "Waiting for Elasticsearch (attempt $attempt/$max_attempts)..."
    sleep 2  # Shorter sleep interval
    attempt=$((attempt + 1))
done

if [ $attempt -gt $max_attempts ]; then
    echo "Error: Elasticsearch did not become ready in time"
    exit 1
fi

# Start the application
npm start