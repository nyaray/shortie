#!/usr/bin/env bash

CONTAINERS=$(docker ps -q -f name="shortie*")
if [ -n "$CONTAINERS" ] ; then
    docker rm $CONTAINERS
fi

if [ -n "$CONTAINERS" -a $? -ne 0 ] ; then
    echo "Removal of 'shortie' prefixed containers failed"
    echo "  TIP: Consider waiting a bit more or running stop.sh before trying to run this script again."
    exit
fi

IMAGES=$(docker images --filter=reference="shortie*" -q)
if [ -n "$IMAGES" ] ; then
    docker rmi IMAGES
fi

docker image prune

echo
echo
echo "Done!"
echo "Sometimes, there are errors because of how the images relate to each
other, so you might want to re-run this script until the prune step says that 0
bytes were reclaimed."