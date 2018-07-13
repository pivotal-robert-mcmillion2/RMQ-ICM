# rabbitmq-icm
RabbitMQ - Install Configure Manage

Introduction
-

This `Vagrantfile` and `provision.sh` will create a 3 x node RabbitMQ cluster and 2 x client nodes where you can run producer and consumer scripts.

Eralng and RabbitMQ packages are automatically installed from here:
- https://packages.erlang-solutions.com
- https://packagecloud.io/rabbitmq/rabbitmq-server

Steps
-

1. Install Vagrant:
    - https://www.vagrantup.com/downloads.html
1. Install VirtualBox and VirtualBox Extension Pack
    - https://www.virtualbox.org/wiki/Downloads
1. Clone this repo:
    ```
    cd ~/workspace
    git clone https://github.com/stephendotcarter/rabbitmq-icm
    cd rabbitmq-icm
    ```
1. Verify VirtualBox networks:
    - Open VirtualBox.
    - Click `Global Tools`.
    - Verify the `vboxnet0` IP address is `192.168.56.1/24`.
        - If not then either:
            - Change `vboxnet0` to be `192.168.56.1/24`.
        - or:
            - Change VM IPs in `Vagrantfile` to match the same subnet as `vboxnet0`.
            - Change the `hosts` file to reflect the new VM IPs
1. Modify the variables in `provision.sh` as needed:
    ```
    // Should match exact version number from PackageCloud RabbitMQ repo
    RABBITMQ_VERSION=3.7.7-1

    // Username and password for admin user
    RABBITMQ_USERNAME=vcap
    RABBITMQ_PASSWORD=changeme

    // Erlang cookie to be used by the nodes
    RABBITMQ_ERLANG_COOKIE=bugsbunny
    ```
1. Create and configure the VMs: 
    ```
    vagrant up
    ```
1. Verify the VMs are running:
    ```
    vagrant status
    ```
1. Verify RabbitMQ cluster is running using `rabbitmqctl`:
    ```
    vagrant ssh rabbitmq1
    sudo rabbitmqctl cluster_status
1. Verify RabbitMQ cluster is running using the Management Plugin web interface:
    - http://192.168.56.11:15672
    - Log in using the username/password set in `provision.sh`
