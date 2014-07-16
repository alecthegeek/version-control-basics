#! /usr/bin/env bash -xv


function formatCommand {
    echo '        ~/snakes $'"$@"
    "$@" |sed -e 's/^/        /' &1>1
    sleep 3
}


[[ -d $DEV_DIR/includes ]] || mkdir $DEV_DIR/includes

cd /tmp
[[ -f game.tar.gz ]] || wget https://www.dropbox.com/sh/2zbaey5o6hqkfl5/AADnyNZMzh7clNb6-vdWBfbna/game.tar.gz
[[ -d $BASE_DEMO ]] && rm -rf $BASE_DEMO
mkdir $BASE_DEMO
cd $BASE_DEMO

tar xzf /tmp/game.tar.gz
find . -type f -exec dos2unix  {} \;

formatCommand git init > $DEV_DIR/includes/init

git config user.name $USER_NAME
git config user.email $USER_EMAIL
git config --global core.autocrlf input
#git config --global core.editor "/usr/bin/leafpad"

formatCommand git status   > $DEV_DIR/includes/status1

formatCommand git add .  > $DEV_DIR/includes/add1
formatCommand git status > $DEV_DIR/includes/status2

formatCommand git commit -m "Initial Commit" > $DEV_DIR/includes/commit1
formatCommand git status > $DEV_DIR/includes/status3
formatCommand git log > $DEV_DIR/includes/log1

formatCommand git branch $BRANCH2 > $DEV_DIR/includes/addbranch1
formatCommand git branch > $DEV_DIR/includes/displaybranch1

formatCommand git checkout $BRANCH2 2>&1 > $DEV_DIR/includes/checkout1b2
formatCommand git branch > $DEV_DIR/includes/displaybranch2

formatCommand git diff > $DEV_DIR/includes/displaydiff1
