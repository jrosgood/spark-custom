#!/bin/bash
# See https://spark.apache.org/docs/latest/building-spark.html for more info
while getopts s:h:c:t: flag
do
    case "${flag}" in
        s) spark_version=${OPTARG};;
        h) hadoop_version=${OPTARG};;
        c) scala_version=${OPTARG};;
        t) to_directory=${OPTARG};;
    esac
done
set -ex
# The MAVEN_OPTS settings below are required to prevent heap errors and stack overflows
export MAVEN_OPTS="-Xss64m -Xmx2g -XX:ReservedCodeCacheSize=1g"
cd /tmp
git clone https://github.com/apache/spark.git spark_src
cd spark_src
git checkout "tags/v$spark_version" -b "v$spark_version"
./dev/make-distribution.sh --name hadoop$hadoop_version-scala$scala_version --pip --tgz -Phive -Phive-thriftserver -Pmesos -Pyarn -Pkubernetes -Phadoop-provided -Dhadoop.version=$hadoop_version
fname=spark-$spark_version-bin-hadoop$hadoop_version-scala$scala_version
cp /tmp/spark_src/$fname.tgz $to_directory/$fname.tgz
# cleanup
rm -rf /tmp/spark_src


