#!/bin/bash

# Ждем запуск NATS
sleep 5

# Создаем основной поток
nats stream add INTEGRATION_SYNC_VARS \
  --subjects "integration.syncVars" \
  --ack \
  --max-age 24h \
  --retention limits \
  --max-msgs=-1 \
  --max-bytes=-1 \
  --max-msg-size=-1 \
  --storage file \
  --replicas 1 \
  --no-deny-delete \
  --no-deny-purge

# Создаем поток для DLQ
nats stream add INTEGRATION_SYNC_VARS_DLQ \
  --subjects "integration.syncVars.dlq" \
  --ack \
  --max-age 24h \
  --retention limits \
  --max-msgs=-1 \
  --max-bytes=-1 \
  --max-msg-size=-1 \
  --storage file \
  --replicas 1 \
  --no-deny-delete \
  --no-deny-purge

# Создаем потребителя
nats consumer add INTEGRATION_SYNC_VARS INTEGRATION_SYNC_VARS_CONSUMER \
  --ack explicit \
  --pull \
  --deliver all \
  --replay instant \
  --filter "integration.syncVars" \
  --max-deliver 1

# Создаем потребителя с настройками повторных попыток
nats consumer add INTEGRATION_SYNC_VARS_DLQ INTEGRATION_SYNC_VARS_DLQ_CONSUMER \
  --ack explicit \
  --pull \
  --deliver all \
  --replay instant \
  --filter "integration.syncVars.dlq" \
  --max-deliver=-1 \
  --backoff "1m,1m,1m,1m,1m,1m,1m,1m" \
  --wait 1m

echo "NATS streams and consumers are initialized"