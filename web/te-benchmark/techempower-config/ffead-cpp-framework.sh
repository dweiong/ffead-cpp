#!/bin/bash

fw_installed ffead-cpp-framework && return 0

fw_get -o ffead-cpp-src.zip https://github.com/sumeetchhetri/ffead-cpp/archive/master.zip
unzip ffead-cpp-src.zip
cd ffead-cpp-src/
./autogen.sh
./configure --enable-apachemod=yes --enable-mod_sdormmongo=yes --enable-mod_sdormsql=yes CPPFLAGS="$CPPFLAGS -I${IROOT}/include/libmongoc-1.0 -I${IROOT}/include/libbson-1.0 -I${IROOT}/include/" LDFLAGS="$LDFLAGS -L${IROOT}"
make install
rm -rf web/default web/oauthApp web/flexApp web/markers
rm -rf ${IROOT}/ffead-cpp-2.0
cp -rf ffead-cpp-2.0-bin ${IROOT}/ffead-cpp-2.0

sed -i 's|localhost|'${DBHOST}'|g' web/te-benchmark/config/sdorm.xml
sed -i 's|localhost|'${DBHOST}'|g' web/te-benchmark/config/sdormmongo.xml
sed -i 's|localhost|'${DBHOST}'|g' web/te-benchmark/config/sdormmysql.xml
sed -i 's|localhost|'${DBHOST}'|g' web/te-benchmark/config/sdormpostgresql.xml
sed -i 's|localhost|'${DBHOST}'|g' resources/sample-odbcinst.ini
sed -i 's|localhost|'${DBHOST}'|g' resources/sample-odbc.ini

cp resources/sample-odbcinst.ini ${IROOT}/odbcinst.ini
cp resources/sample-odbc.ini ${IROOT}/odbc.ini

cd ${IROOT}

touch ${IROOT}/ffead-cpp-framework.installed