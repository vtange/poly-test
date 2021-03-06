#
# Modified to work with Travis CI automated builds
# Original license follows
#
# @license
# Copyright (c) 2014 The Polymer Project Authors. All rights reserved.
# This code may only be used under the BSD style license found at http://polymer.github.io/LICENSE.txt
# The complete set of authors may be found at http://polymer.github.io/AUTHORS.txt
# The complete set of contributors may be found at http://polymer.github.io/CONTRIBUTORS.txt
# Code distributed by Google as part of the polymer project is also
# subject to an additional IP rights grant found at http://polymer.github.io/PATENTS.txt
#

# This script pushes a demo-friendly version of your element and its
# dependencies to gh-pages.

# usage gp Polymer core-item [branch]
# Run in a clean directory passing in a GitHub org and repo name
gituser=$1
repo=$2
name=$3
email=$4
branch=${5:-"master"} # default to master when branch isn't specified

mkdir temp && cd temp

# make folder (same as input, no checking!)
mkdir $repo
git clone "https://${GH_TOKEN}@${GH_REF}" --single-branch

# switch to gh-pages branch
pushd $repo >/dev/null
git checkout --orphan gh-pages

# remove all content
git rm -rf -q .

# get back bower.json, install the stuff required inside, install the new element itself
bower cache clean $repo # ensure we're getting the latest from the desired branch.
git show ${branch}:bower.json > bower.json
echo "{
  \"directory\": \"components\"
}
" > .bowerrc
bower install
bower install $gituser/$repo#$branch



# make sure /demo/index.html exists
git checkout ${branch} -- demo
rm -rf components/$repo/demo
mv demo components/$repo/

# redirect base html file to the new component
echo "<META http-equiv="refresh" content=\"0;URL=components/$repo/\">" >index.html

# gulp vulcanize and crisper the demo for optimized loading
cd components/$repo/
gulp
cd ../..

# prepare user info for gh-pages push
git config user.name $name
git config user.email $email

# send it all to github
git add -A .
git commit -am 'Deploy to GitHub Pages'
git push --force --quiet -u "https://${GH_TOKEN}@${GH_REF}" gh-pages

popd >/dev/null