#!/usr/bin/env bash
git stash &&
zola build &&
rsync -avz public/{.,}* bensrv:/var/www/ben/ &&
git stash pop
