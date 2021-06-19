#!/bin/bash

username=$(uuidgen | cut -c 1-6)
password=$(uuidgen | cut -c 1-8)
instance="auto_samba"

(docker stop $instance > /dev/null 2>&1)
docker run -it --rm \
        -e USERID=$(id -u) -e GROUPID=$(id -g) \
        -p 139:139 -p 445:445 \
        --name $instance \
        -v $(pwd):/mount -d dperson/samba -p \
        -u "$username;$password" \
        -s "share;/mount;no;no;no"

if [ $? -ne 0 ]; then
    echo "command failed"
    exit 1
fi

echo -e "login with:\n\tusername:$username\n\tpassword:$password"
