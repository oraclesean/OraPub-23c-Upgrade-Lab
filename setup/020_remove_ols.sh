  if [[ "$ORACLE_VERSION" =~ ^12 ]]
then sqlplus / as sysdba << EOF
@?/rdbms/admin/catols.sql
exec lbacsys.configure_ols
exec lbacsys.ols_enforcement.enable_ols
shutdown immediate
startup
@$ORACLE_HOME/rdbms/admin/catmac.sql system temp oracle
EOF
fi
