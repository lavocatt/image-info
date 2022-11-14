#!/bin/bash
set -euxo pipefail

# This script uploads all files from ARTIFACTS folder to S3

S3_URL="s3://manifest-db-ci-storage/$1/$CI_COMMIT_BRANCH/$CI_JOB_ID/"
BROWSER_URL="https://s3.console.aws.amazon.com/s3/buckets/manifest-db-ci-storage?region=us-east-1&prefix=$1/$CI_COMMIT_BRANCH/$CI_JOB_ID/&showversions=false"
ARTIFACTS=${ARTIFACTS:-/tmp/artifacts}

# Colorful output.
function greenprint {
  echo -e "\033[1;32m[$(date -Isecond)] ${1}\033[0m"
}
source /etc/os-release
# s3cmd is in epel, add if it's not present
if [[ $ID == rhel || $ID == centos ]] && ! rpm -q epel-release; then
    curl -Ls --retry 5 --output /tmp/epel.rpm \
        https://dl.fedoraproject.org/pub/epel/epel-release-latest-"${VERSION_ID%.*}".noarch.rpm
    sudo rpm -Uvh /tmp/epel.rpm
fi

sudo dnf -y install s3cmd
greenprint "Job artifacts will be uploaded to: $S3_URL"

AWS_SECRET_ACCESS_KEY="$V2_AWS_SECRET_ACCESS_KEY" \
AWS_ACCESS_KEY_ID="$V2_AWS_ACCESS_KEY_ID" \
ls -l "$1"
s3cmd --acl-private put "$1/*" "$S3_URL"

greenprint "Please login to 438669297788 AWS account and visit $BROWSER_URL to access job artifacts."

