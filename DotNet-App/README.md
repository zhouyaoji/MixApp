Currently we don't have the docker support for the DotNet module. Hence please follow the below instructions if you would like to include DotNet module to your MixApp.

Pre-requisites:
Before start on the steps make sure you have,
1. A windows box - which should be reachable from the machine where you are running the MixApp containers
2. The required version of dotnet agent installed in the windows box. Please refer the doc https://docs.appdynamics.com/display/PRO42/Install+the+.NET+Agent for installing the dotnet agent.

Steps:
In Windows Machine
1. Copy the folder 'SampleWeb' to the box.
2. Host a website out of it in IIS
3. Configure the dotnet agent to add this website to the MixApp application. Please refer the doc https://docs.appdynamics.com/display/PRO42/Configure+the+.NET+Agent for configuring the dotnet agent.

In Host machine(where MixApp containers are running)
1. Update the env.sh with the appropriate values for the variables.
2. Source the env.sh file
3. Run the script enableDotNet.sh

