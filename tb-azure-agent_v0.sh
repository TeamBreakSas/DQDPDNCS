#!/bin/bash

agent_folder="/data/dq/tb-agent"
if ! [ -d $agent_folder ];then
   sudo mkdir $agent_folder -p
fi

sudo chown ubuntu:ubuntu $agent_folder

config_serverurl="https://dev.azure.com/TeamBreakSas/DonutQuiz/"
config_pat_token="pncatiw5ud3d67ml7qzzrffppsxgrhgyzeq4fyubizxbyb5fut5a"
config_agentname="$1"

if [ -z "${config_serverurl}" ];then
   echo "serverurl unset"
   exit 1
fi

if [ -z "${config_pat_token}" ];then
   echo "pat token unset"
   exit 1
fi

if [ -z "${config_agentname}" ];then
   echo "agent name unset"
   exit 1
fi

cd $agent_folder
wget https://vstsagentpackage.azureedge.net/agent/2.185.1/vsts-agent-linux-arm64-2.185.1.tar.gz
tar -zxvf vsts-agent-linux-arm64-2.185.1.tar.gz

echo "chmod +x $agent_folder -R"
echo "chmod installdependencies.sh"
sudo chmod +x $agent_folder/bin/installdependencies.sh

sudo apt upgrade -y

echo "Install dependencies"
sudo $agent_folder/bin/installdependencies.sh

sudo apt upgrade -y

echo "./config.sh"

sudo chmod +x $agent_folder/config.sh

./config.sh --unattended --url $config_serverurl --auth pat --token $config_pat_token --pool "DonutQuiz" --agent "$config_agentname" --acceptTeeEula 

echo "chmod svc.sh"
sudo chmod +x $agent_folder/svc.sh

echo "chmod svc.sh install"
sudo $agent_folder/svc.sh install
echo "chmod svc.sh start"
sudo $agent_folder/svc.sh start
