#!/bin/bash

export RMQ_HOST="rabbitmq1"
export RMQ_PORT="5672"
export RMQ_VHOST="/"
export RMQ_USER="vcap"
export RMQ_PASS="changeme"
export RMQ_EXCHANGE=""
export RMQ_QUEUE="hello"
export RMQ_MSG_BODY=1000000
export RMQ_SLEEP=0.0
export RMQ_DURABLE="False"

python /vagrant/producer.py
