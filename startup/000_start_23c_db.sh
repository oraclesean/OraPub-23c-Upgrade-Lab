#!/bin/bash

# Find and loop through any dbconfig directories that don't belong to the current (default) database:
 for SID in "$(ls -d1 "${DATA}"/dbconfig/* | grep -v -E "/${ORACLE_SID}$" | awk -F"/" '{print $NF}')"
  do # Add the oratab entry for this database if it doesn't exist:
       if [ -f /etc/oratab ] && [ "$(grep -c -E "^${SID}:" /etc/oratab)" -eq 0 ]
     then grep -v -E "^$|^#" "${DATA}"/dbconfig/"${SID}"/oratab >> /etc/oratab
     fi

     # Set the environment:
     . oraenv  <<< "${SID}"

     # Set the location of the configuration directory:
     dbconfig="${DATA}"/dbconfig/"$ORACLE_SID"

     # Get the proper base/home directories:
     export ORACLE_BASE_CONFIG=$("$ORACLE_HOME"/bin/orabaseconfig)/dbs
     export ORACLE_BASE_HOME=$("$ORACLE_HOME"/bin/orabasehome)
     export TNS_ADMIN="$ORACLE_BASE_HOME"/network/admin

     # Link/copy the configuration files:
      for filename in "$ORACLE_BASE_CONFIG"/init"$ORACLE_SID".ora \
                      "$ORACLE_BASE_CONFIG"/spfile"$ORACLE_SID".ora \
                      "$ORACLE_BASE_CONFIG"/orapw"$ORACLE_SID" \
                      "$ORACLE_BASE_HOME"/network/admin/listener.ora \
                      "$ORACLE_BASE_HOME"/network/admin/tnsnames.ora \
                      "$ORACLE_BASE_HOME"/network/admin/sqlnet.ora
       do file=$(basename "$filename")
          # If the file exists in the expected location, but not in the
          # configuration directory, move it to the config directory.
            if [ -f "$filename" ] && [ ! -f "$dbconfig/$file" ]
          then mv "$filename" "$dbconfig"/ 2>/dev/null
          fi
          # If the file exists in the configuration directory, and it's
          # not linked from the expected location, create the link.
            if [ -f "$dbconfig/$file" ] && [ ! -L "$filename" ]
          then ln -sf "$dbconfig"/"$file" "$filename" 2>/dev/null
          fi
     done

     # Start this database:
     echo "startup" | "${ORACLE_HOME}"/bin/sqlplus / as sysdba
done
