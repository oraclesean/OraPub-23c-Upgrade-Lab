# Do not run for version 23:
  if [[ ! $ORACLE_VERSION =~ ^23 ]]
then sqlplus / as sysdba << EOF
--exec dbms_aqadm.drop_queue_table(queue_table => 'SYS.KUPC$DATAPUMP_QUETAB', force => TRUE);

alter session set "_ORACLE_SCRIPT" = true;

VARIABLE catnodpaq_summary VARCHAR2(500)
COLUMN   catnodpaq_summary format a79

DECLARE
  v_drop_cnt  NUMBER := 0;
  v_error_cnt NUMBER := 0;
  v_sqlerrm   VARCHAR2(200);
  v_qtname    VARCHAR2(128);
  CURSOR c1 IS SELECT table_name FROM dba_tables WHERE
    owner = 'SYS' AND table_name LIKE 'KUPC$DATAPUMP_QUETAB%';

  FUNCTION final_summary
  RETURN VARCHAR2
  IS
    -- 500 characters is more than enough as final message length is
    -- 18 + (13 + max of 11) + (10 + max of 11) + 14 + 200[sqlerrm] = 277
    --
    l_sum     VARCHAR2(500) := 'dropping AQ table';                       -- 18
  BEGIN
    IF (v_drop_cnt + v_error_cnt) != 1 THEN
      l_sum := l_sum || 's';
    END IF;

    IF (v_drop_cnt + v_error_cnt) = 0 THEN                 -- no tables dropped
      RETURN l_sum || ': NONE found';
    END IF;

    l_sum := l_sum  ||                                       -- list # suc/fail
      ': success(' || v_drop_cnt  || '),' ||      -- 13 + #digits in v_drop_cnt
       ' failure(' || v_error_cnt || ')';        -- 10 + #digits in v_error_cnt

    IF v_sqlerrm IS NOT NULL THEN                      -- display last errormsg
      l_sum := l_sum || ', last error:' || CHR(10) || v_sqlerrm;   -- 14 + errm
    END IF;
    RETURN l_sum;
  END;
BEGIN
  OPEN c1;
  LOOP
    FETCH c1 INTO v_qtname;
    EXIT WHEN c1%NOTFOUND;               -- Exit when no more queue table names

    --
    -- For every Data Pump AQ table found, try to drop it.
    --
    BEGIN
      dbms_aqadm.drop_queue_table(queue_table => 'SYS.' || v_qtname,
                                  force       => TRUE);
      v_drop_cnt := v_drop_cnt + 1;                                  -- Success
    EXCEPTION
      WHEN OTHERS THEN
        IF SQLCODE != -24002 THEN   -- Ignore QUERY_TABLE <name> does not exist
          v_error_cnt := v_error_cnt + 1;                            -- Failure
          -- Remember the last unexpected error. Make sure it fits in variable.
          v_sqlerrm := SUBSTR(SQLERRM, 1, 200);
        END IF;
    END;
  END LOOP;
  CLOSE c1;
  :catnodpaq_summary := final_summary;
END;
/
PRINT :catnodpaq_summary
alter session set "_ORACLE_SCRIPT" = false;
EOF
fi
