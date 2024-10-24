# Reference: https://mikedietrichde.com/2017/07/28/oracle-workspace-manager-owm-clean-oracle-database-11-2-19c

# Do not run for version 23:
  if [[ ! $ORACLE_VERSION =~ ^23 ]]
then sqlplus / as sysdba << EOF
@${ORACLE_HOME}/rdbms/admin/owmuinst.plb
EOF
fi
