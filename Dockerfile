FROM centos:7

RUN curl -L ftp://ftp.renci.org/pub/irods/releases/4.1.11/centos7/irods-runtime-4.1.11-centos7-x86_64.rpm > /tmp/irods-runtime-4.1.11-centos7-x86_64.rpm && \
    curl -L ftp://ftp.renci.org/pub/irods/releases/4.1.11/centos7/irods-icommands-4.1.11-centos7-x86_64.rpm > /tmp/irods-icommands-4.1.11-centos7-x86_64.rpm && \
    curl -L ftp://ftp.renci.org/pub/irods/releases/4.1.11/centos7/irods-dev-4.1.11-centos7-x86_64.rpm > /tmp/irods-dev-4.1.11-centos7-x86_64.rpm && \
    curl -L ftp://ftp.renci.org/pub/irods/plugins/irods_auth_plugin_gsi/1.5/irods-auth-plugin-gsi-1.5-centos7-x86_64.rpm > /tmp/irods-auth-plugin-gsi-1.5-centos7-x86_64.rpm && \
    yum install -y epel-release && \
    yum install -y /tmp/irods-dev-4.1.11-centos7-x86_64.rpm \
                   /tmp/irods-auth-plugin-gsi-1.5-centos7-x86_64.rpm \
                   /tmp/irods-runtime-4.1.11-centos7-x86_64.rpm \
                   /tmp/irods-icommands-4.1.11-centos7-x86_64.rpm \
                   cmake \
                   gcc-c++ \
                   git \
                   globus-common-devel \
                   globus-gass-copy-progs \
                   globus-gridftp-server-devel \
                   globus-gridftp-server-progs \
                   globus-gridmap-callout-error-devel \
                   globus-gsi-cert-utils-progs \
                   globus-proxy-utils \
                   libcurl-devel \
                   sudo && \
    yum clean all && rm -rf /var/cache/yum && \
    rm /tmp/irods-dev-4.1.11-centos7-x86_64.rpm \
       /tmp/irods-auth-plugin-gsi-1.5-centos7-x86_64.rpm \
       /tmp/irods-icommands-4.1.11-centos7-x86_64.rpm \
       /tmp/irods-runtime-4.1.11-centos7-x86_64.rpm

ENV GLOBUS_LOCATION="/usr" \
    IRODS_PATH="/usr" \
    DEST_LIB_DIR="/opt/iRODS_DSI" \
    DEST_BIN_DIR="/opt/iRODS_DSI" \
    DEST_ETC_DIR="/opt/iRODS_DSI" 

RUN cd /root && \
    git clone https://github.com/EUDAT-B2STAGE/B2STAGE-GridFTP.git && \
    cd B2STAGE-GridFTP && \
    git fetch --tags && \ 
    git checkout tags/release-1.81 && \
    mkdir /opt/iRODS_DSI && \
    cmake . && \
    make install

RUN useradd -r -m irods && \
    mkdir /home/irods/.irods \
          /etc/gridftp.d \
          /var/log/gridftp && \
    chown -R irods /home/irods/.irods /var/log/gridftp
    
COPY config/* /etc/gridftp.d/
COPY run_gridftp_server /usr/sbin

CMD ["sudo", "-u", "irods", "/usr/sbin/run_gridftp_server"]
EXPOSE 2811 50000-51000
