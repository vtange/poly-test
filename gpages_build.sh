# This script pushes a demo-friendly version of your element and its
# dependencies to gh-pages.

# usage gp Polymer core-item [branch]
# Run in a clean directory passing in a GitHub org and repo name
org=$1
repo=$2
name=$3
email=$4
branch=${5:-"master"} # default to master when branch isn't specified

mkdir temp && cd temp

# make folder (same as input, no checking!)
mkdir $repo
git clone "https://${GH_TOKEN}@${GH_REF}" --single-branch

# switch to gh-pages branch
cd $repo
git checkout gh-pages

# merge master branch
git merge master

# use bower to install runtime deployment
bower cache clean $repo # ensure we're getting the latest from the desired branch.
git show ${branch}:bower.json > bower.json
echo "{
  \"directory\": \"components\"
}
" > .bowerrc
bower install
bower install $org/$repo#$branch

# run gulpFile
gulp

git config user.name $name
git config user.email $email

# send it all to github
git add -A .
git commit -am 'Deploy to GitHub Pages'
git push --force --quiet -u "https://${GH_TOKEN}@${GH_REF}" gh-pages > /dev/null 2>&1

popd >/dev/null

