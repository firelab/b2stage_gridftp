FROM centos:7
RUN rpm --import https://packages.irods.org/irods-signing-key.asc && \
    yum install -y epel-release && \
    curl https://packages.irods.org/renci-irods.yum.repo > /etc/yum.repos.d/renci-irods.yum.repo && \
    yum install -y irods-icommands-4.2.0 \
                   irods-auth-plugin-gsi-2.0.0 \
                   irods-devel-4.2.0 \
                   irods-runtime-4.2.0 \
                   irods-externals-clang3.8-0 \
                   irods-externals-cmake3.5.2-0 \
                   irods-externals-cppzmq4.1-0 \
                   globus-gridftp-server-progs \
                   globus-gass-copy-progs \
                   globus-common-devel \
                   globus-gridftp-server-devel \
                   globus-gridmap-callout-error-devel \
                   libcurl-devel \
                   git gcc-c++ \
                   globus-gsi-cert-utils-progs \
                   globus-proxy-utils \
                   sudo && \
    yum clean all && rm -rf /var/cache/yum 

ENV GLOBUS_LOCATION="/usr" \
    IRODS_PATH="/usr" \
    DEST_LIB_DIR="/opt/iRODS_DSI" \
    DEST_BIN_DIR="/opt/iRODS_DSI" \
    DEST_ETC_DIR="/opt/iRODS_DSI" \
    IRODS_EXTERNALS_PATH=/opt/irods-externals \
    IRODS_42_COMPAT=true 


RUN cd /root && \
    git clone https://github.com/EUDAT-B2STAGE/B2STAGE-GridFTP.git && \
    mkdir /opt/iRODS_DSI && \
    cd B2STAGE-GridFTP && \
    /opt/irods-externals/cmake3.5.2-0/bin/cmake . && \
    make install

RUN useradd -r -m irods && \
    mkdir /home/irods/.irods && \
    chown -R irods /home/irods/.irods

COPY edit_config.sh /tmp
RUN /tmp/edit_config.sh 

CMD ["sudo", "-u", "irods", "/etc/init.d/globus-gridftp-server", "restart"]
EXPOSE 2811 50000-51000
