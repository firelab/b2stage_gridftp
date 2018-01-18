# Docker container for b2stage_gridftp

## Summary
This repository is a docker build environment for the [B2STAGE-GridFTP](https://github.com/EUDAT-B2STAGE/B2STAGE-GridFTP) 
project. The idea is to build this docker image first, then include your site-specific customizations by creating your own 
dockerfile which references this image on the FROM line. Hence, this image contains no configuration specific to your 
environment. This image does set up the gridftp server to defer to the iRODS server for authorization and user mapping.

There are currently branches for building against the 4.1 series of irods libraries or the 4.2 series of irods 
libraries.

## Remaining configuration
This image sets up the container to run the gridftp server from a service account called 'irods' but does not provide all 
of the configuration necessary to connect to your iRODS server and authenticate as an administrator account on the backend. 
An example Dockerfile which would supply this information is included below. Since the details of integrating into your 
environment are necessarily specific to your environment, it is not possible to offer an example which will suit all needs. The 
following file provides an `irods_environment.json` file for the service account to use, includes a key and a 
signed certificate in the service account's `~/.globus` directory, and downloads the trustroots from the myproxy-oauth server. 

An example of adding configuration to the gridftp server is included. On the last line, a new file in `/etc/gridftp.d` is 
created which sets the `data_interface` parameter so the server can operate behind a firewall.

```
FROM b2stage_gridftp:4.2
COPY irods_environment.json /home/irods/.irods

ENV MYPROXY_SERVER=oauth.example.com \
    MYPROXY_SERVER_DN="/CN=mine.mine.mine"


#
# GSI authentication of service account to iRODS server
#
RUN yum install -y myproxy && \
    yum clean all && rm -rf /var/cache/yum && \
    myproxy-get-trustroots
COPY *.pem /home/irods/.globus/

#
# Specify public IP address if NATted or behind firewall.
#
RUN echo data_interface 555.666.777.888 > /etc/gridftp.d/nat

RUN chown -R irods /home/irods
```
