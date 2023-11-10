# Update the Docker-specific configurations.
ORACLE_BASE_CONFIG="$($ORACLE_HOME/bin/orabaseconfig 2>/dev/null || echo $ORACLE_HOME)"/dbs
ORACLE_BASE_HOME="$($ORACLE_HOME/bin/orabasehome 2>/dev/null || echo $ORACLE_HOME)"
TNS_ADMIN=$ORACLE_BASE_HOME/network/admin
ORACLE_CONFIG=$DATA/dbconfig/$ORACLE_SID

# Copy and link database files from the ORACLE_BASE_CONFIG:
 for f in orapw${ORACLE_SID} init${ORACLE_SID}.ora spfile${ORACLE_SID}.ora
  do cp $ORACLE_BASE_CONFIG/$f $ORACLE_CONFIG/ 2>/dev/null
     ln -fs $ORACLE_CONFIG/$f  $ORACLE_BASE_CONFIG/$f 2>/dev/null
done

# Copy and link database files from the ORACLE_BASE_CONFIG:
 for f in listener.ora sqlnet.ora tnsnames.ora
  do cp $TNS_ADMIN/$f          $ORACLE_CONFIG/ 2>/dev/null
     ln -fs $ORACLE_CONFIG/$f  $TNS_ADMIN/$f 2>/dev/null
done

# Copy the updated oratab to the config directory:
cp /etc/oratab $DATA/dbconfig/$ORACLE_SID/
