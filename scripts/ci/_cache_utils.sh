#!/usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

AIRFLOW_SOURCES=$(pwd)
export AIRFLOW_SOURCES

BUILD_CACHE_DIR="${AIRFLOW_SOURCES}/.build"
mkdir -p "${BUILD_CACHE_DIR}/cache/"

USE_LOCALLY_BUILD_IMAGES_AS_CACHE="${BUILD_CACHE_DIR}/.use_locally_built_images_as_cache_${PYTHON_VERSION}"
CACHE_TMP_FILE_DIR=$(mktemp -d "${BUILD_CACHE_DIR}/cache/XXXXXXXXXX")

if [[ ${SKIP_CACHE_DELETION:=} != "true" ]]; then
    trap 'rm -rf -- "${CACHE_TMP_FILE_DIR}"' INT TERM HUP EXIT
fi

function check_file_md5sum {
    local FILE="${1}"
    local MD5SUM
    MD5SUM=$(md5sum "${FILE}")
    local MD5SUM_FILE
    MD5SUM_FILE=${BUILD_CACHE_DIR}/$(basename "${FILE}").md5sum
    local MD5SUM_FILE_NEW
    MD5SUM_FILE_NEW=${CACHE_TMP_FILE_DIR}/$(basename "${FILE}").md5sum.new
    echo "${MD5SUM}" > "${MD5SUM_FILE_NEW}"
    local RET_CODE=0
    if [[ ! -f "${MD5SUM_FILE}" ]]; then
        echo "Missing md5sum for ${FILE}"
        RET_CODE=1
    else
        diff "${MD5SUM_FILE_NEW}" "${MD5SUM_FILE}" >/dev/null
        RES=$?
        if [[ "${RES}" != "0" ]]; then
            echo "The md5sum changed for ${FILE}"
            RET_CODE=1
        fi
    fi
    return ${RET_CODE}
}

function move_file_md5sum {
    local FILE="${1}"
    local MD5SUM_FILE
    MD5SUM_FILE=${BUILD_CACHE_DIR}/$(basename "${FILE}").md5sum
    local MD5SUM_FILE_NEW
    MD5SUM_FILE_NEW=${CACHE_TMP_FILE_DIR}/$(basename "${FILE}").md5sum.new
    if [[ -f "${MD5SUM_FILE_NEW}" ]]; then
        mv "${MD5SUM_FILE_NEW}" "${MD5SUM_FILE}"
        echo "Updated md5sum file ${MD5SUM_FILE} for ${FILE}."
    fi
}

FILES_FOR_REBUILD_CHECK="\
setup.py \
setup.cfg \
Dockerfile \
airflow/version.py \
airflow/www/package.json \
airflow/www/package-lock.json
"

function update_all_md5_files() {
    # Record that we built the images locally so that next time we use "standard" cache
    touch "${USE_LOCALLY_BUILD_IMAGES_AS_CACHE}"
    echo
    echo "Updating md5sum files"
    echo
    for FILE in ${FILES_FOR_REBUILD_CHECK}
    do
        move_file_md5sum "${AIRFLOW_SOURCES}/${FILE}"
    done
}

function check_if_docker_build_is_needed() {
    set +e

    for FILE in ${FILES_FOR_REBUILD_CHECK}
    do
        check_file_md5sum "${AIRFLOW_SOURCES}/${FILE}"
        RES=$?
        if [[ "${RES}" != "0" ]]; then
            # shellcheck disable=SC2034
            DOCKER_BUILD_NEEDED="true"
        fi
    done
    set -e
}
