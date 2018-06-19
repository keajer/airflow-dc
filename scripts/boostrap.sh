#!/bin/bash
set -e

AIRFLOW_HOME="/usr/local/airflow"

sed -i "s/postgres_host/$POSTGRES_HOST/" "$AIRFLOW_HOME"/airflow.cfg
sed -i "s/redis_host/$REDIS_HOST/" "$AIRFLOW_HOME"/airflow.cfg
sed -i "s/web_server_host_name/$WEBSERVER_HOST_NAME/" "$AIRFLOW_HOME"/airflow.cfg
sed -i "s/postgres_pwd/$POSTGRES_PWD/" "$AIRFLOW_HOME"/airflow.cfg

sleep 10

if [ "$TYPE" = "web_server" ]; then
    airflow initdb
    airflow webserver
elif [ "$TYPE" = "worker" ]; then
    airflow worker
elif [ "$TYPE" = "scheduler" ]; then
    airflow scheduler -p
else
    airflow flower
fi
