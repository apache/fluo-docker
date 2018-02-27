# Apache Fluo Docker Image

**This is currently a work in progress**. Eventually, this will project will create a `apache/fluo` image at DockerHub. Until then, you will need to build your own image.

This project creates the official [Apache Fluo][Fluo] docker image.

## Getting Started

* [Documentation][docs] for running a Fluo application in Docker

## Obtain the Docker image

To obtain the docker image created by this project, you can either pull it from DockerHub at
`apache/fluo` or build it yourself. To pull the image from DockerHub, run the command below:

    docker pull apache/fluo

While it is easier to pull from DockerHub, the image will default to the software versions below:

| Software    | Version |
|-------------|---------|
| [Fluo]      | 1.2.0   |
| [Accumulo]  | 1.8.1   |
| [Hadoop]    | 2.7.5   |
| [Zookeeper] | 3.4.11  |

If these versions do not match what is running on your cluster, you should consider building
your own image with matching versions. However, Fluo must be 1.2+.

<!-- This section name should be stable as it's linked to from the web docs -->
## Build the Docker image

Below are instructions for building an image:

1. Clone the Fluo docker repo

        git clone git@github.com:apache/fluo-docker.git

2. Build the default Fluo docker image using the command below.

        cd /path/to/fluo-docker
        docker build -t fluo .

   Or build the Fluo docker image with specific versions of Hadoop, Zookeeper, etc using the command below:

        docker build \
        --build-arg ZOOKEEPER_VERSION=3.4.11 \
        --build-arg ZOOKEEPER_HASH=9268b4aed71dccad3d7da5bfa5573b66d2c9b565 \
        --build-arg ACCUMULO_VERSION=1.8.1 \
        --build-arg ACCUMULO_HASH=8e6b4f5d9bd0c41ca9a206e876553d8b39923528 \
        --build-arg HADOOP_VERSION=2.7.5 \
        --build-arg HADOOP_HASH=0f90ef671530c2aa42cde6da111e8e47e9cd659e \
        --build-arg FLUO_VERSION=1.2.0 \
        --build-arg FLUO_HASH=a89cb7f76007e8fdd0860a4d5c4e1743d1a30459 \
        -t fluo .

   Don't forget to update the HASH of the chosen version. We use SHA1 to validate the hash.

## Next steps

Read the [documentation][docs] for instructions on how run Fluo using docker.

[Fluo]: https://fluo.apache.org/
[Accumulo]: https://accumulo.apache.org/
[Hadoop]: https://hadoop.apache.org/
[Zookeeper]: https://zookeeper.apache.org/
[docs]: https://fluo.apache.org/docs/fluo/1.2/administration/run-fluo-in-docker
