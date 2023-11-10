# Reference: https://mikedietrichde.com/2017/07/31/oracle-text-context-clean-oracle-database-11-2-12-2
sqlplus / as sysdba << EOF
@${ORACLE_HOME}/ctx/admin/catnoctx.sql
drop procedure sys.validate_context;
drop package xdb.dbms_xdbt;
drop procedure xdb.xdb_datastore_proc;
@${ORACLE_HOME}/rdbms/admin/utlrp.sql
EOF
