# Steps to add the 23c database to the Docker-specific configuration directory.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Copy the updated oratab to the config directory for the original SID:
cp /etc/oratab $DATA/dbconfig/$ORACLE_SID/

# Copy the existing pre-19c config directory to the new SID:
cp -rp $DATA/dbconfig/$ORACLE_SID $DATA/dbconfig/${ORACLE_SID}CDB/

# Remove the SID-specific files:
rm $DATA/dbconfig/${ORACLE_SID}CDB/*LAB*

# Set the environment for the 23c database:
. oraenv <<< ${ORACLE_SID}CDB
source /home/oracle/.bashrc

# Copy database files from the ORACLE_BASE_HOME/dbs to the config directory:
$SCRIPT_DIR/copy_configurations.sh

# Update the listener.ora to reflect the new home:
sed -i -e 's|$ORACLE_HOME|$ORACLE_23C_HOME|g' $DATA/dbconfig/$ORACLE_SID/listener.ora

# Report the database registry:
$SCRIPT_DIR/dba_registry.sh
