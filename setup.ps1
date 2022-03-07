$GITHUB_REPO="opc-ua-umati-mssql-grafana"

## Don't change this
$TARGET_DIR="OPCRouter_" + $GITHUB_REPO -replace '-','_'
$GITHUB_ZIP_ADRESS = "https://api.github.com/repos/OPC-Router/" + $GITHUB_REPO + "/zipball"
$GITHUB_DIR = $GITHUB_REPO + "-main"
$WindowsVersion=(Get-ComputerInfo).OsProductType

$HostIP = (
    Get-NetIPConfiguration |
    Where-Object {
        $_.IPv4DefaultGateway -ne $null -and
        $_.NetAdapter.Status -ne "Disconnected"
    }
).IPv4Address.IPAddress

function Get-UrlStatusCode([string] $Url)
{
    try
    {
        (Invoke-WebRequest -Uri $Url -UseBasicParsing -DisableKeepAlive).StatusCode
    }
    catch [Net.WebException]
    {
        [int]$_.Exception.Response.StatusCode
    }
}

Write-Host ""
Write-Host "Welcome to the OPC Router 4 docker sample with Umati OPC UA, MSSQL and Grafana!"
Write-Host ""

Try {
	$test = docker --version
	if($?)
	{
		Write-Host "docker already installed"
	}
}
Catch 
{
	Write-Host "Docker is missing and required for using the sample. Please install Docker using the following instructions:"
	switch ($WindowsVersion) 
	{
		WorkStation 
		{
			Write-Host ""
			Write-Host "Docker Installation Windows 10/11 Guide: https://docs.docker.com/desktop/windows/install/"
			Write-Host ""
			Write-Host "When you are done installing Docker you can repeat the process."
			sleep 10
			Start-Process "https://docs.docker.com/desktop/windows/install/"
			return
		}
		Server 
		{
			Write-Host ""
			Write-Host "Docker Installation Windows Server Guide: https://docs.microsoft.com/de-de/virtualization/windowscontainers/quick-start/set-up-environment?tabs=Windows-Server"
			Write-Host ""
			Write-Host "When you are done installing Docker you can repeat the process."
			sleep 10
			Start-Process "https://docs.microsoft.com/de-de/virtualization/windowscontainers/quick-start/set-up-environment?tabs=Windows-Server"
			return
		}
	}
}
$DockerRunning = "False"
while ($DockerRunning -ne "True") 
{
	docker info | Out-Null
	$DockerRunning = $?
	if ($DockerRunning -ne "True") 
	{
		Write-Host "Please start Docker Runtime and press enter"
		Read-Host
	}
}

$GITHUB_FILENAME = $TARGET_DIR + ".zip"
Invoke-WebRequest -Uri $GITHUB_ZIP_ADRESS -OutFile $GITHUB_FILENAME
Expand-Archive -Path $GITHUB_FILENAME -DestinationPath $TARGET_DIR -Force
Remove-Item -Path $GITHUB_FILENAME -Force
cd $TARGET_DIR
$TEMP_DIR=(Get-ChildItem -Path . | Select-Object -First 1).Name
Get-ChildItem -Path $TEMP_DIR -Directory | Move-Item -Destination .
Get-ChildItem -Path $TEMP_DIR -File | Move-Item -Destination .
Remove-Item -Path $TEMP_DIR -Force
sleep 10
docker-compose up -d

$HostAdress = "http://" + $HostIP + ":3000/d/v972rfT7k/umati-machine-data";
Write-Host "Waiting for final steps to complete"
$GRAFANA_REACHABLE=999
while ($GRAFANA_REACHABLE -ne 200) 
{
	$GRAFANA_REACHABLE = Get-UrlStatusCode "http://localhost:3000"
	sleep 3
}
Write-Host "Sample was installed successfully! Open" $HostAdress "in a browser!"
Write-Host "Once you finished observing the sample, you may stop it by running 'docker-compose down'"

Start-Process $HostAdress
