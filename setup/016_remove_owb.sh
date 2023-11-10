# Reference: https://mikedietrichde.com/2017/08/03/oracle-warehouse-builder-owb-clean-oracle-database-11-2-12-2

# Skip this script on 12c
  if [[ $ORACLE_VERSION =~ ^11 ]]
then sqlplus / as sysdba << EOF
@${ORACLE_HOME}/owb/UnifiedRepos/clean_owbsys.sql
drop package sys.dbms_owb;
EOF
fi
