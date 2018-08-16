#!/usr/bin/env python
import os
import logging
import pika
from time import sleep
import string
from random import *

# Read all params from ENV
# --------------------
rmq_host = os.environ["RMQ_HOST"]
rmq_port = os.environ["RMQ_PORT"]
rmq_vhost = os.environ["RMQ_VHOST"]
rmq_user = os.environ["RMQ_USER"]
rmq_pass = os.environ["RMQ_PASS"]
rmq_exchange = os.environ["RMQ_EXCHANGE"]
rmq_queue = os.environ["RMQ_QUEUE"]
rmq_msg_body = os.environ["RMQ_MSG_BODY"]
rmq_sleep = os.environ["RMQ_SLEEP"]
rmq_durable = os.environ["RMQ_DURABLE"]
# --------------------

rmq_port = int(rmq_port)
rmq_sleep = float(rmq_sleep)
rmq_durable = True if rmq_durable == "True" else False

# Logging stuff... no need to modify
logging.getLogger("pika").setLevel(logging.WARNING)
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s.%(msecs)03d %(levelname)s %(message)s',
    datefmt="%Y-%m-%d %H:%M:%S")

# Main code
# --------------------

min_char = int(rmq_msg_body)
max_char = int(rmq_msg_body)
allchar = string.ascii_letters + string.punctuation + string.digits

logging.info("Configure credentials")
credentials = pika.PlainCredentials(rmq_user, rmq_pass)

logging.info("Connect to RabbitMQ on host={0} port={1} vhost={2}".format(rmq_host, rmq_port, rmq_vhost))
connection = pika.BlockingConnection(pika.ConnectionParameters(rmq_host, rmq_port, rmq_vhost, credentials=credentials))

logging.info("Create channel")
channel = connection.channel()

channel.confirm_delivery()

logging.info("Declare queue '{0}'".format(rmq_queue))
channel.queue_declare(queue=rmq_queue, durable=rmq_durable)

while True:
    logging.info("Publish message to exchange '{0}' with routing key '{1}'".format(rmq_exchange, rmq_queue))
    rmq_msg_body = "".join(choice(allchar) for x in range(randint(min_char, max_char)))
    status = channel.basic_publish(exchange=rmq_exchange,
                          routing_key=rmq_queue,
                          body=rmq_msg_body)

    sleep(rmq_sleep)

logging.info("Closing connection")
connection.close()
