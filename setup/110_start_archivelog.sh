sqlplus / as sysdba << EOF
shutdown immediate
startup mount
alter database archivelog;
shutdown immediate
startup
archive log list
EOF
