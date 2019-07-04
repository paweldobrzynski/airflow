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

OUTPUT_LOG="${CACHE_TMP_FILE_DIR}/out.log"

function output_verbose_start {
    if [[ ${VERBOSE:=} == "true" ]]; then
        echo
        echo Variable VERBOSE Set to "true"
        echo You will see a lot of output
        echo
        set -x
        exec 4>&1 5>&2
    else
        echo
        echo Log is being redirected to "${OUTPUT_LOG}"
        echo
        echo You can increase verbosity by running \'export VERBOSE="true"\'
        if [[ ${SKIP_CACHE_DELETION:=} != "true" ]]; then
            echo Or skip deleting the output file with \'export SKIP_CACHE_DELETION="true"\'
        fi
        echo
        exec 4>&1 5>&2 &>"${OUTPUT_LOG}"
    fi
}

function output_verbose_end {
    if [[ ${VERBOSE:=} == "true" ]]; then
        set +x
    fi
    exec 1>&4 2>&5
}
