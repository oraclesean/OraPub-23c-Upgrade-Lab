sqlplus / as sysdba << EOF
REM Set the passwords:
alter user sys identified by oracle;
alter user system identified by oracle;

REM Remove any control files that are not in the DATA or RECO paths:
/*
  declare
          v_cf varchar2(2000);
    begin
            select listagg('''' || name || '''', ',') within group (order by name asc)
              into v_cf
              from v\$controlfile
             where name like '$DATA/%' or name like '$RECO/%';
          execute immediate 'alter system set control_files=' || v_cf || ' scope=spfile';
      end;
/
*/

alter system set db_recovery_file_dest='$RECO' scope=both;

REM Meet autoupgrade prerequisites:
alter system set db_recovery_file_dest_size=10g scope=both;
alter system set sga_target=1002438656 scope=spfile;
alter system set processes=300 scope=spfile;
alter system reset local_listener;

REM Avoid invalid Java JVM component:
alter system set java_jit_enabled=false scope=both;

REM Avoid UPG-1316 error during autoupgrade time zone upgrade
REM (ERROR Dispatcher failed: AutoUpgException [UPG-1316]):
alter system set parallel_max_servers=16 scope=both;

REM Add larger logfile groups:
    begin
      for i in 11..15
     loop execute immediate 'alter database add logfile group ' || i || ' size 200m';
 end loop;
      end;
/

REM Drop original logfile groups:
    begin
      for i in (select group#, status from v\$log where group# in (1,2,3) order by status desc)
     loop
             if i.status = 'INACTIVE'
           then execute immediate 'alter database drop logfile group ' || i.group#;
           else execute immediate 'alter system checkpoint';
                execute immediate 'alter system switch logfile';
                execute immediate 'alter system switch logfile';
                execute immediate 'alter database drop logfile group ' || i.group#;
         end if;
 end loop;
      end;
/

REM Perform a second pass at logfile group removal, in case something remains:
    begin
      for i in (select group#, status from v\$log where group# in (1,2,3) order by status desc)
     loop
             if i.status = 'INACTIVE'
           then execute immediate 'alter database drop logfile group ' || i.group#;
           else execute immediate 'alter system checkpoint';
                execute immediate 'alter system switch logfile';
                execute immediate 'alter system switch logfile';
                execute immediate 'alter database drop logfile group ' || i.group#;
         end if;
 end loop;
      end;
/
EOF

!rm $DATA/$ORACLE_SID/redo*.log 2>/dev/null
!rm $RECO/$ORACLE_SID/onlinelog/*.log 2>/dev/null

  if [[ $ORACLE_VERSION =~ ^2 ]]
then sqlplus / as sysdba << EOF
REM Resize datafiles to avoid waiting on autoextend:
alter database datafile 1 resize 1500m;
alter database tempfile 1 resize 250m;
alter database datafile 3 resize 1000m;
alter database datafile 4 resize 410m;
EOF
fi
