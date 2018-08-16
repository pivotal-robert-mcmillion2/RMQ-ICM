#!/usr/bin/env python
import os
import logging
import pika
from time import sleep

# Params
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
logging.info("Configure credentials")
credentials = pika.PlainCredentials(rmq_user, rmq_pass)

logging.info("Connect to RabbitMQ on host={0} port={1} vhost={2}".format(rmq_host, rmq_port, rmq_vhost))
connection = pika.BlockingConnection(pika.ConnectionParameters(rmq_host, rmq_port, rmq_vhost, credentials=credentials))

logging.info("Create channel")
channel = connection.channel()

logging.info("Declare queue '{0}'".format(rmq_queue))
channel.queue_declare(queue=rmq_queue, durable=rmq_durable)

logging.info("Defining consumer callback")
def consume_callback(ch, method, properties, body):
    logging.info("Received msg '{0}'".format(body[:50]))
    sleep(rmq_sleep)

channel.basic_consume(consume_callback,
                      queue=rmq_queue,
                      no_ack=True)

logging.info("Consuming")
channel.start_consuming()
