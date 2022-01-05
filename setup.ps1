$GIT_TOKEN="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"
$TARGET_DIR="OPCRouter_Umati_MSSQL_Grafana"


$HostIP = (
    Get-NetIPConfiguration |
    Where-Object {
        $_.IPv4DefaultGateway -ne $null -and
        $_.NetAdapter.Status -ne "Disconnected"
    }
).IPv4Address.IPAddress

function install_docker {
$confirmation = Read-Host "docker is missing and required for using the sample. Install docker now? (y/n)"
while($confirmation -ne "y"){
        if ($confirmation -eq 'n') {exit}
		$confirmation = Read-Host "docker is missing and required for using the sample. Install docker now? (y/n)"
    }
$DockerInstaller = Join-Path $Env:Temp InstallDocker.msi
				Invoke-WebRequest https://download.docker.com/win/stable/InstallDocker.msi -OutFile $DockerInstaller
                msiexec -i $DockerInstaller -quiet
                return 
}

echo ""
echo "Welcome to the OPC Router 4 docker sample with Umati OPC UA, MSSQL and Grafana!"
echo ""
install_docker

Try {
	$test = docker --version
	if($?)
	{
		echo "docker already installed"
	}
}
Catch 
{
	install_docker
}
$GITHUB_ADRESS = "https://github.com/OPC-Router/opc-ua-umati-mssql-grafana/archive/refs/heads/main.zip"
Invoke-WebRequest -Uri $GITHUB_ADRESS -OutFile "OPCRouter_Umati_MSSQL_Grafana.zip" -Headers @{'Authorization' = 'Basic dG9rZW46Z2hwX3hHbWJkc0pKS3FWRnhLaUVncWVLSWg5Mk4zQ0E3SDBVUmoyNg=='}
Expand-Archive -Path "OPCRouter_Umati_MSSQL_Grafana.zip" -DestinationPath $TARGET_DIR -Force
Remove-Item -Path "OPCRouter_Umati_MSSQL_Grafana.zip" -Force
cd $TARGET_DIR
sleep 10
docker-compose up -d

$HostAdress = "http://" + $HostIP + ":3000/d/v972rfT7k/umati-machine-data";
sleep 10
Write-Host "Sample was installed successfully! Open" $HostAdress "in a browser!"
Start-Process $HostAdress