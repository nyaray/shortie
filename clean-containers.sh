#!/usr/bin/env bash

docker rm $(docker ps -q -f name="shortie*")

if [ $? -ne 0 ]; then
    echo "Removal of 'shortie' prefixed containers failed"
    echo "  TIP: Consider running stop.sh before trying to run this script again."
fi
