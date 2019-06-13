#!/bin/bash
# Copyright 2019 Rob Lyon (ctxswitch)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License. 

# Using a kafka container, run the admin commands interactively as if the tools were installed
# on the users workstation.  The commands are run against a kafka server running locally as 
# a container.  It's currently not all that flexible, but was only needed for testing this
# specific usecase.  The main application was designed to be used as an entrypoint for wrapper
# scripts that mirror the kafka application's tools. i.e. kafka-topics.sh
KAFKA_CONTAINER_NAME=${KAFKA_CONTAINER_NAME:-kafka}
KAFKA_IMAGE=${KAFKA_IMAGE:-ctxswitch/kafka}
KAFKA_HOME=${KAFKA_HOME:-/opt/kafka}
# Pull in the container id, with either the provided name or 'kafka'
CONTAINER_ID=$(docker ps --filter name="${KAFKA_CONTAINER_NAME}" -qa | grep -E '^[a-f0-9]+$')

if [[ "x$CONTAINER_ID" == "x" ]] ; then
  echo "Could not find a container named $KAFKA_CONTAINER_NAME running in the current environment"
  echo "environment.  To use this utility, ensure that you name the docker container 'kafka'"
  echo "or set the environment variable KAFKA_CONTAINER_NAME variable to match the name"
  echo "that kafka was deployed as."
  exit 1
fi

# The kafka admin script is the first argument here.  All others come after it
if [[ $# -lt 1 ]] ; then
  echo "Usage: kafka-bin.sh <kafka-bin-script> [arguments]"
fi

CMD=$1
shift

docker run -i --network container:$CONTAINER_ID $KAFKA_IMAGE $KAFKA_HOME/bin/$CMD $@
exit $?
