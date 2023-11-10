# Reference: https://mikedietrichde.com/2017/08/02/oracle-olap-xoq-aps-amd-clean-oracle-database-11-2-12-2
sqlplus / as sysdba << EOF
@${ORACLE_HOME}/olap/admin/olapidrp.plb
@${ORACLE_HOME}/olap/admin/catnoxoq.sql
@${ORACLE_HOME}/rdbms/admin/utlrp.sql
shutdown immediate
EOF

chopt disable olap

sqlplus / as sysdba << EOF
startup
@${ORACLE_HOME}/olap/admin/catnoaps.sql
@${ORACLE_HOME}/rdbms/admin/utlrp.sql
@${ORACLE_HOME}/olap/admin/catnoamd.sql
EOF
