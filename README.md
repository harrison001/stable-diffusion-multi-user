# Stable Diffusion Multi-user
> stable diffusion multi-user django server code with multi-GPU load balancing 

# Features

- a django server that provides stable-diffusion http API, including:
    - txt2img, img2img(todo)
    - check generating progress
    - interrupt generating
    - list available models
    - change models
    - ...
- supports civitai models and lora, etc.
- supports multi-user queuing
- supports multi-user separately changing models, and won't affect each other
- provides downstream load-balancing server code that automatically do load-balancing among available GPU servers, and ensure that user requests are sent to the same server within one generation cycle

You can build your own UI, community features, account login&payment, etc. based on these functions!

# Project directory structure

The project can be roughly divided into two parts: django server code, and [stable-diffusion-webui](https://github.com/AUTOMATIC1111/stable-diffusion-webui) code that we use to initialize and run models. And I'll mainly explain the django server part.

In the main project directory:

- `modules/`: stable-diffusion-webui modules
- `sd_multi/`: the django project name
    - `urls.py`: server API path configuration
- `simple/`: the main django code
    - `views.py`: main API processing logic
    - `lb_views.py`: load-balancing API
- `requirements.txt`: stable diffusion pip requirements
- `setup.sh`: run it with options to setup the server environment
- `gen_http_conf.py`: called in `setup.sh` to setup the apache configuration

# Deploy on a GPU server

1. SSH to the GPU server
2. clone or download the repository
3. cd to the main project directory(that contains `manage.py`)
4. run `sudo bash setup.sh` with options(checkout the `setup.sh` for options)
    - if some downloads are slow, you can always download manually and upload to your server
5. restart apache: `sudo service apache2 restart`

## API definition

- `/`: view the homepage, used to test that apache is configured successfully
- `/txt2img/`: try the txt2img with stable diffusion
```
// demo request
task_id: required string,
model: optional string, // change model with this param
prompt: optional string,
negative_prompt: optional string,
sampler_name: optional string,
steps: optional int, // default=20
cfg_scale: optional int, // default=8
width: optional int, // default=512
height: optional int, // default=768
seed: optional int // default=-1
// ...
// modify views.py for more optional parameters

// response
images: list<string>, // image base64 data list
parameters: string
```

- `/progress/`: get the generation progress
```
// request
task_id: required string

// response
progress: float, // progress percentage
eta: float, // eta seconds
```

- `/interrupt/`: terminate an unfinished generation
```
// request
task_id: required string
```

- `/list_models/`: list available models
```
// response
models: list<string>
```

# Deploy the load-balancing server

1. SSH to a CPU server
2. clone or download the repository
3. cd to the main project directory(that contains `manage.py`)
4. run `sudo bash setup.sh lb`
5. run `mv sd_multi/urls.py sd_multi/urls1.py && mv sd_multi/urls_lb.py sd_multi/urls.py`
6. modify `ip_list` variable with your own server ip+port in `simple/lb_views.py`
7. restart apache: `sudo service apache2 restart`

Finally, you can call your http API(test it using postman).