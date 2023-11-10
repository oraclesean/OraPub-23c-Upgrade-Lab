export VERSION=$(ls /oradata/backups/1)
export CONTAINER_NAME=LAB

  if [ -z $CONTAINER_NAME ] || [ -z $STEP ] || [ -z $VERSION ]
then echo "The following variables must be set:"
     echo "  CONTAINER_NAME: $CONTAINER_NAME"
     echo "  STEP:           $STEP"
     echo "  VERSION:        $VERSION"
     exit 0
fi

sudo rm -fr /oradata/backups/$STEP/$VERSION/*
sudo cp -pr /oradata/$CONTAINER_NAME/* /oradata/backups/$STEP/$VERSION/

docker stop $CONTAINER_NAME 2>/dev/null
sudo rm -fr /oradata/backups/$STEP/$VERSION/*
sudo cp -pr /oradata/$CONTAINER_NAME/* /oradata/backups/$STEP/$VERSION/
