#!/usr/bin/env python3

# This is a simple script to find all video files in a folder and move them into their own folders.
# It also detects .srt subtitle files with matching names and moves them into their corresponding
# video file's folder.

import os
from pathlib import Path

path = os.getcwd()
files = (file for file in os.listdir(path)
         if os.path.isfile(file) and Path(file).suffix in ['.mkv', '.mp4', '.avi', '.3gp'])
ctr = 0

for x in files:
    filename = Path(x)
    basename = str(filename.with_suffix(''))
    if not os.path.isdir(basename):
        os.mkdir(basename)
    else:
        print('The folder '+basename +
              ' already exists, please deal with that file manually.')
        continue
    os.rename(path+"/"+x, path+"/"+basename+"/"+x)
    if os.path.isfile(basename+'.srt'):
        os.rename(path+'/'+basename+'.srt', path +
                  '/'+basename+'/'+basename+'.srt')
    if os.path.isfile(basename+'.en.srt'):
        os.rename(path+'/'+basename+'.en.srt', path +
                  '/'+basename+'/'+basename+'.en.srt')
    ctr += 1

print(str(ctr)+' folder(s) created.')
