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

AIRFLOW_MOUNT_HOST_VOLUMES_FOR_STATIC_CHECKS=${AIRFLOW_MOUNT_HOST_VOLUMES_FOR_STATIC_CHECKS:="true"}

declare -a MOUNTED_VOLUMES_FOR_STATIC_CHECKS
if [[ ${AIRFLOW_MOUNT_HOST_VOLUMES_FOR_STATIC_CHECKS} == "true" ]]; then
    echo
    echo "Mounting host volumes to Docker"
    echo
    MOUNTED_VOLUMES_FOR_STATIC_CHECKS=( \
      "-v" "${AIRFLOW_SOURCES}/airflow:/opt/airflow/airflow" \
      "-v" "${AIRFLOW_SOURCES}/dev:/opt/airflow/dev" \
      "-v" "${AIRFLOW_SOURCES}/docs:/opt/airflow/docs" \
      "-v" "${AIRFLOW_SOURCES}/scripts:/opt/airflow/scripts" \
      "-v" "${AIRFLOW_SOURCES}/tests:/opt/airflow/tests" \
      "-v" "${AIRFLOW_SOURCES}/.flake8:/opt/airflow/.flake8" \
      "-v" "${AIRFLOW_SOURCES}/setup.cfg:/opt/airflow/setup.cfg" \
      "-v" "${AIRFLOW_SOURCES}/setup.py:/opt/airflow/setup.py" \
      "-t"
    )
else
    echo
    echo "Skip mounting host volumes to Docker"
    echo
    MOUNTED_VOLUMES_FOR_STATIC_CHECKS=("-t")
fi

export MOUNTED_VOLUMES_FOR_STATIC_CHECKS
