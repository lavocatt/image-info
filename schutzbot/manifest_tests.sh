#/bin/bash

mkdir builds
sudo test/cases/manifest_tests
RET=$?
schutzbot/upload_to_s3.sh builds
exit $RET
