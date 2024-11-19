#!/usr/bin/env bash
zola build &&
rsync -avz public/{.,}* bensrv:/var/www/ben/
