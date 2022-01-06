#!/usr/bin/env bash
GIT_TOKEN="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"
GITHUB_REPO="opc-ua-umati-mssql-grafana"

# don't edit this
TARGET_DIR="OPCRouter_${GITHUB_REPO//-/_}"
GITHUB_DIR="$GITHUB_REPO-main"
GITHUB_REPO_ADRESS="https://$GIT_TOKEN@github.com/OPC-Router/$GITHUB_REPO/" #GITHUB_REPO_ADRESS="https://github.com/OPC-Router/$GITHUB_REPO/"
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
		#TODO install curl?
		echo "Unable to automatically install docker runtime. Visit https://docs.docker.com/engine/install/ to see how you may install it yourself."
		echo "Please run the previously entered command again once you installed docker."
		exit 1
	fi
	if [[ $(which "docker-compose" 2>/dev/null) != *"/docker-desktop" ]]; then
		install_package "docker-compose"
	fi
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

unpack_archive() {
	if [[ $(which "tar" 2>/dev/null) == *"/tar" ]]; then
		tar -zxf $TARGETDIR.tar.gz -C $TARGET_DIR
		mv "$TARGET_DIR/OPC-Router-$GITHUB_REPO-*/* $TARGET_DIR"
		rm -rf "$TARGET_DIR/OPC-Router-$GITHUB_REPO-*/"
	else
		#TODO install tar?
		echo "unable to unpack tarball"
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

#download required files
if [[ $(which "git" 2>/dev/null) == *"/git" ]]; then
	git clone $GITHUB_REPO_ADRESS $TARGET_DIR
	mv $GITHUB_REPO $TARGET_DIR
elif [[ $(which "tar" 2>/dev/null) == *"/tar" ]]; then
	if [[ $(which "curl" 2>/dev/null) == *"/curl" ]]; then
		curl -H "Authorization: token $GIT_TOKEN" -fsSL $GITHUB_TARBALL_ADRESS > $TARGETDIR.tar.gz
		unpack_archive
	elif [[ $(which "wget" 2>/dev/null) == *"/wget" ]]; then
		wget --header="Authorization: token $GIT_TOKEN" -O - $GITHUB_TARBALL_ADRESS > $TARGETDIR.tar.gz
		unpack_archive
	else
		echo "Unable to do things" #TODO install some components?
		exit 1
	fi
else
	echo "Unable to do things" #TODO install some components?
fi

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
