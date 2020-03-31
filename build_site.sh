#!/bin/bash 


JBAKE_VERSION=2.6.4
echo "JBAKE_BIN=${JBAKE_BIN}."
echo "JBAKE_VERSION=${JBAKE_VERSION}"
curl -s "https://get.sdkman.io" | bash  || echo "SDKMAN is already installed..."

ls -la $HOME/.sdkman/
tree $HOME/.sdkman/

source "${HOME}/.sdkman/bin/sdkman-init.sh"
which sdk 
sdk version 
sdk install jbake $JBAKE_VERSION 
echo "SDKMAN_DIR is ${SDKMAN_DIR} "


# 

source "${HOME}/.sdkman/bin/sdkman-init.sh"
OUTPUT_DIR=${GITHUB_WORKSPACE}/output
rm -rf ${OUTPUT_DIR}
jbake  . ${OUTPUT_DIR} --reset
cp -r content/media ${OUTPUT_DIR}/media
cp CNAME ${OUTPUT_DIR}/CNAME

# BLOG_GITHUB_URI=https://${BLOG_TOKEN}@github.com/joshlong/joshlong.github.io.git
BLOG_GITHUB_URI=git@github.com:joshlong/joshlong.github.io.git
BLOG_GITHUB_CHECKOUT=${GITHUB_WORKSPACE}/checkout 

# rm -rf $BLOG_GITHUB_CHECKOUT
# if [ ! -d "$BLOG_GITHUB_CHECKOUT" ]; then
#     mkdir -p ${BLOG_GITHUB_CHECKOUT}
#     cd $BLOG_GITHUB_CHECKOUT
#     git clone ${BLOG_GITHUB_URI} $BLOG_GITHUB_CHECKOUT || echo "couldn't clone the book from ${BLOG_GITHUB_URI}."
#     ls -la $BLOG_GITHUB_CHECKOUT 
# fi

cd $BLOG_GITHUB_CHECKOUT && git checkout master && pwd  

cp -r $OUTPUT_DIR/* . 
git add * 
git commit -am "new version $NOW "
echo "trying to do a git push for the repository "
cat .git/config 
git push 

