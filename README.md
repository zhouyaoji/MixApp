#MixApp

Mixed language applications packaged in Docker containers. 

## Project Structure
This project is composed by 8 containers.
- Java-App
- Node-App
- PHP-App
- Python-App
- Cpp-App
- LoadGenerator
- WebServer
- Angular-App

## Build

1. Build base images:
```
./Base-Image/build.sh
```

2. Modify env.sh for environment variable, then run:

```
./build.sh
```
Provide path to below agents according to prompt:
- Java App Server Agent (AppServerAgent-<ver>.zip)
- Machine Agent (64bit-linux-<ver>.zip)
- PHP Agent (x64-linux-<ver>.tar.bz)
- Apache WebServer Agent (nativeWebServer-64bit-linux-<ver>.tar.gz)
- Tomcat Jar (.tar.gz)
- C++ Native SDK (nativeSDK-64bit-linux-<ver>.tar.gz)
- EUM Java Script for Angular App (adrum.js) #You can download it from Getting Started or copy from controller User Experience tab
- [OPTIONAL] Node.js Agent # Default is appdynamics@next, you can pass in Node.js agent for testing

## Run

To run MixApp:
```
docker-compose up -d
```
-d tag lets the containers run in background.

** Please wait for 5 mins for all containers to start and BTs to flow. **

## Start Machine agent
```
./startMachineAgent.sh
```
## Get logs from containers

To get App Agent logs, run:
```
./pull_appagent_logs.sh
```
You'll get a folder "appagent_logs" that contains 6 zipped logs from Java, Python, PHP, Node.js, C++, and Webserver.

To get Machine Agent logs, run:
```
./pull_machine_agent_logs.sh
```
You'll get a folder "machine_agent_logs" that contains 6 zipped Machine Agent logs accordingly.

## Tagging

Use ./tagAll.sh to tag versions of local images, such as 4.2, 4.3.

Use ./untagAll.sh to untag versions.

## Angular App to test End User Experience

To update RUM key and EUM Cloud, pass RUM Key value and EUM cloud url (EUM Extension URL is optional)
```
./update-rum-key.sh {RUM_KEY} {EUM_CLOUD_URL} {EXTENTION_URL}
```
Go to your local_docker_host:3008 and click the buttons to test connections with different application containers. You'll see sessions and load show up in Browser RUM in your controller.
## Note:
1. Right after build, Node.js container may not be reporting correctly. Stop and restart Node.js container will fix it.
2. If C++ container starts before Python and Nodejs, the other two containers won't report correctly. 