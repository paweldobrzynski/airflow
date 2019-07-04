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

export AIRFLOW_CONTAINER_SKIP_SLIM_CI_IMAGE="false"
export AIRFLOW_CONTAINER_SKIP_CI_IMAGE="true"
if [[ -f "${BUILD_CACHE_DIR}/.use_locally_built_images_as_cache_3.6" ]]; then
    echo
    echo "Images built locally - skip pulling them"
    echo
    export AIRFLOW_CONTAINER_FORCE_PULL_IMAGES="false"
else
    echo
    echo "Images not built locally - force pulling them first"
    echo
    export AIRFLOW_CONTAINER_FORCE_PULL_IMAGES="true"
fi
export AIRFLOW_CONTAINER_PUSH_IMAGES="false"
export AIRFLOW_CONTAINER_BUILD_NPM="false"

DOCKER_BUILD_NEEDED="false"

check_if_docker_build_is_needed

if [[ "${DOCKER_BUILD_NEEDED}" == "true" ]]; then
    echo
    echo "Rebuilding image"
    echo
    # shellcheck source=../../hooks/build
    ./hooks/build | tee -a "${OUTPUT_LOG}" >&4 2>&5
    update_all_md5_files
    echo
    echo "Image rebuilt"
    echo
else
    echo
    echo "No need to rebuild the image as none of the sensitive files changed: ${FILES_FOR_REBUILD_CHECK}"
    echo
fi

AIRFLOW_SLIM_CI_IMAGE=$(cat "${BUILD_CACHE_DIR}/.AIRFLOW_SLIM_CI_IMAGE")
export AIRFLOW_SLIM_CI_IMAGE
