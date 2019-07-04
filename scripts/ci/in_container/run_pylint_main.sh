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

# Script to run Pylint on main sources. Can be started from any working directory
set -uo pipefail

pushd "${AIRFLOW_SOURCES}" >/dev/null || exit 1

FILES=("$@")
if [[ "${#FILES[@]}" != "0" ]]; then
    echo
    echo "Running pylint for specified files"
    echo
    pylint -j 0 --output-format=colorized "${FILES[@]}"
    RES=$?
else
    echo
    echo "Running pylint for source code without tests"
    echo
    find . -name "*.py" \
        -not -path "./.eggs/*" \
        -not -path "./airflow/www/node_modules/*" \
        -not -path "./airflow/_vendor/*" \
        -not -path "./build/*" \
        -not -path "./tests/*" \
        -not -name 'webserver_config.py' | \
      grep -vFf scripts/ci/pylint_todo.txt | xargs -P "$(nproc)" pylint --output-format=colorized
    RES=$?
fi

popd >/dev/null || exit 1

if [[ "${RES}" != 0 ]]; then
    echo >&2
    echo >&2 "There were some pylint errors while testing main files. Exiting"
    echo >&2
    exit 1
else
    echo
    echo "Pylint check succeeded for main files"
    echo
fi
