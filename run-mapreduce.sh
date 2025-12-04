#!/bin/bash

# =============================================================================
# Run MapReduce Job - Task 2
# Uploads data to HDFS and executes the SummaryMonthly MapReduce job
# =============================================================================

set -e

echo "============================================================"
echo "Task 2 - MapReduce Job Execution"
echo "============================================================"
echo ""

echo "[1/4] Uploading weather data to HDFS..."
docker exec -it namenode bash -c "
  # Create directory structure in HDFS
  hdfs dfs -mkdir -p /opt/data

  # Upload weather data to HDFS (skip if already exists)
  hdfs dfs -test -d /opt/data/weather || hdfs dfs -put /opt/data/weather /opt/data/

  # Verify upload
  echo 'Weather data in HDFS:'
  hdfs dfs -ls /opt/data/weather
"

echo ""
echo "[2/4] Removing previous output (if exists)..."
docker exec -it namenode bash -c "
  hdfs dfs -rm -r -f /output/monthly
"

echo ""
echo "[3/4] Running MapReduce job..."
docker exec -it namenode bash -c "
  hadoop jar /opt/mapreduce-jars/BigDataProject-1.0-SNAPSHOT.jar \
    org.example.SummaryMonthly \
    /opt/data/weather \
    /output/monthly
"

echo ""
echo "[4/4] Checking output..."
docker exec -it namenode bash -c "
  echo 'Output files:'
  hdfs dfs -ls /output/monthly

  echo ''
  echo 'Sample output (first 20 lines):'
  hdfs dfs -cat /output/monthly/part-* | head -20
"

echo ""
echo "============================================================"
echo "Done! Full output available at: /output/monthly in HDFS"
echo "============================================================"
