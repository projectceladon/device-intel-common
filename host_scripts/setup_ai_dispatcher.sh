#!/bin/bash

# Copyright (c) 2023 Intel Corporation.
# All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0

set -eE

#---------      Global variable     -------------------
CIV_WORK_DIR=$(pwd)
AI_DISPATCHER_DIR=$CIV_WORK_DIR/ai-dispatcher
MODEL_DIR=$AI_DISPATCHER_DIR/model
CLIENT_REQ_FILE=client_requirements.txt
GRPC_PATH=$CIV_WORK_DIR/grpc

#---------      Functions      -------------------
function install_pre_requisites() {
    sudo apt update
    sudo apt-get install -y git python3 python-dev 

    if [ ! -x "$(command -v pip3)" ]; then
        echo " Installing Python-pip"
        sudo apt-get -y install python3-pip
    fi

    version=$(pip3 -V 2>&1 | grep -Po '(?<=pip )\d+')
    if [ "$version" -lt "19" ]; then
        echo "Upgrading Python-pip version"
        pip3 install --upgrade pip
    fi

    python3 -m pip install six openvino-dev==2022.3.0
    echo "Installing pre-requisites"
}

function setup_ai_dispatcher() {
    echo "Setting up ai-dispatcher....."
    if [ ! -e "$AI_DISPATCHER_DIR" ]; then
        git clone https://github.com/projectceladon/ai-dispatcher.git $AI_DISPATCHER_DIR
    fi

    cd $AI_DISPATCHER_DIR
    if [ ! -e "$AI_DISPATCHER_DIR/$CLIENT_REQ_FILE" ]; then
        echo "Client Requirement file to enable remote inferencing not present"
        exit -1
    fi

    echo "Downloading client_requirement.txt"
    python3 -m pip install -r $AI_DISPATCHER_DIR/$CLIENT_REQ_FILE

    echo "create model directory"
    if [ -d "$MODEL_DIR" ]; then
        sudo rm -rfd $MODEL_DIR
    fi
    sudo mkdir -p $MODEL_DIR

    echo "Checking for environment PYTHON PATH"
    a=`grep -rn "PYTHONPATH\=\".*ai-dispatcher.*\"" /home/$SUDO_USER/.bashrc`
    b=`grep -rn "PYTHONPATH" /home/$SUDO_USER/.bashrc`
    if [ -z "$b" ]; then
        echo "export PYTHONPATH="$PYTHONPATH:$AI_DISPATCHER_DIR"" | sudo tee -a /home/$SUDO_USER/.bashrc
    elif [ -z "$a" ]; then
        sudo sed -i "s|PYTHONPATH.*||g" $HOME/.bashrc
        echo "export  PYTHONPATH="$PYTHONPATH:$AI_DISPATCHER_DIR"" | sudo tee -a /home/$SUDO_USER/.bashrc
    fi
    sudo chown -R $SUDO_USER:$SUDO_USER $AI_DISPATCHER_DIR
}

function setup_grpc() {
    echo "Installing grpc with vsock support....."
    if [ ! -e "$GRPC_PATH" ]; then
        git clone -b v1.46.2 https://github.com/grpc/grpc.git $GRPC_PATH && cd $GRPC_PATH
        git submodule update --init
        git am $CIV_WORK_DIR/patches/grpc-host/0001-support-vsock-v1.46.2.patch
        cd $GRPC_PATH/third_party/zlib
        git am  $CIV_WORK_DIR/patches/grpc-host/0002-Fix-a-bug-when-getting-a-gzip-header-extra-field-wit.patch
        cd $GRPC_PATH
    else
        cd $GRPC_PATH
        echo "grpc repo already cloned, skipping cloning..."
    fi
    pip install -r requirements.txt
    GRPC_PYTHON_BUILD_WITH_CYTHON=1 pip install .
}

function check_env_proxy() {
    a=`grep -rn "no_proxy\=\".*localhost.*\"" /home/$SUDO_USER/.bashrc`
    b=`grep -rn "no_proxy" /home/$SUDO_USER/.bashrc`
    echo "Checking for environment no_proxy settings"

    if [ -z "$b" ]; then
        echo "export no_proxy=\"localhost\"" | sudo tee -a /home/$SUDO_USER/.bashrc
    elif [ -z "$a" ]; then
        sudo sed -i "s|export no_proxy.*||g" $HOME/.bashrc
        echo "export no_proxy=\"$no_proxy,localhost\"" | sudo tee -a /home/$SUDO_USER/.bashrc
    fi
}

function setup_infer_service() {
    echo "Adding AI-Dispatcher rawTensor Service"
    sudo touch /lib/systemd/system/ai_raw_tensor.service

    cat << EOF | sudo tee /lib/systemd/system/ai_raw_tensor.service
[Unit]
Description="Start/Stop Remote Inferencing"

[Service]
User=$SUDO_USER
WorkingDirectory=$(pwd)/
Type=simple
ExecStart=/bin/bash ../scripts/ai_raw_tensor.sh $1

[Install]
WantedBy=multi-user.target
EOF
    sudo systemctl enable ai_raw_tensor
    sudo systemctl start ai_raw_tensor
    echo "Starting Remote Inferencing Setup Script"
}

#-------------    main processes    -------------

check_env_proxy
install_pre_requisites
setup_grpc
setup_ai_dispatcher
setup_infer_service $1

echo "remote infer installation done"
#!/bin/bash
