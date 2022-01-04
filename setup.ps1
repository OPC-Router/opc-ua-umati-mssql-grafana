GIT_TOKEN="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"
TARGET_DIR="OPCRouter_Umati_MSSQL_Grafana"

$DockerInstaller = Join-Path $Env:Temp InstallDocker.msi
Invoke-WebRequest https://download.docker.com/win/stable/InstallDocker.msi -OutFile $DockerInstaller


$env:HostIP = (
    Get-NetIPConfiguration |
    Where-Object {
        $_.IPv4DefaultGateway -ne $null -and
        $_.NetAdapter.Status -ne "Disconnected"
    }
).IPv4Address.IPAddress

function install_docker {
echo "docker is missing and required for using the sample. Install docker now? (Y/N)"
while(-1){
        switch (Read-Host '(Y/N)'){
            Y { 
                msiexec -i $DockerInstaller -quiet
                return 
              }
            N { exit }
            default { Write-Host 'Only Y/N valid' -fore red }
        }
    }
}

echo ""
echo "Welcome to the OPC Router 4 docker sample with Umati OPC UA, MSSQL and Grafana! You might need to enter your password a couple of times."
echo ""

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

git clone https://$GIT_TOKEN@github.com/OPC-Router/opc-ua-umati-mssql-grafana $TARGET_DIR
cd $TARGET_DIR
sleep 1s
docker-compose up -d

echo "Sample was installed successfully! Open http://$HostIP:3000 in a browser!"
Start-Process "http://$HostIP:3000"