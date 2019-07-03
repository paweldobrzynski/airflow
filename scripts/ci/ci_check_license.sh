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
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

acquire_rat_jar () {

  URL="http://repo1.maven.org/maven2/org/apache/rat/apache-rat/${RAT_VERSION}/apache-rat-${RAT_VERSION}.jar"

  JAR="${RAT_JAR}"

  # Download rat launch jar if it hasn't been downloaded yet
  if [[ ! -f "${JAR}" ]]; then
    # Download
    echo "Attempting to fetch rat"
    JAR_DL="${JAR}.part"
    if [[ $(command -v curl) ]]; then
      curl -L --silent "${URL}" > "${JAR_DL}" && mv "${JAR_DL}" "${JAR}"
    elif [[ $(command -v wget) ]]; then
      wget --quiet "${URL}" -O "${JAR_DL}" && mv "${JAR_DL}" "${JAR}"
    else
      echo >&2 "You do not have curl or wget installed, please install rat manually."
      exit 1
    fi
  fi


  if ! unzip -tq "${JAR}" &> /dev/null; then
    # We failed to download
    rm "${JAR}"
    echo >&2 "Our attempt to download rat locally to ${JAR} failed. Please install rat manually."
    exit 1
  fi
  echo "Done downloading."
}

# Go to the Airflow project root directory
AIRFLOW_ROOT="$(cd "${MY_DIR}"/../../ && pwd )/$(basename "$1")"

TMP_DIR=/tmp

if test -x "$JAVA_HOME/bin/java"; then
    declare JAVA_CMD="$JAVA_HOME/bin/java"
else
    declare JAVA_CMD=java
fi

export RAT_VERSION=0.12
export RAT_JAR="${TMP_DIR}"/lib/apache-rat-${RAT_VERSION}.jar
mkdir -p "${TMP_DIR}/lib"


[[ -f "${RAT_JAR}" ]] || acquire_rat_jar || {
    echo >&2 "Download failed. Obtain the rat jar manually and place it at ${RAT_JAR}"
    exit 1
}

# This is the target of a symlink in airflow/www/static/docs -
# and rat exclude doesn't cope with the symlink target doesn't exist
mkdir -p docs/_build/html/

echo "Running license checks. This can take a while."


if ${JAVA_CMD} -jar "${RAT_JAR}" -E "${AIRFLOW_ROOT}"/.rat-excludes \
    -d "${AIRFLOW_ROOT}" > rat-results.txt; then
   echo >&2 "RAT exited abnormally"
   exit 1
fi

ERRORS="$(grep -e "??" rat-results.txt)"

if test ! -z "${ERRORS}"; then
    echo >&2 "Could not find Apache license headers in the following files:"
    echo >&2 "${ERRORS}"
    exit 1
else
    echo -e "RAT checks passed."
fi
