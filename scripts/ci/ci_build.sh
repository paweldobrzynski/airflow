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

# shellcheck source=./_force_python_3.6.sh
. "${MY_DIR}"/_force_python_3.6.sh
# shellcheck source=./_check_coreutils.sh
. "${MY_DIR}"/_check_coreutils.sh
# shellcheck source=./_cache_utils.sh
. "${MY_DIR}"/_cache_utils.sh
# shellcheck source=./_verbosity_utils.sh
. "${MY_DIR}"/_verbosity_utils.sh

output_verbose_start

# shellcheck source=./_mounted_volumes_for_static_checks.sh
. "${MY_DIR}"/_mounted_volumes_for_static_checks.sh

pushd "${MY_DIR}/../../" || exit 1
# shellcheck source=./_rebuild_image_if_needed_for_static_checks.sh
. "${MY_DIR}/_rebuild_image_if_needed_for_static_checks.sh"

popd || exit 1

output_verbose_end
