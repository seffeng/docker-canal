#!/bin/bash

init_config() {
    if [ ! -f ${BASE_DIR}/config/${CANAL_NAME}/logback.xml ]; then
        cd ${BASE_DIR}/tmp
        tar -zxf ${BASE_DIR}/tmp/conf.tar.gz
        mv conf/* -f ${BASE_DIR}/config/${CANAL_NAME}/
    fi
    rm -rf ${BASE_DIR}/tmp/*
}

init_config

exec "$@"