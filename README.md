#MixApp

Mixed language applications packaged in Docker containers. 

## Project Structure
This project is composed by 7 containers.
- Java-App
- Node-App
- PHP-App
- Python-App
- Cpp-App
- LoadGenerator
- WebServer

## Build

Modify env.sh for environment variable.

```
./build.sh
```
Provide path to below agents according to prompt:
- Java App Server Agent (.zip)
- Machine Agent (.zip)
- PHP Agent (.zip)
- Apache WebServer Agent (.tar.gz)
- Tomcat Jar (.tar.gz)
- C++ Native SDK (tar.gz)

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

## Note:
1. Right after build, Node.js container may not be reporting correctly. Stop and restart Node.js container will fix it.
2. If C++ container starts before Python and Nodejs, the other two containers won't report correctly. 