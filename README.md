#MixApp

Mixed language applications packaged in Docker containers.

## Project Structure
This project is composed by 5 containers.
- Java-App
- Node-App
- PHP-App
- Python-App
- LoadGenerator

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

## Run

To run MixApp:
```
docker-compose up -d
```
-d tag lets the containers run in background.

## Start Machine agent
```
./startMachineAgent.sh
```
