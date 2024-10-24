# https://hub.docker.com/_/httpd
# https://github.com/docker-library/httpd
# https://httpd.apache.org/docs/2.4/ssl/ssl_faq.html

docker pull httpd
docker run -dit --name httpd -p 65430:80 -v "$PWD/NTFS/htdocs":/usr/local/apache2/htdocs httpd

# How to use this image.

# This image only contains Apache httpd with the defaults from upstream. There is no PHP installed, but it should not be hard to extend. On the other hand, if you just want PHP with Apache httpd see the PHP image and look at the -apache tags. If you want to run a simple HTML server, add a simple Dockerfile to your project where public-html/ is the directory containing all your HTML.

# 
# Create a Dockerfile in your project
# 
FROM httpd:2.4
COPY ./public-html/ /usr/local/apache2/htdocs/
# Then, run the commands to build and run the Docker image:
$ docker build -t my-apache2 .
$ docker run -dit --name my-running-app -p 8080:80 my-apache2
# Visit http://localhost:8080 and you will see It works!

# 
# Without a Dockerfile
# If you don't want to include a Dockerfile in your project, it is sufficient to do the following:
# 
$ docker run -dit --name my-apache-app -p 8080:80 -v "$PWD":/usr/local/apache2/htdocs/ httpd:2.4

# 
# Configuration
# To customize the configuration of the httpd server, first obtain the upstream default configuration from the container:
# 
$ docker run --rm httpd:2.4 cat /usr/local/apache2/conf/httpd.conf > my-httpd.conf
# You can then COPY your custom configuration in as /usr/local/apache2/conf/httpd.conf:
FROM httpd:2.4
COPY ./my-httpd.conf /usr/local/apache2/conf/httpd.conf

# 
# SSL/HTTPS
# 
# If you want to run your web traffic over SSL, the simplest setup is to COPY or mount (-v) your server.crt and server.key into /usr/local/apache2/conf/ and then customize the /usr/local/apache2/conf/httpd.conf by removing the comment symbol from the following lines:

...
#LoadModule socache_shmcb_module modules/mod_socache_shmcb.so
...
#LoadModule ssl_module modules/mod_ssl.so
...
#Include conf/extra/httpd-ssl.conf
...

# The conf/extra/httpd-ssl.conf configuration file will use the certificate files previously added and tell the daemon to also listen on port 443. Be sure to also add something like -p 443:443 to your docker run to forward the https port.

# This could be accomplished with a sed line similar to the following:

RUN sed -i \
		-e 's/^#\(Include .*httpd-ssl.conf\)/\1/' \
		-e 's/^#\(LoadModule .*mod_ssl.so\)/\1/' \
		-e 's/^#\(LoadModule .*mod_socache_shmcb.so\)/\1/' \
		conf/httpd.conf

# The previous steps should work well for development, but we recommend customizing your conf files for production, see httpd.apache.org for more information about SSL setup.