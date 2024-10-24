# Reference: https://mikedietrichde.com/2017/07/27/oracle-apex-clean-up-oracle-database-11-2-12-2

# Do not run for version 23:
  if [[ $ORACLE_VERSION =~ ^23 ]]
then echo 1 > /dev/null
elif [[ $ORACLE_VERSION =~ ^1[1-2] ]]
then sqlplus / as sysdba << EOF
@$ORACLE_HOME/apex/apxremov.sql

REM Only required in 11g:
drop package sys.htmldb_system;
drop public synonym htmldb_system;

REM Only required in 12.1:
drop public synonym apex_spatial;
drop public synonym apex_pkg_app_install_log;
EOF
fi
