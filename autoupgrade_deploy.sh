# Get the target database home:
TARGET_HOME="${ORACLE_23C_HOME:-$ORACLE_19C_HOME}"

# Get the script directory:
SCRIPT_DIR=/scripts

export AU_JOB="$(($(ls $DATA/autoupgrade/$ORACLE_SID | egrep "[0-9]{3}" | sort | tail -1)+1))"

  if [ -z "${ORACLE_23C_HOME}" ]
then AU_JAR=/scripts/autoupgrade.jar
else AU_JAR="${TARGET_HOME}"/rdbms/admin/autoupgrade.jar
fi

# Store values for ORACLE_PATH and SQLPATH:
__oracle_path="${ORACLE_PATH}"
__sqlpath="${SQLPATH}"

# unset ORACLE_PATH and SQLPATH to prevent errors:
unset ORACLE_PATH
unset SQLPATH

echo "The autoupgrade log for this job will be:"
echo "$DATA/autoupgrade/$ORACLE_SID/$AU_JOB/autoupgrade_*.log"
echo " "
echo "Starting autoupgrade in 5 seconds..."
sleep 5

"${TARGET_HOME}"/jdk/bin/java -jar "${AU_JAR}" -config "${DATA}"/autoupgrade/config.txt -mode deploy

export ORACLE_PATH="${__oracle_path}"
export SQLPATH="${__sqlpath}"
