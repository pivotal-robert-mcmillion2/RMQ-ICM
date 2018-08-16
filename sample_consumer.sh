#!/bin/bash

export RMQ_HOST="rabbitmq1"
export RMQ_PORT="5672"
export RMQ_VHOST="/"
export RMQ_USER="vcap"
export RMQ_PASS="changeme"
export RMQ_EXCHANGE=""
export RMQ_QUEUE="hello"
export RMQ_MSG_BODY=100
export RMQ_SLEEP=0.2
export RMQ_DURABLE="False"

python /vagrant/consumer.py
