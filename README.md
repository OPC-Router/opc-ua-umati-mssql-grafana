# OPC Router Docker Sample
> OPC Router Docker Sample for a Umati MSSQL communication with Grafana Dashboard.

## Contents
* [General Info](#general-information)
* [Components](#components)
* [Requirements](#requirements)
* [Usage](#usage)
* [Contact](#contact)

## General Information
- This docker sample is a fully functional OPC Router 4 project sample.
- The goal is to use an Umati OPC UA server, with the help of the OPC Router 4, to store data in an MSSQL database and visualize it through Grafana.

![First Startup](./img/Umati-DataDockerSample.png)

## Components
- [OPC Router](https://opc-router.com/?utm_source=GitHub&utm_medium=DockerSample&utm_campaign=OpcUaUmatiMssqlGrafana#test-now)
- [Docker](https://www.docker.com/)
- [Umati OPC UA Server](https://umati.org/)
- [Grafana](https://grafana.com/)

## Requirements
A system with Docker and OPC Router Management installed is a prerequisite for the project. This same system is required to have internet access.
If you don't have Docker installed yet, you can download it [here](https://www.docker.com/get-started). The OPC Router Management can be found on our [website](https://opc-router.com/?utm_source=GitHub&utm_medium=DockerSample&utm_campaign=OpcUaUmatiMssqlGrafana#test-now).

After the OPC Router Management and Docker are installed open up a commandline and enter the following:

**Windows**:
```powershell
$(Invoke-WebRequest https://raw.githubusercontent.com/OPC-Router/opc-ua-umati-mssql-grafana/main/setup.ps1 -Headers @{'Authorization' = 'token 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'} -UseBasicParsing).Content | powershell
```

**Linux**:
````bash
curl -sSLf https://raw.githubusercontent.com/OPC-Router/opc-ua-umati-mssql-grafana/main/setup.sh -H 'Authorization: token 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' | bash -
````

This process may take up to a couple of minutes.

Now all nessecery components are ready to use.

## Usage
Now you can navigate to [http://localhost:3000/](http://localhost:3000/d/v972rfT7k/sample-dashboard) in your browser and take a look onto the Grafana Dashboard which visualizes the written data. The data was gathered by the OPC Router 4 from the Umati OPC UA Server and written to the MSSQL database.
If you like to inspect the communication of the OPC Router 4 instance you may launch the OPC Router Management.

After the start of the Management it is required to configure a connection to the docker container. 

![First Startup](./img/OPCRouterConfigureService.png)

To do this you have to click on the plus symbol at plug-ins in the OPC Router Management (see picture) and select "Integrade existing service...".

![First Startup](./img/OPCRouterConfigIntegrateExistingService.png)

Enter your docker hosts IP address and Port 27020, click "Test connection" and confirm with OK.

![First Startup](./img/AddDocker.png)

To observe the current and historical state select this pane and for example select the connection transferring the visualized data.

![First Startup](./img/UmatiDockerSampleOPCRouter.png)

## Contact
Created by [@inray](https://opc-router.com/?utm_source=GitHub&utm_medium=DockerSample&utm_campaign=OpcUaUmatiMssqlGrafana#test-now) - feel free to contact us!
