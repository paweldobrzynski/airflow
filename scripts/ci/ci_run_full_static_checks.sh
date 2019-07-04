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

set -euo pipefail

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd "${MY_DIR}"/../../ || exit 1

set +e
command -v pre-commit >/dev/null
RES_PRE_COMMIT=$?

command -v yamllint >/dev/null
RES_YAMLLINT=$?
set -e

PRE_COMMIT_VERSION="1.17.0"
YAMLLINT_VERSION="1.16.0"

if [[ ${RES_PRE_COMMIT} != "0" || ${RES_YAMLLINT} != "0" ]]; then
    pip install pre-commit==${PRE_COMMIT_VERSION} yamllint==${YAMLLINT_VERSION}
fi

# Pylint is executed in separate job because it runs for a long time
# and because we are now running it in customised way with pylint (we might revisit it when we remove
# customised execution with pylint_todo.txt)
SKIP="run-pylint" pre-commit run --all-files

popd || exit 1
