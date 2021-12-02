#!/usr/bin/env python3

# This is a file to paste small scanned ID cards in an A4 page for printing
# I use it to quickly organise the pages for printing
# Syntax : script.py filename width_in_cm -o [optional, to overwrite output file]

import sys, os
from pdf2image import convert_from_path
from PIL import Image

if len(sys.argv)<3:
    raise Exception('Not enough arguments.\nUse the syntax "script.py filename width_in_cm -o [optional, to overwrite output file]"')
filename = sys.argv[1]
if not os.path.isfile(filename):
    raise Exception('File {} not present',format(filename))
if filename.split('.')[-1]!='pdf':
    raise Exception('Given file is not a PDF')
if filename.split('/')[-1].split(']')[0]=='[printable':
    raise Exception('File already processed')
print('Processing '+filename.split('/')[-1])
new_width = int(int(sys.argv[2])*0.3937*300) # converting to inch from cm at 300 dpi
overwrite_status = '-n'
if len(sys.argv)>3:
    overwrite_status = sys.argv[3]
images = convert_from_path(filename)
a4size = int(8.27*300), int(11.7*300)
a4page = Image.new('RGB',a4size,'white') # A4 at 300 dpi
pagenum = len(images)
widths = [images[i].size[0] for i in range(pagenum)]
heights = [images[i].size[1] for i in range(pagenum)]
new_heights = [int(heights[i]*new_width/widths[i]) for i in range(pagenum)]
gap = int(max(new_heights)/pagenum)
total_height = sum(new_heights)+gap*(pagenum-1)
if new_width > a4size[0] or total_height > a4size[1]:
    raise Exception('Given width too big for A4 page')
for i in range(pagenum):
    a4page.paste(images[i].resize((new_width, new_heights[i]), Image.ANTIALIAS), (int((a4size[0]-new_width)/2),int((a4size[1]-total_height)/2+i*(new_heights[i-1]+gap))))
new_filename = '[printable] ' + filename.split('/')[-1].split('.')[0] + '.pdf'
if os.path.isfile(new_filename) and overwrite_status != '-o':
    raise Exception('File {} already present. Add -o at the end to overwrite')
a4page.save(new_filename, quality=95)
print('File '+new_filename+' created.')
