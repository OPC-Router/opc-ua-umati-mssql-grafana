<div align="center">
  <a href="https://opc-router.com/?utm_source=GitHub&utm_medium=DockerSample&utm_campaign=OpcUaUmatiMssqlGrafana">
    <img src="img/opc_router_logo.png" alt="Logo" >
  </a>
    <br />
    <br />
  <h1 align="center">OPC Router Docker Sample</h1>
  <p align="center">
    OPC Router Docker Sample for a Umati MSSQL communication with Grafana Dashboard.
    <br />
    <a href="https://opc-router.com/?utm_source=GitHub&utm_medium=DockerSample&utm_campaign=OpcUaUmatiMssqlGrafana"><strong>OPC Router</strong></a>
    -
    <a href="https://github.com/OPC-Router/opc-ua-umati-mssql-grafana/blob/main/README.md"><strong>Contact</strong></a>
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
    - [Windows](#Windows)
    - [Linux](#Linux)
* [Usage](#usage)
    - [Grafana](#Grafana)
    - [Opc Router Managment](#Opc-Router-Managament)
* [Contact](#contact)

## General Information
//Nochmal auf den OPC Router eingehen (Runtime..)
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
- [OPC Router Managment](https://opc-router.com/?utm_source=GitHub&utm_medium=DockerSample&utm_campaign=OpcUaUmatiMssqlGrafana#test-now) (🚩 The installation is only possible on Windows systems)

### **Windows**
A system with Docker and OPC Router Management installed is a prerequisite for the project. This same system is required to have internet access.
If you don't have Docker installed yet, you can download it [here](https://www.docker.com/get-started). The OPC Router Management can be found on our [website](https://opc-router.com/?utm_source=GitHub&utm_medium=DockerSample&utm_campaign=OpcUaUmatiMssqlGrafana#test-now).
- Docker


### **Linux**


 ### **automatic Installation:**
💡 When installing on a Linux-based machine, all required applications can be installed automatically, this is done during setup.  

### **manually Installation:**
 ⚠️ If you do not want the applications to be installed automatically, you must do this manually:
  - Docker
  - Docker-compose


## **Installation**
Now open the command line after you have installed the required software for your operating system:  
**❕This process may take up to a couple of minutes❕**
### **Windows**
```powershell
$(Invoke-WebRequest https://docker.opc-router.cloud/opc-ua-umati-mssql-grafana/win -UseBasicParsing).Content | iex
```
### **Linux**
````bash
bash <(curl -sSLf https://docker.opc-router.cloud/opc-ua-umati-mssql-grafana/linux)
````  

## **Ready to Use**
You should now have installed everything successfully and you can now explore the possibilities of the OPC Router.  
If something unexpectedly fails here, feel free to [contact](https://www.opc-router.com/contact-and-support/?utm_source=GitHub&utm_medium=DockerSample&utm_campaign=OpcUaUmatiMssqlGrafana) us

# Usage

## **Grafana**
Grafana is started directly with the installation and can now be viewed directly. 

Now you only have to call the address [http://localhost:3000/](http://localhost:3000/d/v972rfT7k/sample-dashboard) to the interface with your browser and see the visualized data directly.

> ❗ Make sure that you can only call the localhost address if you are on the device that is also used for the Docker installation, otherwise you have to call the address of the device on which the Docker installation is located.


## **OPC Router Managment**
If you want to view the communication between the Umati OPC UA server and the OPC Router Runtime which serves as middleware that forwards the data to the MSSQL database, start the OPC router management now.

### 1. **Add Runtime to the OPC Router Management**
To be able to observe the data transfers you have to connect to the OPC Router Runtime first.  
 Click on the plus symbol at plug-ins in the OPC Router Management (see picture)...
![First Startup](./img/OPCRouterConfigureService.png)
...and select **Integrate existing service...**
![First Startup](./img/OPCRouterConfigIntegrateExistingService.png)

### 2. **Configure Connection**
-   Name: (You can write here what you want)
-   Username & Password **(Let it Empty)**
-   Server IP: 127.0.0.1
    > ❗ Make sure that you can only call the localhost / 127.0.0.1 address if you are on the device that is also used for the Docker installation, otherwise you have to call the address of the device on which the Docker installation is located.
-   Port: 27020

Enter your docker hosts IP address and Port 27020, click **Test connection** and confirm with **OK**.

![First Startup](./img/AddDocker.png)

### 3. Open the status page
To observe the current and historical transfers select this pane and for example select the connection transferring the visualized data.

![First Startup](./img/UmatiDockerSampleOPCRouter.png)

## Contact
Created by [@inray](https://www.opc-router.com/contact-and-support/?utm_source=GitHub&utm_medium=DockerSample&utm_campaign=OpcUaUmatiMssqlGrafana) - feel free to contact us!
