# Reference: https://mikedietrichde.com/2017/07/30/oracle-spatial-sdo-clean-oracle-database-11-2-12-2
sqlplus / as sysdba << EOF
REM Stop, restart the database:
shutdown immediate
startup restrict
drop user mdsys cascade;

REM drop user mdsys cascade will probably fail the first time.
REM Do it again:
shutdown immediate
startup restrict
drop user mdsys cascade;

REM Drop public synonyms
begin
  for v in (select synonym_name from dba_synonyms where table_owner='MDSYS')
  loop execute immediate 'drop public synonym "' || v.synonym_name || '"';
  end loop;
end;
/

REM Drop other users:
drop user mddata cascade;
drop user spatial_csw_admin_usr cascade;
drop user spatial_wfs_admin_usr cascade;
EOF

# Reference: https://mikedietrichde.com/2017/08/01/oracle-multimedia-ordim-clean-oracle-database-11-2-12-2
echo Y | sqlplus / as sysdba @${ORACLE_HOME}/rdbms/admin/catcmprm.sql ORDIM

sqlplus / as sysdba << EOF
REM For 19c
@${ORACLE_HOME}/md/admin/semremov.sql
drop package SYS.ORDIMDPCALLOUTS;
@${ORACLE_HOME}/rdbms/admin/utlrp.sql
EOF
