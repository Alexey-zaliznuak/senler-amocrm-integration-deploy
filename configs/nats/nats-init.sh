#!/bin/bash

export NATS_URL=nats://nats:4222

# Основной поток
nats stream add INTEGRATION_SYNC_VARS \
  --subjects "integration.syncVars" \
  --ack \
  --retention limits \
  --discard old \
  --max-msgs=-1 \
  --max-bytes=-1 \
  --max-age=24h \
  --storage file \
  --replicas 1 \
  --dupe-window 2m \
  --max-msg-size=-1 \
  --max-msgs-per-subject=-1 \
  --no-allow-rollup \
  --no-deny-delete \
  --no-deny-purge \
  --defaults

# DLQ поток
nats stream add INTEGRATION_SYNC_VARS_DLQ \
  --subjects "integration.syncVars.dlq" \
  --ack \
  --retention limits \
  --discard old \
  --max-msgs=-1 \
  --max-bytes=-1 \
  --max-age=24h \
  --storage file \
  --replicas 1 \
  --dupe-window 2m \
  --max-msg-size=-1 \
  --max-msgs-per-subject=-1 \
  --no-allow-rollup \
  --no-deny-delete \
  --no-deny-purge \
  --defaults

# Основной потребитель (3 попытки)
nats consumer add INTEGRATION_SYNC_VARS INTEGRATION_SYNC_VARS_CONSUMER \
  --ack explicit \
  --pull \
  --deliver all \
  --filter "integration.syncVars" \
  --deliver-group "workers" \
  --max-deliver 3 \
  --replay instant \
  --sample 100 \
  --max-pending 100 \
  --wait 1m \
  --memory \
  --backoff none \
  --no-headers-only \
  --defaults

# Потребитель DLQ (ретраз каждую минуту 24 часа)
nats consumer add INTEGRATION_SYNC_VARS_DLQ INTEGRATION_SYNC_VARS_DLQ_CONSUMER \
  --ack explicit \
  --pull \
  --deliver all \
  --filter "integration.syncVars.dlq" \
  --deliver-group "dlq_workers" \
  --max-deliver 1440 \
  --replay instant \
  --sample 100 \
  --max-pending 100 \
  --wait 1m \
  --memory \
  --backoff linear \
  --backoff-steps 1440 \
  --backoff-min 1m \
  --backoff-max 1m \
  --no-headers-only \
  --defaults