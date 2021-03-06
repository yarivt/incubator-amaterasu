#!/usr/bin/env bash
#
#    Licensed to the Apache Software Foundation (ASF) under one or more
#    contributor license agreements.  See the NOTICE file distributed with
#    this work for additional information regarding copyright ownership.
#    The ASF licenses this file to You under the Apache License, Version 2.0
#    (the "License"); you may not use this file except in compliance with
#    the License.  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#

BASEDIR=$(dirname -- $0)

export AMA_NODE="$(hostname)"
#pushd $BASEDIR >/dev/null
#cd /mesos-dependencies/ && nohup java -cp ${BASEDIR}/amaterasu-assembly-0.1.0.jar -Djava.library.path=/usr/lib org.apache.amaterasu.utilities.HttpServer &
#SERVER_PID=$!



echo "serving amaterasu from /ama/lib on user supplied port"
popd >/dev/null

RED=`tput setaf 1`
YELLOW=`tput setaf 3`
NC=`tput sgr0`
bold=$(tput bold)
normal=$(tput sgr0)

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
    export AWS_ACCESS_KEY_ID=0
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    export AWS_SECRET_ACCESS_KEY=0
fi

echo ""
echo ""
echo "${bold}${RED}                                             /\ "
echo "  				            /  \ /\ "
echo "  				           / ${YELLOW}/\\${RED} /  \ "
echo "      ${NC}${bold}_                 _               ${RED}  / ${YELLOW}/${RED}  / ${YELLOW}/\\${RED} \ ${NC}"
echo "${bold}     / \   _ __   __ _ | |_  ___  _ _  __${RED}(${NC}${bold}_${YELLOW}( ${NC}${bold}_${RED}(${NC}${bold}_${YELLOW}(${NC}${bold}_ ${YELLOW})${NC}${bold}_${RED})${NC}${bold} "
echo "    / _ \ | '  \ / _\` ||  _|/ -_)| '_|/ _\` |(_-<| || | "
echo "   /_/ \_\|_|_|_|\__,_| \__|\___||_|  \__,_|/__/ \_,_| "
echo ""
echo "    Continuously deployed data pipelines"
echo "    Version 0.2.0-incubating-rc4"
echo "${NC}"
echo ""

for i in "$@"
do
case $i in
    -r=*|--repo=*)
    REPO="${i#*=}"
    shift # past argument=value
    ;;
    -b=*|--branch=*)
    BRANCH="${i#*=}"
    shift # past argument=value
    ;;
    -e=*|--env=*)
    ENV="${i#*=}"
    shift # past argument=value
    ;;
    -n=*|--name=*)
    NAME="${i#*=}"
    shift # past argument=value
    ;;
    -i=*|--job-id=*)
    JOBID="${i#*=}"
    shift # past argument=value
    ;;
    -i=*|--report=*)
    REPORT="${i#*=}"
    shift # past argument=value
    ;;
    --default)
    DEFAULT=YES
    shift # past argument with no value
    ;;
    -u=*|--user-name=*)
    USERNAME="${i#*=}"
    shift # past argument=value
    ;;
    -p=*|--password=*)
    PASSWORD="${i#*=}"
    shift # past argument=value
    ;;
    *)
            # unknown option
    ;;
esac
done

CP=""
for filename in $BASEDIR/bin/*; do
    CP+=$filename":"
done

echo "repo: ${REPO} "
CMD="java -cp ${CP} -Djava.library.path=/usr/lib org.apache.amaterasu.leader.mesos.MesosJobLauncher --home ${BASEDIR}"

if [ -n "$REPO" ]; then
    CMD+=" --repo ${REPO}"
fi

if [ -n "$BRANCH" ]; then
    CMD+=" --branch ${BRANCH}"
fi

if [ -n "$ENV" ]; then
    CMD+=" --env ${ENV}"
fi

if [ -n "$NAME" ]; then
    CMD+=" --name ${NAME}"
fi

if [ -n "$JOBID" ]; then
    CMD+=" --job-id ${JOBID}"
fi

if [ -n "$REPORT" ]; then
    CMD+=" --report ${REPORT}"
fi

if [ -n "$USERNAME" ]; then
    CMD+=" --user-name ${USERNAME}"
else
    CMD+=" --user-name \"\""
fi

if [ -n "$PASSWORD" ]; then
    CMD+=" --password ${PASSWORD}"
else
    CMD+=" --password \"\""
fi

if ! ls ${BASEDIR}/dist/spark*.tgz 1> /dev/null 2>&1; then
    echo "${bold} Fetching spark distributable ${NC}"
    #wget https://d3kbcqa49mib13.cloudfront.net/spark-2.2.1-bin-hadoop2.7.tgz -P ${BASEDIR}/dist
    wget https://archive.apache.org/dist/spark/spark-2.2.1/spark-2.2.1-bin-hadoop2.7.tgz -P ${BASEDIR}/dist
fi
cp ${BASEDIR}/amaterasu.properties ${BASEDIR}/dist
mesosLibConf=`cat amaterasu.properties | grep mesos.libPath`
mesosLib=`echo "$mesosLibConf" | cut -d "=" -f 2`
if [[ ! -z "$mesosLib" ]]; then
    export MESOS_NATIVE_JAVA_LIBRARY="$mesosLib"
    export AMA_NODE=`hostname`
    eval $CMD | grep "===>"
else
    echo "ERROR: mesos.libPath not specified in amaterasu.properties"
fi


echo ""
echo ""
echo "W00t amaterasu job is finished!!!"
