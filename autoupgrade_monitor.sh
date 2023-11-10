CONTAINER_NAME=$(docker ps --format "{{.Names}}")
docker exec -it $CONTAINER_NAME bash -c "AU_JOB=\"\$((\$(ls \$DATA/autoupgrade/\$ORACLE_SID | egrep \"[0-9]{3}\" | sort | tail -1)))\"; tail -f \$DATA/autoupgrade/\$ORACLE_SID/\$AU_JOB/autoupgrade_*.log"
