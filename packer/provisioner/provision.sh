#!/usr/bin/env bash

set -eo pipefail;

function run_as_root() {

	function log_text() {
		local log_level="$1";
		local log_message="$2";
		local echo_argument="$3";
		local datepart=$(date +"%d-%m-%Y %H:%M:%S,%3N");
		echo $echo_argument "[$datepart] [`hostname`] [$log_level] [`whoami`] $log_message";
	}

	function log_info() {
		log_text "INFO " "$1";
	}

	function update_system() {
		log_info "Updating system";
		apt-get update;
		DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade;
		apt-get -y autoremove;
	}

	function install_tools() {
		log_info "Installing tools.";
		apt-get install -y python=2.7.* unzip htop ngrep jq zip;
		curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip";
		unzip awscli-bundle.zip;
		./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws;
		rm -Rf awscli-bundle*;
	}

	function configure_cron() {
        log_info "Disabling cron for system boot and timer."
        systemctl mask apt-daily.service;
        systemctl mask apt-daily.timer;
        systemctl mask apt-daily-upgrade.service;
        systemctl mask apt-daily-upgrade.timer;
	}

	function run_all() {
		update_system;
		install_tools;
		configure_cron;
		log_info "Done.";
	}

	run_all;
}

FUNC=$(declare -f run_as_root);
sudo bash -c "$FUNC; run_as_root";

