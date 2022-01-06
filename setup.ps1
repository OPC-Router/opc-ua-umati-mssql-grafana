$GIT_TOKEN="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"
$TARGET_DIR="OPCRouter_Umati_MSSQL_Grafana"
$DockerInstaller="Docker Desktop Installer.exe"
$WindowsVersion=(Get-ComputerInfo).OsProductType
$GITHUB_ADRESS = "https://github.com/OPC-Router/opc-ua-umati-mssql-grafana/archive/refs/heads/main.zip"
$GITHUB_FILENAME = "OPCRouter_Umati_MSSQL_Grafana.zip"
$GITHUB_DIR = "opc-ua-umati-mssql-grafana-main"

$HostIP = (
    Get-NetIPConfiguration |
    Where-Object {
        $_.IPv4DefaultGateway -ne $null -and
        $_.NetAdapter.Status -ne "Disconnected"
    }
).IPv4Address.IPAddress

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
			Write-Host "Docker Installation Windows 10/11 Guide: https://docs.docker.com/desktop/windows/install/"
			Write-Host "When you are done installing Docker you can repeat the process."
			sleep 10
			Start-Process "https://docs.docker.com/desktop/windows/install/"
			return
		}
		Server 
		{
			Write-Host "Docker Installation Windows Server Guide: https://docs.microsoft.com/de-de/virtualization/windowscontainers/quick-start/set-up-environment?tabs=Windows-Server"
			Write-Host "When you are done installing Docker you can repeat the process."
			sleep 10
			Start-Process "https://docs.microsoft.com/de-de/virtualization/windowscontainers/quick-start/set-up-environment?tabs=Windows-Server"
			return
		}
	}
}

Invoke-WebRequest -Uri $GITHUB_ADRESS -OutFile $GITHUB_FILENAME -Headers @{'Authorization' = 'Basic dG9rZW46Z2hwX3hHbWJkc0pKS3FWRnhLaUVncWVLSWg5Mk4zQ0E3SDBVUmoyNg=='}
Expand-Archive -Path $GITHUB_FILENAME -DestinationPath $TARGET_DIR -Force
Remove-Item -Path $GITHUB_FILENAME -Force
cd $TARGET_DIR
cd $GITHUB_DIR
sleep 10
docker-compose up -d

$HostAdress = "http://" + $HostIP + ":3000/d/v972rfT7k/umati-machine-data";
sleep 10
Write-Host "Sample was installed successfully! Open" $HostAdress "in a browser!"
Start-Process $HostAdress