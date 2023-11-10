SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Update the ORACLE_VERSION:
cat << EOF >> /home/oracle/.bashrc
ORACLE_VERSION=19.21
EOF

# Stop the old listener:
$ORACLE_HOME/bin/lsnrctl stop

# Set the environment to use the new SID (updated in oratab by AU)
. oraenv <<< $ORACLE_SID
source /home/oracle/.bashrc

# Update the Docker-specific configurations.
$SCRIPT_DIR/copy_configurations.sh

# Update the listener.ora with the new version:
sed -i -e 's|${ORACLE_HOME}|${ORACLE_19C_HOME}|g' $DATA/dbconfig/$ORACLE_SID/listener.ora

# Start the listener from the new ORACLE_HOME:
$ORACLE_HOME/bin/lsnrctl start

# Report the database registry:
$SCRIPT_DIR/dba_registry.sh
