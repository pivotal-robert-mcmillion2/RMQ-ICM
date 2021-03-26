#!/bin/bash

RABBITMQ_VERSION=3.8.8-1
RABBITMQ_USERNAME=admin
RABBITMQ_PASSWORD=changeme
RABBITMQ_ERLANG_COOKIE=bugsbunny

# Copy hosts file so we can resolve all nodes by name
echo "Updating hosts file"
cp /vagrant/hosts /etc/hosts

dpkg -r isc-dhcp-common isc-dhcp-client ubuntu-minimal
killall dhclient

HOSTNAME=`hostname`

case "$HOSTNAME" in
    rabbitmq1|rabbitmq2|rabbitmq3)
        # Install Erlang repo
        echo "Adding Erlang repo"
        wget -O ~/erlang-solutions_1.0_all.deb https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
        dpkg -i ~/erlang-solutions_1.0_all.deb
	sudo cp /vagrant/erlang /etc/apt/preferences.d/erlang
	apt-get update

        # Install PackageCloud RabbitMQ repo
        echo "Adding RabbitMQ repo"
        curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.deb.sh | bash

        # Install specific RabbitMQ version
        echo "Installing RabbitMQ"
        apt-get --yes install rabbitmq-server=$RABBITMQ_VERSION

        echo "Setting Erlang Cookie"
        echo $RABBITMQ_ERLANG_COOKIE > /var/lib/rabbitmq/.erlang.cookie

        cp /vagrant/rabbitmq.conf /etc/rabbitmq/rabbitmq.conf
        cp /vagrant/rabbitmq-collect-env /tmp/
        chmod +x /tmp/rabbitmq-collect-env

        service rabbitmq-server stop
        service rabbitmq-server start

        # Enable mgmt plugin
        echo "Enabling rabbitmq_management plugin"
        rabbitmq-plugins enable rabbitmq_prometheus rabbitmq_management rabbitmq_federation rabbitmq_federation_management rabbitmq_stomp rabbitmq_shovel rabbitmq_shovel_management rabbitmq_mqtt rabbitmq_tracing

        # Create a new user with admin rights
        echo "Adding user \"$RABBITMQ_USERNAME\""
        rabbitmqctl add_user $RABBITMQ_USERNAME $RABBITMQ_PASSWORD
        rabbitmqctl set_permissions -p / $RABBITMQ_USERNAME ".*" ".*" ".*"
        rabbitmqctl set_user_tags $RABBITMQ_USERNAME administrator

        ;;
esac;

case "$HOSTNAME" in
    rabbitmq2|rabbitmq3)
        echo "Stopping RabbitMQ and joining cluster"
        rabbitmqctl stop_app
        rabbitmqctl join_cluster rabbit@rabbitmq1
        rabbitmqctl start_app

        ;;
esac;

case "$HOSTNAME" in rabbitmq3)
    echo "Showing Cluster Status"
    rabbitmqctl cluster_status
    ;;
esac;
