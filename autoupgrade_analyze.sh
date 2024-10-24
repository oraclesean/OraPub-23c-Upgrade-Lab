# Get the target database home:
TARGET_HOME="${ORACLE_23AI_HOME:-$ORACLE_19C_HOME}"

# Get the script directory:
SCRIPT_DIR=/scripts

  if [ -z "${ORACLE_23AI_HOME}" ]
then AU_JAR=/scripts/autoupgrade.jar
else AU_JAR="${TARGET_HOME}"/rdbms/admin/autoupgrade.jar
fi

# Store values for ORACLE_PATH and SQLPATH:
__oracle_path="${ORACLE_PATH}"
__sqlpath="${SQLPATH}"

# unset ORACLE_PATH and SQLPATH to prevent errors:
unset ORACLE_PATH
unset SQLPATH

"${TARGET_HOME}"/jdk/bin/java -jar "${AU_JAR}" -config "${DATA}"/autoupgrade/config.txt -mode analyze

export ORACLE_PATH="${__oracle_path}"
export SQLPATH="${__sqlpath}"

export AU_JOB="$(ls "${DATA}"/autoupgrade/"${ORACLE_SID}" | egrep "[0-9]{3}" | sort | tail -1)"

echo " "
echo "Check the autoupgrade log for errors:"
echo "$DATA/autoupgrade/$ORACLE_SID/$AU_JOB/prechecks/*_preupgrade.log"
