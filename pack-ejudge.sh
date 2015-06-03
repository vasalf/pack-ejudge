#!/bin/bash

JUDGES_DIR="/var/lib/ejudge"
EJUDGE_BIN_DIR="/usr/bin"
EJUDGE_INST_PATH="/usr"
EJUDGE_UID="vasalf"
MYSQL_USER="ejudge"
MYSQL_PASSWD="ejudge"
MYSQL_DB_NAME="ejudge"


mkdir ejudge

echo ""
echo "Copying judges dir (with verbose)"
echo ""
sleep 2
cp -vRf $JUDGES_DIR ejudge/
if [ $? -ne 0 ]; then
    echo ""
    echo "An error occured, ejudge was not restored."
    exit 1
fi
echo ""
echo "Judges dir copied."
echo ""

echo "Dumping MySQL database"
echo ""
mysqldump -u $MYSQL_USER -p$MYSQL_PASSWD $MYSQL_DB_NAME >ejudge/ejudge-db.sql
if [ $? -ne 0 ]; then
    echo ""
    echo "An error occured, ejudge was not restored."
    exit 1
fi
cat ejudge/ejudge-db.sql
echo "" 
echo "MySQL database dumped."
echo ""

echo "Compressing ejudge image (with verbose)"
echo ""
sleep 2
tar -cvzf $1 ejudge
if [ $? -ne 0 ]; then
    echo ""
    echo "An error occured, ejudge was not restored."
    exit 1
fi
rm -Rf ejudge/
echo ""
echo "OK, ejudge image was created."
