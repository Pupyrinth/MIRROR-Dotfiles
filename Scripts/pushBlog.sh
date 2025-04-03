CURRENT_PATH=$(pwd)

cd $HOME/myHome/Projects/Blog

git add .
git commit -m "$1"
git push

cd $CURRENT_PATH
