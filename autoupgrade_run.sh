# Get the target database home:
TARGET_HOME="${ORACLE_23C_HOME:-$ORACLE_19C_HOME}"

# Get the script directory:
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

  if [ -f "${SCRIPT_DIR}"/autoupgrade.jar ]
then AU_JAR="${SCRIPT_DIR}"/autoupgrade.jar
else AU_JAR="${TARGET_HOME}"/rdbms/admin/autoupgrade.jar
fi

# Store values for ORACLE_PATH and SQLPATH:
__oracle_path="${ORACLE_PATH}"
__sqlpath="${SQLPATH}"

# unset ORACLE_PATH and SQLPATH to prevent errors:
unset ORACLE_PATH
unset SQLPATH

"${TARGET_HOME}"/jdk/bin/java -jar "${AU_JAR}" -config "${DATA}"/autoupgrade/config.txt -mode "${1}"

export ORACLE_PATH="${__oracle_path}"
export SQLPATH="${__sqlpath}"

export AU_JOB="$(ls "${DATA}"/autoupgrade/"${ORACLE_SID}" | egrep "[0-9]{3}" | sort | tail -1)"
