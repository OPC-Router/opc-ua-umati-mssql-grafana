<div align="center">
  <a href="https://github.com/othneildrew/Best-README-Template">
    <img src="img/opc_router_logo.png" alt="Logo" >
  </a>
    <br />
    <br />
  <h1 align="center">OPC Router Docker Sample</h1>
  <p align="center">
    OPC Router Docker Sample for a Umati MSSQL communication with Grafana Dashboard.
    <br />
    <a href="https://github.com/OPC-Router/opc-ua-umati-mssql-grafana/blob/main/README.md"><strong>Explore the docs »</strong></a>
    <br />
    <br />
  </p>
</div>

# About the Sample
## Contents
* [General Info](#general-information)
* [Components](#components)
* [Getting Started](#Getting-Started)
  * [Prerequisites](#Prerequisites)
  * [Installation](#Installation)
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
- [MSSQL](https://www.microsoft.com/de-de/sql-server/)

# Getting Started

## **Prerequisites**
For both operating systems, there are prerequisites that must already be met:
- Connection to the Internet
- Browser (If you are using **Firefox** then use a Version greater than **95.0.1**)
- [OPC Router Managment](https://opc-router.com/?utm_source=GitHub&utm_medium=DockerSample&utm_campaign=OpcUaUmatiMssqlGrafana#test-now)

### **Windows**
A system with Docker and OPC Router Management installed is a prerequisite for the project. This same system is required to have internet access.
If you don't have Docker installed yet, you can download it [here](https://www.docker.com/get-started). The OPC Router Management can be found on our [website](https://opc-router.com/?utm_source=GitHub&utm_medium=DockerSample&utm_campaign=OpcUaUmatiMssqlGrafana#test-now).
- Docker

### **Linux**
**✔️When installing on a Linux-based machine, all required applications can be installed automatically, this is done during setup.**

 >🚩If you **do not** want Docker to be installed automatically you have to do this **manually**.


## **Installation**
After the OPC Router Management and Docker are installed open up a commandline and enter the following:
**This process may take up to a couple of minutes.**
### Windows
```powershell
$(Invoke-WebRequest https://docker.opc-router.cloud/opc-ua-umati-mssql-grafana/win -UseBasicParsing).Content | iex
```
### Linux
````bash
bash <(curl -sSLf https://docker.opc-router.cloud/opc-ua-umati-mssql-grafana/linux)
````

# Usage
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
