#!/bin/bash

JUDGES_DIR="/var/lib/ejudge"
EJUDGE_BIN_DIR="/usr/bin"
EJUDGE_INST_PATH="/usr"
EJUDGE_UID="vasalf"
MYSQL_USER="ejudge"
MYSQL_PASSWD="ejudge"
MYSQL_DB_NAME="ejudge"


echo ""
echo "Setting ejudge down"
echo ""
sudo -u $EJUDGE_UID $EJUDGE_BIN_DIR/ejudge-control stop
if [ $? -ne 0 ]; then
    echo ""
    echo "An error occured, ejudge was not restored."
    exit 1
fi
echo ""
echo "Ejudge was successfuly set down."
echo ""

echo "Unpacking .tar.gz ejudge image (with verbose)"
echo ""
sleep 2
tar -xvzf $1
if [ $? -ne 0 ]; then
    echo ""
    echo "An error occured, ejudge was not restored."
    exit 1
fi
echo ""
echo "Image unpacked."
echo ""

cd ejudge

echo "Updating MySQL database"
echo ""
mysql -u $MYSQL_USER -p$MYSQL_PASSWD $MYSQL_DB_NAME <ejudge-db.sql
if [ $? -ne 0 ]; then
    echo ""
    echo "An error occured, ejudge was not restored."
    exit 1
fi
echo ""
echo "MySQL updated."
echo ""

echo "Cleaning judges dir"
echo ""
rm -Rf $JUDGES_DIR
mkdir -p $JUDGES_DIR
echo ""
echo "Judges dir cleaned."
echo ""

echo "Copying judges dir (with verbose)"
echo ""
sleep 2
mv -vf judges/* $JUDGES_DIR/
if [ $? -ne 0 ]; then
    echo ""
    echo "An error occured, ejudge was not restored."
    exit 1
fi
chown -R ejudge:ejudge $JUDGES_DIR $EJUDGE_INST_PATH
echo ""
echo "Judges dir successfully copied"
echo ""

echo "Removing temporaly directory"
echo ""
cd ..
rm -Rf ejudge
echo ""
echo "Temporaly directory removed."
echo ""

echo "OK, ejudge was restored."
