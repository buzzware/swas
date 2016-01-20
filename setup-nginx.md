## Table of content

- [Installation](#installation)
- [Nginx Start, Stop and Restart bash script](#start-stop-and-restart-script-for-nginx)
- [Execute scripts](#you-should-be-able-to-run-those-scripts)
- [Test nginx.conf](#test-your-nginx-configuration)

## Setup Nginx for nginx-jwt

### Installation

Because we are using `openresty` for setting up `nginx-jwt`, so we don't have
to install `nginx` seperately. `openresty` will automatically install nginx
as well as other required libraries for us. 

Please follow [setup-openresty-nginx-webfaction](setup-openresty-nginx-webfaction.md)
for installing `openresty` with `nginx` in our `WebFaction` server.

### start, stop and restart script for `nginx`

Once the nginx is installed successfully in manual directory other then OS
installation directory, it is often pain to know how to start, stop or restart
nginx server. So, we are creating nginx start, stop and restart scripts for our
nginx configuraton.

Before moving forward, please make sure you have followed steps to install 
openresty which will install nginx for us.

>
**Also don't forget to update path as per your configuration in below scripts.**

1) Create `start`, `stop` and `restart` bash script files:

```
# make sure you have installed openresty inside your project directory
#
$ cd /your/project/directory
$ mkdir bin
$ cd bin
$ touch start stop restart
$ chmod +x start stop restart
```

2) copy and past below line of start script, I am using vi editor to edit 
start file: `$ vi start`

	#!/bin/bash
			
	ln -sf ~/logs/user/nginx_error_rails_passenger_nginx.log
	
	PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/user/bin TMPDIR=/path/to/your/project/tmp /path/to/your/project/openresty/nginx/sbin/nginx -p /path/to/your/project/openresty/nginx/
		
		
3) copy and past below line of stop script: `$ vi stop`

	#!/bin/bash

	pid_file=/path/to/your/project/openresty/nginx/logs/nginx.pid

	if [ -f $pid_file ]
	then
  		kill $( cat $pid_file )
	fi
	sleep 3
	rm -rf /home/buzzware1/webapps/openresty_nginx_app/tmp/*
	
> Don't forget to set `nginx.pid` path in your `nginx.conf` file.

4) copy and past below line of restart script: `$ vi restart`
	
	#!/bin/bash
	
	/path/to/your/project/bin/stop
	/path/to/your/project/bin/start

**IMPORTANT NOTES:**

1. Make sure you have installed `openresty`
2. Install `openresty` inside openresty directory of your project directory
3. Your `nginx` will get installed inside openresty > nginx directory
4. You can change installation directories and other configuration options 
while installing `openresty`.

### You should be able to run those scripts:

	$ cd /path/to/your/project
	$ ./bin/start
	$ ./bin/stop
	$ ./bin/restart

### Test your nginx configuration:

If you want to test your config file:

	$ cd /path/to/your/project/openresty/nginx
	$ sbin/nginx -p `pwd` -c config/nginx.conf -t

Sometimes, if `pid` is not set, we need to forcefully stop/kill nginx:

	$ ps -ef | grep nginx
	# => 23439
	$ kill 23439
