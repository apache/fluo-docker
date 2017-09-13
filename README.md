# Apache Fluo Docker Image

This is currently a work in progress that depends on unreleased features of Fluo.  It will not be ready for use until after Fluo 1.2.0 is released.  Sometime after Fluo 1.2.0 is released this project will make its first release.

## Obtain the Docker image

To obtain the docker image created by this project, you can either pull it from DockerHub at
`mikewalch/fluo` or build it yourself. To pull the image from DockerHub, run the command below:

    sudo docker pull mikewalch/fluo

While it is easier to pull from DockerHub, the image will default to the software versions below:

| Software    | Version        |
|-------------|----------------|
| [Fluo]      | 1.2.0-SNAPSHOT |
| [Accumulo]  | 1.8.1          |
| [Hadoop]    | 2.7.3          |
| [Zookeeper] | 3.4.9          |

If these versions do not match what is running on your cluster, you should consider building
your own image with matching versions. However, Fluo must be 1.2+. Below are instructions for
building an image:

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

## Image basics

The entrypoint for the Fluo docker image is the `fluo` script. While the primary use
case for this image is to start an oracle or worker, you can run other commands in the
`fluo` script to test out the image:

```bash
# No arguments prints Fluo command usage
docker run mikewalch/fluo
# Print Fluo version
docker run mikewalch/fluo version
# Print Fluo classpath
docker run mikewalch/fluo classpath
```

# Run Fluo Applications using Docker

Before starting a Fluo oracle and worker using the Fluo Docker image, [initialize your Fluo application][application]. 
Next, choose a method below to run the oracle and worker(s) of your Fluo application. In the examples below, the Fluo
application is named `myapp` and was initialized using a Zookeeper node on `zkhost`.

## Docker engine

Use the `docker` command to start local docker containers.

1. Start a Fluo oracle

        docker run -d --network="host" mikewalch/fluo oracle -a myapp -o fluo.connection.zookeepers=zkhost/fluo

2. Start Fluo worker(s). Execute this command multiple times to start multiple workers.

        docker run -d --network="host" mikewalch/fluo worker -a myapp -o fluo.connection.zookeepers=zkhost/fluo

## Marathon

Using the [Marathon] UI, you can create applications using JSON configuration.

The JSON below can be used to start a Fluo oracle.

```json
{
  "id": "myapp-fluo-oracle",
  "cmd": "fluo oracle -a myapp -o fluo.connection.zookeepers=zkhost/fluo",
  "cpus": 1,
  "mem": 256,
  "disk": 0,
  "instances": 1,
  "container": {
    "docker": {
      "image": "mikewalch/fluo",
      "network": "HOST"
    },
    "type": "DOCKER"
  }
}
```

The JSON below can be used to start Fluo worker(s). Modify instances to start multiple workers.

```json
{
  "id": "myapp-fluo-worker",
  "cmd": "fluo worker -a myapp -o fluo.connection.zookeepers=zkhost/fluo",
  "cpus": 1,
  "mem": 512,
  "disk": 0,
  "instances": 1,
  "container": {
    "docker": {
      "image": "mikewalch/fluo",
      "network": "HOST"
    },
    "type": "DOCKER"
  }
}
```

[Fluo]: https://fluo.apache.org/
[Accumulo]: https://accumulo.apache.org/
[Hadoop]: https://hadoop.apache.org/
[Zookeeper]: https://zookeeper.apache.org/
[application]: https://github.com/apache/fluo/blob/master/docs/applications.md
[Marathon]: https://mesosphere.github.io/marathon/
