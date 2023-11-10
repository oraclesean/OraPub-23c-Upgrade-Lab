export VERSION=$(ls /oradata/backups/1)
export CONTAINER_NAME=LAB

  if [ -z $CONTAINER_NAME ] || [ -z $STEP ] || [ -z $VERSION ]
then echo "The following variables must be set:"
     echo "  CONTAINER_NAME: $CONTAINER_NAME"
     echo "  STEP:           $STEP"
     echo "  VERSION:        $VERSION"
     exit 0
fi

  if [ "$STEP" -ge 3 ]
then export TAG=19-23
else export TAG=${VERSION}-19
fi

  if [ "$STEP" -eq 5 ]
then export SID=${CONTAINER_NAME}CDB
else export SID=${CONTAINER_NAME}
fi

docker stop $CONTAINER_NAME 2>/dev/null
sudo rm -fr /oradata/$CONTAINER_NAME/*
sudo cp -pr /oradata/backups/$STEP/$VERSION/* /oradata/$CONTAINER_NAME/
  if [ ! -f /oradata/$CONTAINER_NAME/autoupgrade.jar ]
then sudo cp -pr /oradata/autoupgrade.jar /oradata/$CONTAINER_NAME/
fi
docker rm -f $CONTAINER_NAME 2>/dev/null
docker run -d --name $CONTAINER_NAME -e ORACLE_SID=$SID -e PDB_COUNT=0 \
           -v /oradata/$CONTAINER_NAME:/opt/oracle/oradata \
           -v /oradata/scripts:/scripts \
           -p 11521:1521 -p 8080:8080 \
           phx.ocir.io/ax1cxmhdo0fd/oracle/db:${TAG}
