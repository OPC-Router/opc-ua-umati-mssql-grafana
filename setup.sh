#!/usr/bin/env bash
GITHUB_REPO="opc-ua-umati-mssql-grafana"

# don't edit this
TARGET_DIR="OPCRouter_${GITHUB_REPO//-/_}"
GITHUB_DIR="$GITHUB_REPO-main"
GITHUB_REPO_ADRESS="https://github.com/OPC-Router/$GITHUB_REPO/" #GITHUB_REPO_ADRESS="https://github.com/OPC-Router/$GITHUB_REPO/"
GITHUB_TARBALL_ADRESS="https://api.github.com/repos/OPC-Router/$GITHUB_REPO/tarball"

# Test if this script is being run as root or not
if [[ $EUID -eq 0 ]];
then IS_ROOT=true;  SUDOX=""
else IS_ROOT=false; SUDOX="sudo "; fi
ROOT_GROUP="root"
USER_GROUP="$USER"


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
}


install_package_linux() {
	package="$1"
	# Test if the package is installed
	dpkg -s "$package" &> /dev/null
	if [ $? -ne 0 ]; then
		if [ "$INSTALL_CMD" = "yum" ]; then
			# Install it
			errormessage=$( $SUDOX $INSTALL_CMD $INSTALL_CMD_ARGS $package > /dev/null 2>&1)
		else
			# Install it
			errormessage=$( $SUDOX $INSTALL_CMD $INSTALL_CMD_ARGS --no-install-recommends $package > /dev/null 2>&1)
		fi

		# Hide "Error: Nothing to do"
		if [ "$errormessage" != "Error: Nothing to do" ]; then
			if [ "$errormessage" != "" ]; then
				echo $errormessage
			fi
			echo "Installed $package"
		fi
	fi
}

install_package_freebsd() {
	package="$1"
	# check if package is installed (pkg is nice enough to provide us with a exitcode)
	if ! $INSTALL_CMD info "$1" >/dev/null 2>&1; then
		# Install it
		$SUDOX $INSTALL_CMD $INSTALL_CMD_ARGS "$1" > /dev/null
		echo "Installed $package"
	fi
}

install_package_macos() {
	package="$1"
	# Test if the package is installed (Use brew to install essential tools)
	$INSTALL_CMD list | grep "$package" &> /dev/null
	if [ $? -ne 0 ]; then
		# Install it
		$INSTALL_CMD $INSTALL_CMD_ARGS $package &> /dev/null
		if [ $? -eq 0 ]; then
			echo "Installed $package"
		else
			echo "$package was not installed"
		fi
	fi
}

install_package() {
	case "$HOST_PLATFORM" in
		"linux")
			install_package_linux $1
		;;
		"osx")
			install_package_macos $1
		;;
		"freebsd")
			install_package_freebsd $1
		;;
		# The following should never happen, but better be safe than sorry
		*)
			echo "Unsupported platform $HOST_PLATFORM"
		;;
	esac
}

install_docker() {
	echo "docker is missing and required for using the sample."
	read -r -p "Install docker now? [y/N] " response
	echo "$response"
	case "$response" in
		[yY][eE][sS]|[yY] ) get_and_run_docker_installer;;
		*) exit 1;;
	esac
}

get_and_run_docker_installer() {
	if [[ $(which "curl" 2>/dev/null) == *"/curl" ]]; then
		curl -fsSL https://get.docker.com | bash -
	elif [[ $(which "wget" 2>/dev/null) == *"/wget" ]]; then
		wget -O - https://get.docker.com | bash -
	else
		install_package "curl"
		get_and_run_docker_installer
	fi
}

detect_ip_address() {
	# Detect IP address
	local IP
	IP_COMMAND=$(type "ip" &> /dev/null && echo "ip addr show" || echo "ifconfig")
	if [ "$HOST_PLATFORM" = "osx" ]; then
		IP=$($IP_COMMAND | grep inet | grep -v inet6 | grep -v 127.0.0.1 | grep -v docker | grep -Eo "([0-9]+\.){3}[0-9]+" | head -1)
	else
		IP=$($IP_COMMAND | grep inet | grep -v inet6 | grep -v 127.0.0.1 | grep -v docker | grep -Eo "([0-9]+\.){3}[0-9]+\/[0-9]+" | cut -d "/" -f1 | head -1)
	fi
	echo $IP
}

unpack_archive() {
	if [[ $(which "tar" 2>/dev/null) == *"/tar" ]]; then
		mkdir $TARGET_DIR
		tar -zxf $TARGETDIR.tar.gz -C $TARGET_DIR
		mv $TARGET_DIR/OPC-Router-$GITHUB_REPO-*/* "$TARGET_DIR"
		rm -rf $TARGET_DIR/OPC-Router-$GITHUB_REPO-*/
	else
		install_package "tar"
		unpack_archive
	fi
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
if [[ $(which "docker-compose" 2>/dev/null) != *"/docker-desktop" ]]; then
	install_package "docker-compose"
else
	echo docker-compose is already installed
fi

#download required files
if [[ $(which "git" 2>/dev/null) == *"/git" ]]; then
	git clone $GITHUB_REPO_ADRESS $TARGET_DIR
else
	install_package "curl"
	if [[ $(which "curl" 2>/dev/null) == *"/curl" ]]; then
		curl -fsSL $GITHUB_TARBALL_ADRESS > $TARGETDIR.tar.gz
		unpack_archive
	elif [[ $(which "wget" 2>/dev/null) == *"/wget" ]]; then
		wget -O - $GITHUB_TARBALL_ADRESS > $TARGETDIR.tar.gz
		unpack_archive
	else
		echo "Unable to do things"
		exit 1
	fi
fi

#ensure docker daemon is running
$($SUDOX systemctl start docker.service)
$($SUDOX systemctl enable containerd.service)

cd $TARGET_DIR
sleep 1s
$($SUDOX docker-compose up -d)

# Detect IP address
IP=$(detect_ip_address)
echo "Waiting for final steps to complete"
GRAF_REACHABLE=1
while [[ GRAF_REACHABLE -ne 0 ]]
do
	if [[ $(which "curl" 2>/dev/null) == *"/curl" ]]; then
		curl localhost:3000 &>/dev/null
		GRAF_REACHABLE=$?
	elif [[ $(which "wget" 2>/dev/null) == *"/wget" ]]; then
		wget localhost:3000 &>/dev/null
		GRAF_REACHABLE=$?
	fi
done
echo "Sample was installed successfully! Open http://$IP:3000/d/v972rfT7k/umati-machine-data in a browser!"
echo "Once you finished observing the sample, you may stop it by running 'docker-compose down'"

#check if xdg-open is installed to launch the default brwoser
if [[ $(which "xdg-open" 2>/dev/null) == *"/xdg-open" ]]; then
	xdg-open http://$IP:3000/d/v972rfT7k/umati-machine-data
fi

exit 0
