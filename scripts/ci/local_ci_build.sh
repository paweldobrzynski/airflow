#!/usr/bin/env bash

#
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing,
#  software distributed under the License is distributed on an
#  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#  KIND, either express or implied.  See the License for the
#  specific language governing permissions and limitations
#  under the License.

set -xeuo pipefail
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export RUN_TESTS="false"
export MOUNT_LOCAL_SOURCES="true"
export PYTHON_VERSION=${PYTHON_VERSION:="3.6"}

export PYTHON_VERSION=${PYTHON_VERSION:=$(python -c 'import sys; print("%s.%s" % (sys.version_info.major, sys.version_info.minor))')}
AIRFLOW_VERSION=$(cat airflow/version.py - << EOF | python
print(version.replace("+",""))
EOF
)
export AIRFLOW_VERSION

export DOCKERHUB_USER=${DOCKERHUB_USER:="apache"}
export DOCKERHUB_REPO=${DOCKERHUB_REPO:="airflow"}
export AIRFLOW_CI_VERBOSE="false"
export AIRFLOW_CONTAINER_PUSH_IMAGES="false"
export AIRFLOW_CONTAINER_CI_OPTIMISED_BUILD="true"

 ./hooks/build
