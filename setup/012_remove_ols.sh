# Reference: https://mikedietrichde.com/2017/07/29/oracle-label-security-ols-clean-oracle-database-11-2-12-2

# Run only for version 11
  if [[ $ORACLE_VERSION =~ ^11 ]] 
then sqlplus / as sysdba << EOF
@${ORACLE_HOME}/rdbms/admin/catnools.sql
@${ORACLE_HOME}/rdbms/admin/utlrp.sql
shutdown immediate
EOF

chopt disable lbac

sqlplus / as sysdba << EOF
startup
EOF
fi
