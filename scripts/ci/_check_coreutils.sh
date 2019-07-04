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

set +e
getopt -T >/dev/null
GETOPT_RETVAL=$?

if [[ $(uname -s) == 'Darwin' ]] ; then
    command -v gstat >/dev/null
    STAT_PRESENT=$?
else
    command -v stat >/dev/null
    STAT_PRESENT=$?
fi

command -v md5sum >/dev/null
MD5SUM_PRESENT=$?

set -e

####################  Parsing options/arguments
if [[ ${GETOPT_RETVAL} != 4 || "${STAT_PRESENT}" != "0" || "${MD5SUM_PRESENT}" != "0" ]]; then
    echo
    if [[ $(uname -s) == 'Darwin' ]] ; then
        echo >&2 "You are running ${CMDNAME} in OSX environment"
        echo >&2 "And you need to install gnu commands"
        echo
        echo >&2 "Run 'brew install gnu-getopt coreutils'"
        echo
        echo >&2 "Then link the gnu-getopt to become default as suggested by brew by typing:"
        echo >&2 "echo 'export PATH=\"/usr/local/opt/gnu-getopt/bin:\$PATH\"' >> ~/.bash_profile"
        echo >&2 ". ~/.bash_profile"
        echo
        echo >&2 "Login and logout afterwards"
        echo
    else
        echo >&2 "You do not have necessary tools in your path (getopt, stat, md5sum)."
        echo >&2 "Please install latest/GNU version of getopt and coreutils."
        echo >&2 "This can usually be done with 'apt install util-linux coreutils'"
    fi
    echo
    exit 1
fi
