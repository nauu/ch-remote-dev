#ssh root@localhost -p 2222
#ssh root@localhost -p 6666

#cmake
/usr/bin/cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_MAKE_PROGRAM=/usr/bin/ninja -DCMAKE_C_COMPILER=clang-18 -DCMAKE_CXX_COMPILER=clang++-18 -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON -G Ninja -S /home/ch-builder/clickhouse -B /home/ch-builder/clickhouse/cmake-build-debug-ch-docker

#How to build
/usr/bin/cmake --build /home/ch-builder/clickhouse/cmake-build-debug-ch-docker --target clickhouse-server -j 12 



#How to start a server
cd /home/ch-builder/clickhouse/cmake-build-debug-ch-docker/programs && \
./clickhouse server --config-file /home/ch-builder/clickhouse/programs/server/config.xml

#How to run a client
cd /home/ch-builder/clickhouse/cmake-build-debug-ch-docker/programs && \
./clickhouse client


#How to run integration test
# build clickhouse-library-bridge and clickhouse-odbc-bridge
#in host
#cd /Users/nauu/CLionProjects/clickhouse-private/tests/integration/
#or  /Users/nauu/CLionProjects/clickhouse-private/tests/integration/runner
cd /Users/nauu/CLionProjects/ClickHouse/tests/integration/ && \
export CLICKHOUSE_TESTS_BASE_CONFIG_DIR=/Users/nauu/CLionProjects/clickhouse-private/programs/server/ && \
export CLICKHOUSE_TESTS_SERVER_BIN_PATH=/Users/nauu/CLionProjects/clickhouse-private/cmake-build-debug-ch-docker/programs/clickhouse && \
export CLICKHOUSE_TESTS_ODBC_BRIDGE_BIN_PATH=/Users/nauu/CLionProjects/clickhouse-private/cmake-build-debug-ch-docker/programs/ && \
./runner --ignore-iptables-legacy-check 'test_packed_io' 

cd /Users/nauu/CLionProjects/ClickHouse/tests/integration/ && \
export CLICKHOUSE_TESTS_BASE_CONFIG_DIR=/Users/nauu/CLionProjects/ClickHouse/programs/server/ && \
export CLICKHOUSE_TESTS_SERVER_BIN_PATH=/Users/nauu/CLionProjects/ClickHouse/cmake-build-debug-ch-docker/programs/clickhouse && \
export CLICKHOUSE_TESTS_ODBC_BRIDGE_BIN_PATH=/Users/nauu/CLionProjects/ClickHouse/cmake-build-debug-ch-docker/programs/ && \
./runner --ignore-iptables-legacy-check 'test_backup_restore_on_cluster'

#How to run a single test
cd /Users/nauu/CLionProjects/ClickHouse/tests/integration/ && \
export CLICKHOUSE_TESTS_BASE_CONFIG_DIR=/Users/nauu/CLionProjects/ClickHouse/programs/server/ && \
export CLICKHOUSE_TESTS_SERVER_BIN_PATH=/Users/nauu/CLionProjects/ClickHouse/cmake-build-debug-ch-docker/programs/clickhouse && \
export CLICKHOUSE_TESTS_ODBC_BRIDGE_BIN_PATH=/Users/nauu/CLionProjects/ClickHouse/cmake-build-debug-ch-docker/programs/ && \
./runner --ignore-iptables-legacy-check 'test_backup_restore_on_cluster/test_cancel_backup.py::test_cancel_restore' 'test_backup_restore_on_cluster/test_cancel_backup.py::test_shutdown_cancels_backup'

test_shutdown_cancels_backup
test_backup_restore_on_cluster

#How to run unitest
#build clickhouse-test
#in container
/home/ch-builder/clickhouse/cmake-build-debug-ch-docker/src/unit_tests_dbms --gtest_filter=LocalAddress*

/home/ch-builder/clickhouse/cmake-build-debug-ch-docker/src/unit_tests_dbms --gtest_filter=S3UriTest*


#How to run stateless test
#in container
ssh root@localhost -p 6666
ssh root@localhost -p 2222

#start a server
cd /home/ch-builder/clickhouse/cmake-build-debug-ch-docker/programs && \
./clickhouse server --config-file /home/ch-builder/clickhouse/programs/server/config.xml

#run stateless test
export PATH=/home/ch-builder/clickhouse/cmake-build-debug-ch-docker/programs/:$PATH && \
/home/ch-builder/clickhouse/tests/clickhouse-test  00036_array_element 00049_any_left_join
