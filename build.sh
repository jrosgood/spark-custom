#!/bin/bash
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
cd /tmp
git clone https://github.com/apache/spark.git spark_src
cd spark_src
git checkout "tags/v$spark_version" -b "v$spark_version"
./dev/make-distribution.sh --name hadoop$hadoop_version-scala$scala_version --pip --tgz -Phive -Phive-thriftserver -Pmesos -Pyarn -Pkubernetes -Dhadoop.version=$hadoop_version
fname=spark-$spark_version-bin-hadoop$hadoop_version-scala$scala_version
directory=$to_directory/$fname
echo "Moving to directory $directory"
mv /tmp/spark_src/dist "$directory"
cd $directory
echo "Creating archive $fname.tgz"
tar -cvzf "$fname.tgz" "$directory"


