## Table of content

- [Home](https://github.com/buzzware/swas)
- [Introduction](#setup-openresty-nginx-jwt-in-webfaction)
- [Install Lua](#1-lua)
- [Install OpenResty](#2-install-openresty)
- [Install nginx-jwt](#3-install-nginx-jwt)
- [Configure nginx, nginx-jwt](#4-configuration)
- [Testing with curl command](#testing-with-curl--i-command)
- [References](#references)



## Setup `openresty`, `nginx-jwt` in WebFaction:

**Configuration Directories in WebFaction**

In WebFaction, all of our application leaves under `webapps` directory which is
inside $HOME directory i.e /home/user/webapps. Let's name our app
`openresty_nginx_app`. Below diagram will make clear of our directory structure.

	|- webapps/
	|-- openresty_nginx_app/
	|--- app/
	|--- bin/
	|--- openresty/
	|--- tmp

This is our basic directory structure, that we are going to implement for this
example. Also, for running `openresty`, we need to install `lua` in our server.


## Installation

> **IMPORTANT**: **nginx-jwt** is a Lua script that is designed to run on Nginx servers that have the [HttpLuaModule](http://wiki.nginx.org/HttpLuaModule) installed. But ultimately its dependencies require components available in the [OpenResty](http://openresty.org/) distribution of Nginx. Therefore, it is recommended that you use **OpenResty** as your Nginx server, and these instructions make that assumption.

### 1. lua

Because openresty, nginx-jwt uses Lua script, we need to make sure the `lua` is
installed in our server. Please download and install the latest version of lua
	
	$ curl -R -O http://www.lua.org/ftp/lua-5.3.2.tar.gz
    $ tar zxf lua-5.3.2.tar.gz
    $ cd lua-5.3.2

In `Linux`

    $ make linux test
 
In `Mac`
 
    $ make macosx test

### 2. Install `openresty`

NOTE: we will be keeping our `openresty` installation directory inside
our project directory. Also, please make sure you downloaded and installed
latest version of openresty. I am using `1.9.7.1`.

make sure you enable and disable required openresty modules yourself.

	$ cd ~/webapps/openresty_nginx_app
	$ curl -R -O https://openresty.org/download/ngx_openresty-1.9.7.1.tar.gz
    $ tar xvf ngx_openresty-1.9.7.1.tar.gz
    $ cd ngx_openresty-1.9.7.1/
    $ ./configure \
      --prefix=/home/user/webapps/openresty_nginx_app/openresty \
      --with-luajit \
      --with-ipv6 \
      --with-http_postgres_module \
      --with-http_gunzip_module \
      --with-http_secure_link_module \
      --with-http_gzip_static_module \
      --without-http_redis_module \
      --without-http_redis2_module \
      --without-http_xss_module \
      --without-http_memc_module \
      --without-http_rds_json_module \
      --without-http_rds_csv_module \
      --without-lua_resty_memcached \
      --without-lua_resty_mysql \
      --without-http_ssi_module \
      --without-http_autoindex_module \
      --without-http_fastcgi_module \
      --without-http_uwsgi_module \
      --without-http_scgi_module \
      --without-http_memcached_module \
      --without-http_empty_gif_module
    $ make
    $ make install
 
Sometimes, you need `sudo make install`. But WebFaction is a shared server, so
we don't have access to `sudo`. And installing in manual directory don't requires
`sudo` permission.

For more information [http://openresty.org/#Installation](http://openresty.org/#Installation)

> NOTE: it also installed nginx inside 
> `~/webapps/openresty_nginx_app/openresty/nginx` directory, for more information in
> setting up nginx follow [SETUP-NGINX](SETUP-NGINX.md)

### 3. Install `nginx-jwt`

follow [https://github.com/auth0/nginx-jwt#install](https://github.com/auth0/nginx-jwt#install) for more information:

NOTE, you can install `nginx-jwt` inside any directory, but recommended directory
to install `nginx-jwt` is `~/webapps/openresty_nginx_app/openresty/lualib/` directory.

Installation is as simple as extracting the `tag.gz` file. Make sure to use
latest version of nginx-jwt.
	
	$ cd ~/tmp
	$ curl -R -O  https://github.com/auth0/nginx-jwt/releases/download/v1.0.1/nginx-jwt.tar.gz
	$ tar -zxvf nginx-jwt.tar.gz
	$ cp -R nginx-jwt/ ~/webapps/openresty_nginx_app/openresty/lualib/

Nothing fancy here, we are just extracting nginx-jwt.tar.gz and copying everyting
inside nginx-jwt to lualib directory, so that we can reference it in our
nginx.conf file.

### 4. Configuration:

Now, we need to reference to `nginx-jwt.lua` file that we just extracted and
copied inside lualib directory. We can do that by using `lua_package_path` 
nginx directive.

for more information: [https://github.com/auth0/nginx-jwt](https://github.com/auth0/nginx-jwt)

`vi ~/webapps/openresty_nginx_app/openresty/nginx/conf/nginx.conf`

	env JWT_SECRET=c2VjcmV0; 	# BASE64 Encoded word which is equals to "secret"
	env JWT_SECRET_IS_BASE64_ENCODED=true;
	
	worker_processes 1;
	
	events {
		worker_connections 1024;
	}
	
    http {
      include 			mime.types;
      default_type		application/octet-stream;
      
      send_file 		on;
      sendfile_max_chunk 1m;
      
      tcp_nopush	on;
      tcp_nodelay	on;
      
      keepalive_timeout		65;
      
      lua_package_path "$HOME/webapps/openresty_nginx_app/openresty/lualib/?.lua;;";
      
      server {
        listen 			8080;
        server_name 	localhost;
        root 			$HOME/webapps/openresty_nginx_app/app;
        
        location /secure {
          access_by_lua '
            loacl jwt = require('nginx-jwt')
            jwt.auth()
          ';
          try_files $uri /index.html;
        }
      }
    }

We have said nginx all of our lua file are under openresty/lualib directory.
Then we required `nginx-jwt.lua` file using `require`. And called `nginx-jwt`
inbuilt `auth()` function. This function will helps us secure our API with 
invalid JWT token.

### Testing with `curl -i` command

	$ curl -i http://your-host-url/secure

	#RESPONSE:
	
	HTTP/1.1 401 Unauthorized
	Server: nginx
	Date: Mon, 11 Jan 2016 05:29:33 GMT
	Content-Type: text/html
	Content-Length: 200
	Connection: keep-alive
	
	<html>
	<head><title>401 Authorization Required</title></head>
	<body bgcolor="white">
	<center><h1>401 Authorization Required</h1></center>
	<hr><center>openresty/1.9.7.1</center>
	</body>
	</html>
	
With Valid Token:

	curl http://buzzware1.webfactional.com/secure -i -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiIxMjMiLCJleHAiOjE0NTI1ODQzMTF9.f1YEqrkdBdXkD_TKQEOSdA0AMBShVwdGk-17JRJIgVE"
	
Should respond with content in `index.html` page.



## References

- [https://www.nginx.com/](https://www.nginx.com/)
- [https://openresty.org/](https://openresty.org/)
- [http://wiki.nginx.org/HttpLuaModule](http://wiki.nginx.org/HttpLuaModule)
- [https://github.com/auth0/nginx-jwt](https://github.com/auth0/nginx-jwt)
- [http://www.lua.org/](http://www.lua.org/)
