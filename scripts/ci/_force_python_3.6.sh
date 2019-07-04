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

# Force Python version to 3.6 for some scripts
export PYTHON_BINARY=python3.6

# And fail in case it is not available
if [[ ! -x "$(command -v "${PYTHON_BINARY}")" ]]; then
    echo >&2
    echo >&2 "${PYTHON_BINARY} is missing in your \$PATH"
    echo >&2
    echo >&2 "Please install Python 3.6 and make it available in your path"
    echo >&2
    exit 1
fi

# Set python version variable to force it in the scripts as well
PYTHON_VERSION=3.6
export PYTHON_VERSION
