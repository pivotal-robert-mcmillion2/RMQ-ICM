#!/bin/bash

RABBITMQ_VERSION=3.7.7-1
RABBITMQ_USERNAME=admin
RABBITMQ_PASSWORD=changeme
RABBITMQ_ERLANG_COOKIE=bugsbunny

# Copy hosts file so we can resolve all nodes by name
echo "Updating hosts file"
cp /vagrant/hosts /etc/hosts

dpkg -r isc-dhcp-client ubuntu-minimal

HOSTNAME=`hostname`

case "$HOSTNAME" in
    rabbitmq1|rabbitmq2|rabbitmq3)
        # Install Erlang repo
        echo "Adding Erlang repo"
        wget -O ~/erlang-solutions_1.0_all.deb https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
        dpkg -i ~/erlang-solutions_1.0_all.deb

        # Install PackageCloud RabbitMQ repo
        echo "Adding RabbitMQ repo"
        curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.deb.sh | bash

        # Install specific RabbitMQ version
        echo "Installing RabbitMQ"
        apt-get --yes install rabbitmq-server=$RABBITMQ_VERSION

        echo "Setting Erlang Cookie"
        echo $RABBITMQ_ERLANG_COOKIE > /var/lib/rabbitmq/.erlang.cookie

        cp /vagrant/rabbitmq.conf /etc/rabbitmq/rabbitmq.conf

        service rabbitmq-server stop
        service rabbitmq-server start

        # Enable mgmt plugin
        echo "Enabling rabbitmq_management plugin"
        rabbitmq-plugins enable rabbitmq_management

        # Create a new user with admin rights
        echo "Adding user \"$RABBITMQ_USERNAME\""
        rabbitmqctl add_user $RABBITMQ_USERNAME $RABBITMQ_PASSWORD
        rabbitmqctl set_permissions -p / $RABBITMQ_USERNAME ".*" ".*" ".*"
        rabbitmqctl set_user_tags $RABBITMQ_USERNAME administrator

        echo "Showing RabbitMQ status"
        rabbitmqctl status
        ;;
esac;

case "$HOSTNAME" in
    rabbitmq2|rabbitmq3)
        echo "Stopping RabbitMQ and joining cluster"
        rabbitmqctl stop_app
        rabbitmqctl join_cluster rabbit@rabbitmq1
        rabbitmqctl start_app

        # Run a cluster status to verify node joined
        echo "Showing RabbitMQ cluster status"
        rabbitmqctl cluster_status
        ;;
esac;

case "$HOSTNAME" in
    client1|client2)
        echo "Update Apt"
        apt-get update

        echo "Installing Apt packages"
        apt-get --yes install python-pip

        echo "Installing Python packages"
        pip install pika
        ;;
esac;
