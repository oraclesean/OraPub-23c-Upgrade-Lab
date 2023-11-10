sqlplus / as sysdba << EOF
exec dbms_aqadm.drop_queue_table(queue_table => 'SYS.KUPC$DATAPUMP_QUETAB', force => TRUE);
EOF
