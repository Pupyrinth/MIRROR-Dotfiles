CURRENT_PATH=$(pwd)

cd $HOME/myHome/Projects/Blog

pnpm new-post "$1"

cd $CURRENT_PATH
