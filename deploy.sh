#!/bin/bash 

JBAKE_VERSION=2.6.4
BLOG_GITHUB_CHECKOUT=${GITHUB_WORKSPACE}/site 
OUTPUT_DIR=${GITHUB_WORKSPACE}/output

curl -s "https://get.sdkman.io" | bash  || echo "SDKMAN is already installed..."
source "${HOME}/.sdkman/bin/sdkman-init.sh"
which sdk 
sdk version 
sdk install jbake $JBAKE_VERSION 
source "${HOME}/.sdkman/bin/sdkman-init.sh"
rm -rf ${OUTPUT_DIR}
jbake  . ${OUTPUT_DIR} --reset
cp -r content/media ${OUTPUT_DIR}/media
cp CNAME ${OUTPUT_DIR}/CNAME

cd $BLOG_GITHUB_CHECKOUT  
cp -r $OUTPUT_DIR/* . 
git status
git add * 
git commit -am "new version $NOW "
git push 

echo "finished." 
