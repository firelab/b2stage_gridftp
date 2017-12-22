#!/bin/bash

cat >> etc/gridftp.conf << EOF
\$LD_LIBRARY_PATH "\$LD_LIBRARY_PATH:/opt/iRODS_DSI"
\$irodsConnectAsAdmin "rods"
load_dsi_module iRODS 
auth_level 4
\$HOME /home/irods
\$GSI_AUTHZ_CONF /opt/iRODS_DSI/gridmap_iRODS_callout.conf
\$GLOBUS_TCP_PORT_RANGE 50000,51000
EOF

sed -i '/END INIT INFO/a \
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/opt/iRODS_DSI/"' /etc/init.d/globus-gridftp-server

