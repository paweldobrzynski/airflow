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

set -uo pipefail

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

"${MY_DIR}"/ci_pylint_main.sh
RES_MAIN=$?


"${MY_DIR}"/ci_pylint_tests.sh
RES_TESTS=$?

if [[ ${RES_MAIN} != "0" || ${RES_TESTS} != "0" ]]; then
    echo >&2
    echo >&2 "Pylint main status: ${RES_MAIN}"
    echo >&2 "Pylint tests status: ${RES_TESTS}"
    echo >&2
    exit 1
else
    echo "All pylint checks succeeded"
fi
