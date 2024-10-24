# Steps to update the Docker-specific configuration directory post-migration to 23ai.
SCRIPT_DIR=/scripts

# Copy the updated oratab to the config directory for the original SID:
cp /etc/oratab $DATA/dbconfig/$ORACLE_SID/

# Set the environment for the 23ai database:
. oraenv <<< ${ORACLE_SID}CDB
source /home/oracle/.bashrc

# Copy database files from the ORACLE_BASE_HOME/dbs to the config directory:
$SCRIPT_DIR/copy_configurations.sh

# Report the database registry:
$SCRIPT_DIR/dba_registry.sh
