# MixApp

This example application consists of tiers 
of different platforms that are packaged in Docker containers. 

_In this document_:

* [Project Structure](#project-structure)
* [Prerequisites](#prerequisites)
* [Set Up](#set-up)
* [Build the Docker Images and Agents](#build the docker images and agents)
* [Run MixApp](#run-mixapp)
* [Start the Machine Agent](#start-the-machine-agent)
* [Get Logs From Containers](#get-logs-from-containers)
* [Tagging](#tagging)
* [Test the End-User Experience](#test-the-end-user-experience)

## Project Structure

This project is composed of the following eight containers:

- Java-App
- Node-App
- PHP-App
- Python-App
- Cpp-App
- LoadGenerator
- WebServer
- Angular-App

## Prerequisites

You need to install the following:

* [Docker ~1.10](https://docs.docker.com/engine/installation/)
* [Docker-Compose](https://docs.docker.com/compose/install/)

## Set Up

1. Download the following agents:

    - [Java App Server Agent](https://aperture.appdynamics.com/download/prox/download-file/ibm-jvm/4.2.1.8/AppServerAgent-ibm-4.2.1.8.zip) (`AppServerAgent-ibm-<ver>.zip`)
    - [Machine Agent - 64-bit Linux](https://aperture.appdynamics.com/download/prox/download-file/machine/4.2.1.8/MachineAgent-4.2.1.8.zip) (`MachineAgent-<ver>.zip`)
    - [PHP Agent - 64-bit RPM](https://aperture.appdynamics.com/download/prox/download-file/php-tar/4.2.1.8/appdynamics-php-agent-x64-linux-4.2.1.8.tar.bz2) (`appdynamics-php-agent-x64-linux--<ver>.tar.bz`)
    - [Apache WebServer Agent](https://aperture.appdynamics.com/download/prox/download-file/webserver-sdk/4.2.1.8/appdynamics-sdk-native-nativeWebServer-64bit-linux-4.2.1.8.tar.gz) (`appdynamics-sdk-native-nativeWebServer-64bit-linux-<ver>.tar.gz`)
    - [Apache Tomcat JAR](http://www-eu.apache.org/dist/tomcat/tomcat-7/v7.0.69/bin/apache-tomcat-7.0.69.tar.gz) (`apache-tomcat-<ver>.tar.gz`)
    - [C++ Native SDK](https://aperture.appdynamics.com/download/prox/download-file/native-sdk/4.2.1.8/appdynamics-sdk-native-64bit-linux-4.2.1.8.tar.gz) (`appdynamics-sdk-native-64bit-linux-<ver>.tar.gz`)
    - [EUM Java Script for Angular App](https://docs.appdynamics.com/display/PRO42/Manual+Injection#ManualInjection-DownloadandIncludetheAgent) (`adrum.js`)

    <br/>
    > **NOTE:** You'll need to sign up for the [Lite/Pro plans](https://www.appdynamics.com/upgrade-lite-to-pro/)
    >  to download the agents.

2. Copy the agents and Apache Tomcat to the `Agents` directory.
3. From your controller's **Licenses** page (http://&lt;controller_host&gt;/controller/#/location=SETTINGS_LICENSE), go to the 
**End User Monitoring** panel and copy your license key (you'll have to click **Show**).

## Build the Docker Images and Agents

1. Provide values for the variables listed below in `env.sh`:

    * `CONTROLLER` - assign the URL to the controller. 
    * `APPD_PORT` - the port that AppDynamics will listen to. Use the default `8090`.
    * `ACCOUNT_NAME` - Provide the account name. The default is `customer1`.
    * `SSL` - Turn off SSL: `off`
    * `GLOBAL_ACCOUNT_NAME` - Provide the global account name given in your controller.
    * `ACCESS_KEY` - The access key provisioned for you. For example: `5e41285e-23ed-407e-bf77-aa05f53f89a8`
    * `APP_NAME` - The application name. The default is `MixApp`, but we recommend appending a username to help identify your application, such as `AppName-janedoe`.

1. There are two ways to build the containers:
    
    * Simply run and follow instructions:
    ```
    ./build.sh 
    ```
    You will be prompt with command line instruction to provide agents directory or enter each agent one by one.s
    * Run with agents directory:
    ```
    ./build.sh -d <absolute-path-to-agent-directory>


## Run MixApp

To run MixApp:

```bash
docker-compose up -d
```

> **NOTE:** The `-d` option causes the containers to run in the background.

Please wait for five minutes for all containers to start and BTs to flow.

## Start The Machine Agent

To start the Machine Agent:

```
./startMachineAgent.sh
```

## Get Logs From Containers

To get App Agent logs, run:

```bash
./pull_appagent_logs.sh
```
The directory `appagent_logs` containing six zipped logs from Java, Python, PHP, Node.js, C++, and Webserver
will be created.

To get Machine Agent logs, run:

```
./pull_machine_agent_logs.sh
```

The directory `machine_agent_logs` containing six zipped Machine Agent logs will be created.

## Tagging

Use `./tagAll.sh` to tag versions of local images, such as 4.2, 4.3, and
`./untagAll.sh` to untag versions.

## Test the End-User Experience

In this section, you'll be using an Angular application to test connections
and make requests to the application containers. The Browser RUM in
your controllers will display the sessions.

1. Navigate to your controller and open your `MixApp` application.
1. From the **Application Dashboard**, go to **Configuration > Instrumentation > End User Monitoring**.
1. From the **End User Monitoring** tab, check the checkbox for **Enable End User Monitoring**.
1. Click **Save**.
1. Navigate to your Angular app at http://&lt;local_docker_host&gt;:3008
1. Click the buttons to test connections and make requests to the different application containers. 
1. From you controller, click **User Experience**.
1. Find and double-click your `MixApp`.  
1. In a few minutes, you should see the requests you made displayed as metrics in the dashboard.

> **NOTE:**
> 1. Right after the build, the Node.js container may not be reporting correctly. Stop and restart the Node.js container will fix it.
> 2. If the C++ container starts before Python and Node.js, the other two containers won't report correctly. 
