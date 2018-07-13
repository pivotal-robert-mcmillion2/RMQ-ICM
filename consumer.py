#!/usr/bin/env python
import logging
import pika
from time import sleep

# Params
# --------------------
rmq_host = "rabbitmq1"
rmq_port = 5672
rmq_user = "vcap"
rmq_pass = "changeme"
rmq_exchange = ""
rmq_queue = "hello"
rmq_msg_body = "Hello World"
rmq_sleep = 0.0
# --------------------

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

logging.info("Connect to RabbitMQ on {0}:{1}".format(rmq_host, rmq_port))
connection = pika.BlockingConnection(pika.ConnectionParameters(rmq_host, rmq_port, credentials=credentials))

logging.info("Create channel")
channel = connection.channel()

logging.info("Declare queue '{0}'".format(rmq_queue))
channel.queue_declare(queue=rmq_queue)

logging.info("Defining consumer callback")
def consume_callback(ch, method, properties, body):
    logging.info("Received msg '{0}'".format(body))
    sleep(rmq_sleep)

channel.basic_consume(consume_callback,
                      queue=rmq_queue,
                      no_ack=True)

logging.info("Consuming")
channel.start_consuming()
