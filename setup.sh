#! /usr/bin/env bash
# env
# requires a GPU Linux machine
# needs to be in the same directory as manage.py
# cd to the current directory before executing
# sudo bash setup.sh

if [ $1 == "env" ]; then 
    # install system packages
    apt-get update
    apt-get install python3-pip
    apt-get install apache2
    apt-get install libapache2-mod-wsgi-py3
    apt-get install libgl1-mesa-glx
    apt-get install libglib2.0-0
elif [ $1 == "venv" ]; then
    # setup python virtual env and install pip dependancies
    python3 -m venv venv
    source ./venv/bin/activate
    pip3 install django
    pip3 install django-cors-headers
    pip3 install -r simple/requirements.txt --extra-index-url https://pypi.tuna.tsinghua.edu.cn/simple
    pip3 install torch==1.13.1+cu117 --extra-index-url https://download.pytorch.org/whl/cu117
    pip3 install torchvision==0.14.1+cu117 --extra-index-url https://download.pytorch.org/whl/cu117
    deactivate
elif [ $1 == "apache" ]; then
    # configure apache
    python3 gen_http_conf.py
    service apache2 restart
elif [ $1 == "sd_model" ]; then
    # download models
    wget -P ./models/Stable-diffusion https://huggingface.co/Hardy01/chill_watcher/resolve/main/models/Stable-diffusion/chilloutmix_NiPrunedFp32Fix.safetensors
    wget -P ./models/VAE https://huggingface.co/Hardy01/chill_watcher/resolve/main/models/VAE/vae-ft-mse-840000-ema-pruned.ckpt
    wget -P ./models/Lora https://huggingface.co/Hardy01/chill_watcher/resolve/main/models/Lora/koreanDollLikeness_v10.safetensors
    wget -P ./models/Lora https://huggingface.co/Hardy01/chill_watcher/resolve/main/models/Lora/taiwanDollLikeness_v10.safetensors
elif [ $1 == "lb" ]; then
    apt-get update
    apt-get install python3-pip
    apt-get install apache2
    apt-get install libapache2-mod-wsgi-py3
    python3 -m venv venv
    source ./venv/bin/activate
    pip3 install django
    pip3 install django-cors-headers
    python3 gen_http_conf.py
    service apache2 restart
else 
    echo "option required\n options: [env | venv | apache | sd_model | lb]"
fi