#!/bin/bash

# =============================================================================
# Fix Hive Database Issue
# This script stops containers, removes volumes, and restarts fresh
# =============================================================================

echo "============================================================"
echo "Fixing Hive Database Configuration Issue"
echo "============================================================"

# Stop and remove all containers
echo ""
echo "[1/4] Stopping containers..."
docker compose -f task2-docker-compose.yaml down

# Remove volumes to clear old database
echo ""
echo "[2/4] Removing old volumes..."
docker compose -f task2-docker-compose.yaml down -v

# List volumes to confirm
echo ""
echo "Remaining volumes:"
docker volume ls | grep cw-msc || echo "  All task2 volumes removed successfully"

# Restart services
echo ""
echo "[3/4] Starting services fresh..."
docker compose -f task2-docker-compose.yaml up -d

# Wait for services to initialize
echo ""
echo "[4/4] Waiting for services to initialize (30 seconds)..."
sleep 30

echo ""
echo "============================================================"
echo "Checking service status..."
echo "============================================================"
docker compose -f task2-docker-compose.yaml ps

echo ""
echo "============================================================"
echo "Checking PostgreSQL logs..."
echo "============================================================"
docker compose -f task2-docker-compose.yaml logs hive-metastore-postgresql | tail -20

echo ""
echo "============================================================"
echo "Done! Monitor logs with:"
echo "  docker compose -f task2-docker-compose.yaml logs -f"
echo "============================================================"
