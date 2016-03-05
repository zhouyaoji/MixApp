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

Download 3 agents and name them as below, put them in home folder.
- PHP Agent -> PHPAgent.zip
- Java (AppServer) Agent -> JavaAgent.zip
- Machine Agent -> MachineAgent.zip

Modify env.sh for environment variable.

```
./build.sh
```

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
