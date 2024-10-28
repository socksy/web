#!/usr/bin/env bash
cd "$(dirname "${BASH_SOURCE[0]}")/.." 
magick mogrify -format ico -density 600 -define icon:auto-resize=128,48,32,16 static/favicon.png
