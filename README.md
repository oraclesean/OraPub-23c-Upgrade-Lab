# OraPub-23c-Upgrade-Lab
These scripts accompany the November 8, 2023 OraPub 23c Upgrade LVC. They're designed to automate and accelerate parts of the hands-on labs to aid students in working through an upgrade.

## Navigating the Lab
The lab environments run as Docker containers on VMs. We're using containers because they allow much faster setup of the databases, and can be quickly reverted to their original state.

Each lab includes three host containers:
* UPGRADE11: This host is running Oracle Enterprise Linux 7, and runs an Oracle 11.2.0.4 database with a database name of ORCL, plus a pre-installed Oracle 19.21 home.
* UPGRADE12: This host is running Oracle Enterprise Linux 7, and runs an Oracle 12.1.0.2 database with a database name of ORCL, plus a pre-installed Oracle 19.21 home.
* UPGRADE19: This host is running Oracle Enterprise Linux 8, and has two running Oracle databases. First, an Oracle 19.21 non-CDB database with a database name of ORCL. Second, an Oracle 23.3 CDB database with a database name of ORCLCDB and a single, pluggable database (PDB).

Log into the VM, then `sudo` to the `oracle` user:
```
su -u oracle /bin/bash
cd /home/oracle
```
This brings up a status screen showing the running lab hosts and their names:
```
Images present on the system:
REPOSITORY                           TAG       IMAGE ID       CREATED      SIZE
sjc.ocir.io/axmkfxakqxcq/oracle/db   11-19     7b73c71ccbad   4 days ago   13.4GB
sjc.ocir.io/axmkfxakqxcq/oracle/db   12-19     9aa7078bc1ad   4 days ago   14.6GB
sjc.ocir.io/axmkfxakqxcq/oracle/db   19-23     c9f288234dbd   4 days ago   15.8GB

Active database hosts:
NAMES         IMAGE                                      PORTS                          STATUS
UPGRADE11ss   sjc.ocir.io/axmkfxakqxcq/oracle/db:11-19   1521/tcp, 5500/tcp, 8080/tcp   Up 2 days (healthy)
UPGRADE12ss   sjc.ocir.io/axmkfxakqxcq/oracle/db:12-19   1521/tcp, 5500/tcp, 8080/tcp   Up 2 days (healthy)
UPGRADE19ss   sjc.ocir.io/axmkfxakqxcq/oracle/db:19-23   1521/tcp, 5500/tcp, 8080/tcp   Up 2 days (healthy)

To start a database, run:
    start11           - Starts an OEL7 host with an Oracle 11g database and Oracle 19c home
    start12           - Starts an OEL7 host with an Oracle 12c database and Oracle 19c home
    start19           - Starts an OEL8 host with Oracle 19c and Oracle 23c databases

                          11g             12c             19c
Refresh the database:     refresh11       refresh12       refresh19
View database logs:       logs11          logs12          logs19
Login to the host:        login11         login12         login19
```
Each student will have their own database on the lab, identified by your initials. For example, `UPGRADE11ss` is the 11g upgrade environment for user `ss`.

To log into one of the labs, use the appropriate `login` command:
* `login11`: Log into your 11g environment.
* `login12`: Log into your 12c environment.
* `login19`: Log into your 19c/23c environment.

These scripts recognize your username and log you into your assigned host, even if there are multiple labs running on the system.

Once logged into a host, navigate the system as you would any Linux machine. Type `exit` from the command line to return to the main VM.

If you want to start over with any lab, execute the appropriate `refresh` command:
* `refresh11`: Restore the 11g lab.
* `refresh12`: Restore the 12c lab.
* `refresh19`: Restore the 19c lab.

This will take a few minutes as Gold Images of the database are restored from the `/oradata/backups` directory and the container is restarted.

## Understanding the Lab Scripts
The contents of this repository are mounted in the containers under the `/scripts/` directory:
```
[oracle - ORCL] ~
# ls -l /scripts
total 6136
-rwxr-xr-x. 1 oracle oinstall     647 Nov  8 10:05 190_update_env_19c.sh
-rwxr-xr-x. 1 oracle oinstall     899 Nov  7 17:52 200_create_23c_dbca_responsefile.sh
-rwxr-xr-x. 1 oracle oinstall     835 Nov  8 10:05 290_update_env_23c.sh
-rwxr-xr-x. 1 oracle oinstall     498 Nov  8 03:13 390_update_env_23c.sh
-rw-r--r--. 1 oracle oinstall 6224437 Nov  7 17:52 autoupgrade.jar
-rwxr-xr-x. 1 oracle oinstall     842 Nov  8 02:13 autoupgrade_analyze.sh
-rwxr-xr-x. 1 oracle oinstall    1139 Nov  7 17:52 autoupgrade_create_config.sh
-rwxr-xr-x. 1 oracle oinstall     887 Nov  8 02:08 autoupgrade_deploy.sh
-rwxr-xr-x. 1 oracle oinstall     254 Nov  7 17:52 autoupgrade_monitor.sh
-rwxr-xr-x. 1 oracle oinstall     593 Nov  7 17:52 backup_step.sh
-rwxr-xr-x. 1 oracle oinstall     894 Nov  7 17:52 copy_configurations.sh
-rwxr-xr-x. 1 oracle oinstall     280 Nov  7 17:52 dba_registry.sh
-rwxr-xr-x. 1 oracle oinstall     593 Nov  7 17:52 dblogin
-rwxr-xr-x. 1 oracle oinstall    1080 Nov  7 17:52 refresh_container.sh
drwxr-xr-x. 2 oracle oinstall    4096 Nov  7 19:32 setup
drwxr-xr-x. 2 oracle oinstall      33 Nov  8 10:49 startup
```

To save time, each database to be upgraded was prepared using the scripts under the `setup` directory. This includes removing obsolete/deprecated components (APEX, etc) using Oracle-recommended methods, setting minimum environment variables and configurations, and performing some recommended pre-upgrade steps like gathering statistics and purging the recycle bin. The `startup` directory includes automation for starting the Oracle 23c database in the 19c to 23c upgrade lab.

The remaining scripts are shortcuts for performing various upgrade actions. The ones you should take note of for the lab are:
* `autoupgrade_create_config.sh`: Automatically create an autoupgrade configuration file based on the current database version.
* `autoupgrade_analyze.sh`: Perform an `autoupgrade ... analyze` of a database.
* `autoupgrade_deploy.sh`: Runs `autoupgrade ... deploy` to upgrade a database.
* `dba_registry.sh`: Displays the contents of the `DBA_REGISTRY` table to show the version and status of database components.

NOTE: Do not modify, delete, or create files under the `/scripts` directory!

## Performing an Upgrade
When upgrading to 19c (from either an 11g or 12c database) you will use the `autoupgrade.jar` file located in this directory. It's the latest version, downloaded from MOS. However, this version is not certified for 23c targets, so when upgrading from 19c to 23c, you'll use the `autoupgrade.jar` located in the Oracle 23c home directory: `/u01/app/oracle/product/23.3/dbhome_1/rdbms/admin`.

### Create a Configuration File
To upgrade a database, first create a configuration file. You can do this automatically by running `/scripts/autoupgrade_create_config.sh`, or do so manually by creating the configuration file inside the lab container.

### Analyze the Database
Run `/scripts/autoupgrade_analyze.sh`, or run `autoupgrade` manually. Use the `java` binary in the target database home (these are set as environment variables for your convenience: `$ORACLE_19C_HOME` in the 11g/12c labs, and `$ORACLE_23C_HOME` in the 23c lab) and call the correct version of `autoupgrade`. Reference the location of the configuration file, and set the `-mode analyze` flag:
```
$ORACLE_19C_HOME/jdk/bin/java -jar /scripts/autoupgrade.jar -config /u02/app/oracle/oradata/autoupgrade/config.txt -mode analyze
```

Review the output and check the logs. If there are any errors, correct them and re-run the analysis.

### Upgrade the Database
Run `/scripts/autoupgrade_deploy.sh`, or run `autoupgrade` manually, using the `-mode deploy` flag:
```
$ORACLE_19C_HOME/jdk/bin/java -jar /scripts/autoupgrade.jar -config /u02/app/oracle/oradata/autoupgrade/config.txt -mode deploy
```

From the autoupgrade prompt, type `help` to see a list of available commands. You can log into the lab through a second session and tail the log output to get a detailed view of the upgrade progress, or run the `status` command to see progress. To refresh the output every 30 seconds, run `status -a 30`.
