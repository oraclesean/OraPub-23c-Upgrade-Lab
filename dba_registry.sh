  if [ "$($ORACLE_HOME/bin/sqlplus -V | grep Release | sed -E 's/^.*Release ([0-9]{2})\..*$/\1/')" -gt 12 ]
then __version=", version_full"
else __version=""
fi

sqlplus / as sysdba << EOF
col comp_name for a40
select comp_name, version${__version}, status from dba_registry;
EOF
