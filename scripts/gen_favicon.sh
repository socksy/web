#!/usr/bin/env bash
cd "$(dirname "${BASH_SOURCE[0]}")/.." 
inkscape --export-type=png --export-dpi=200 --export-background-opacity 0 -w 128 -h 128 static/favicon.svg && \
magick -define icon:auto-resize=128,48,32,16 static/favicon.png static/favicon.ico
