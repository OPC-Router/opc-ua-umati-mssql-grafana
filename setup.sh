#!/usr/bin/env bash

# to run from local file system in Powershell use "Get-Content .\setup.sh -Raw | bash -"

# Increase this version number whenever you update the installer
INSTALLER_VERSION="2021-11-18" # format YYYY-MM-DD

# Test if this script is being run as root or not
if [[ $EUID -eq 0 ]];
then IS_ROOT=true;  SUDOX=""
else IS_ROOT=false; SUDOX="sudo "; fi
ROOT_GROUP="root"
USER_GROUP="$USER"

GIT_TOKEN="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"

TARGET_DIR="OPCRouter_Umati_MSSQL_Grafana"

get_platform_params() {
	# Test which platform this script is being run on
	# When adding another supported platform, also add detection for the install command
	# HOST_PLATFORM:  Name of the platform
	# INSTALL_CMD:      comand for package installation
	# INSTALL_CMD_ARGS: arguments for $INSTALL_CMD to install something
	# INSTALL_CMD_UPD_ARGS: arguments for $INSTALL_CMD to update something
	# DOCKER_INSTALL_COMMAND: command to download and run docker install script


	INSTALL_CMD_UPD_ARGS=""

	unamestr=$(uname)
	case "$unamestr" in
	"Linux")
		HOST_PLATFORM="linux"
		INSTALL_CMD="apt-get"
		INSTALL_CMD_ARGS="install -yq"
		if [[ $(which "yum" 2>/dev/null) == *"/yum" ]]; then
			INSTALL_CMD="yum"
			# The args -y and -q have to be separate
			INSTALL_CMD_ARGS="install -q -y"
			INSTALL_CMD_UPD_ARGS="-y"
		fi
		;;
	"Darwin")
		# OSX and Linux are the same in terms of install procedure
		HOST_PLATFORM="osx"
		ROOT_GROUP="wheel"
		INSTALL_CMD="brew"
		INSTALL_CMD_ARGS="install"
		;;
	"FreeBSD")
		HOST_PLATFORM="freebsd"
		ROOT_GROUP="wheel"
		INSTALL_CMD="pkg"
		INSTALL_CMD_ARGS="install -yq"
		;;
	*)
		# The following should never happen, but better be safe than sorry
		echo "Unsupported platform $unamestr"
		exit 1
		;;
	esac
	
	if [[ $(which "curl" 2>/dev/null) == *"/curl" ]]; then
		DOCKER_INSTALL_COMMAND="curl -fsSL https://get.docker.com | sh -"
	elif [[ $(which "wget" 2>/dev/null) == *"/wget" ]]; then
		DOCKER_INSTALL_COMMAND="wget -O - https://get.docker.com | sh -"
	fi
}

running_in_docker() {
	# Test if we're running inside a docker container or as github actions job while building docker container image
	if awk -F/ '$2 == "docker"' /proc/self/cgroup | read || awk -F/ '$2 == "actions_job"' /proc/self/cgroup | read ; then
		return 0
	else
		return 1
	fi
}

install_docker() {
	echo "docker is missing and required for using the sample. Install docker now?"
	select yn in "Yes" "No"; do
    case $yn in
        Yes ) $($DOCKER_INSTALL_COMMAND); break;;
        No ) exit 1;;
    esac
done
}

detect_ip_address() {
	# Detect IP address
	local IP
	IP_COMMAND=$(type "ip" &> /dev/null && echo "ip addr show" || echo "ifconfig")
	if [ "$HOST_PLATFORM" = "osx" ]; then
		IP=$($IP_COMMAND | grep inet | grep -v inet6 | grep -v 127.0.0.1 | grep -Eo "([0-9]+\.){3}[0-9]+" | head -1)
	else
		IP=$($IP_COMMAND | grep inet | grep -v inet6 | grep -v 127.0.0.1 | grep -Eo "([0-9]+\.){3}[0-9]+\/[0-9]+" | cut -d "/" -f1)
	fi
	echo $IP
}

get_platform_params

if [ "$IS_ROOT" = "true" ]; then
	echo ""
	echo "Welcome to the OPC Router 4 docker sample with Umati OPC UA, MSSQL and Grafana!"
	echo ""
else
	echo ""
	echo "Welcome to the OPC Router 4 docker sample with Umati OPC UA, MSSQL and Grafana! You might need to enter your password a couple of times."
	echo ""
fi

#install docker if not already present
if [[ $(which "docker" 2>/dev/null) != *"/docker" ]]; then
	install_docker
else
	echo docker is already installed
fi

#download required files
git clone https://$GIT_TOKEN@github.com/OPC-Router/opc-ua-umati-mssql-grafana $TARGET_DIR
cd $TARGET_DIR
sleep 1s
docker-compose up -d

# Detect IP address
IP=$(detect_ip_address)
echo "Sample was installed successfully! Open http://$IP:3000 in a browser!"

#check if xdg-open is installed to launch the default brwoser
if [[ $(which "xdg-open" 2>/dev/null) == *"/xdg-open" ]]; then
	xdg-open http://$IP:3000
fi

exit 0
