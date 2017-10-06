# Apache Fluo Docker Image

**This is currently a work in progress that depends on unreleased features of Fluo and will not be ready for use until after Fluo 1.2.0 is released.**  Sometime after Fluo 1.2.0 is released this project will make its first release. Eventually, this will project will create a `apache/fluo` image at DockerHub. Until then, you will need to build your own image.

This project creates the official [Apache Fluo][Fluo] docker image.

## Getting Started

* [Documentation] for running a Fluo application in Docker

## Obtain the Docker image

To obtain the docker image created by this project, you can either pull it from DockerHub at
`apache/fluo` or build it yourself. To pull the image from DockerHub, run the command below:

    docker pull apache/fluo

While it is easier to pull from DockerHub, the image will default to the software versions below:

| Software    | Version |
|-------------|---------|
| [Fluo]      | 1.2.0   |
| [Accumulo]  | 1.8.1   |
| [Hadoop]    | 2.7.3   |
| [Zookeeper] | 3.4.9   |

If these versions do not match what is running on your cluster, you should consider building
your own image with matching versions. However, Fluo must be 1.2+.

<!-- This section name should be stable as it's linked to from the web docs -->
## Build the Docker image

Below are instructions for building an image:

1. Clone the Fluo docker repo

        git clone git@github.com:apache/fluo-docker.git

2. Until Fluo 1.2 is released, build a Fluo tarball distribution and copy it to the root
   directory of the repo.

        git clone git@github.com:apache/fluo.git
        cd fluo/
        mvn clean package
        cp modules/distribution/target/fluo-1.2.0-SNAPSHOT-bin.tar.gz /path/to/fluo-docker/

3. Build the default Fluo docker image using the command below.

        cd /path/to/fluo-docker
        docker build -t fluo .

   Or build the Fluo docker image with specific versions of Hadoop, Zookeeper, etc using the command below:

        docker build --build-arg ZOOKEEPER_VERSION=3.4.8 --build-arg ACCUMULO_VERSION=1.7.3 --build-arg HADOOP_VERSION=2.7.0 -t fluo .

## Next steps

Read the [Documentation] for instructions on how run Fluo using docker.

[Fluo]: https://fluo.apache.org/
[Accumulo]: https://accumulo.apache.org/
[Hadoop]: https://hadoop.apache.org/
[Zookeeper]: https://zookeeper.apache.org/
[Documentation]: https://fluo.apache.org/docs/fluo/1.2/administration/run-fluo-in-docker/
