#!/usr/bin/env bash

#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
set -euo pipefail

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd "${MY_DIR}/../../" || exit 1

export AIRFLOW_CONTAINER_SKIP_SLIM_CI_IMAGE="false"
export AIRFLOW_CONTAINER_SKIP_CI_IMAGE="true"
export AIRFLOW_CONTAINER_PUSH_IMAGES="false"
export AIRFLOW_CONTAINER_BUILD_NPM="false"
export AIRFLOW_CONTAINER_CI_OPTIMISED_BUILD="true"

# shellcheck source=../../hooks/build
. ./hooks/build

set -x
docker run -v "$(pwd)./docs/_build":/opt/airflow/docs/_build -t --entrypoint /opt/airflow/docs/build.sh \
       --env HOST_USER_ID="$(id -ur)" --env HOST_GROUP_ID="$(id -gr)" "${AIRFLOW_SLIM_CI_IMAGE}"
set +x

popd || exit 1
