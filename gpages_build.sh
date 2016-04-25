# This script pushes a demo-friendly version of your element and its
# dependencies to gh-pages.

# usage gp Polymer core-item [branch]
# Run in a clean directory passing in a GitHub org and repo name
org=$1
repo=$2
name=$3
email=$4
branch=${5:-"master"} # default to master when branch isn't specified

# switch to gh-pages branch
pushd $repo >/dev/null
git checkout --orphan gh-pages

# remove all content
git rm -rf -q .

# run gulpFile
gulp

git config user.name $name
git config user.email $email

# send it all to github
git add -A .
git commit -am 'Deploy to GitHub Pages'
git push --force --quiet -u "https://${GH_TOKEN}@${GH_REF}" gh-pages > /dev/null 2>&1

popd >/dev/null

