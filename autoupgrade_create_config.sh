# Create an autoupgrade configuration file based on version

mkdir -p $DATA/autoupgrade
rm -fr $DATA/autoupgrade/*

  if [ -f "$DATA/autoupgrade/config.txt" ]
then mv $DATA/autoupgrade/config.txt $DATA/autoupgrade/config.txt.$(date '+%Y%m%d%H%M')
fi

cat << EOF > $DATA/autoupgrade/config.txt
# Global parameters
global.autoupg_log_dir=$DATA/autoupgrade
global.raise_compatible=yes
global.drop_grp_after_upgrade=yes
global.remove_underscore_parameters=yes

# Common database parameters
upg.upgrade_node=localhost
upg.source_home=$ORACLE_HOME
upg.sid=$ORACLE_SID
upg.start_time=now
upg.run_utlrp=yes
upg.timezone_upg=yes

EOF

  if [ -d "$ORACLE_19C_HOME" ]
then cat << EOF >> $DATA/autoupgrade/config.txt
# Database parameters - 19c upgrade
upg.target_home=$ORACLE_19C_HOME
upg.target_version=19
EOF

elif [ -d "$ORACLE_23AI_HOME" ]
then cat << EOF >> $DATA/autoupgrade/config.txt
# Database parameters - 23ai upgrade
upg.target_home=$ORACLE_23AI_HOME
upg.target_cdb=${ORACLE_SID}CDB
upg.target_pdb_name=${ORACLE_SID}
upg.target_version=23.5
upg.target_pdb_copy_option=file_name_convert=NONE
EOF
else echo "An upgrade home is not present"
fi
