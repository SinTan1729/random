#!/usr/bin/env python3

# This is a script to prepare a document to be printed on my office printer
# which only prints in B&W (not grayscale) letter size pages. It sometimes
# cuts edges and/or prints colors too light if the conversion to itself.
# Hence, this script. As a plus, A4 paper is supported too.

# Syntax : script.py filename -o [optional, to overwrite output file]

import sys
import os
from pdf2image import convert_from_path
from PIL import Image
from tqdm import tqdm

if len(sys.argv) < 3:
    raise Exception(
        'Not enough arguments.\nUse the syntax "script.py filename size(letter/a4) -o [optional, to overwrite output file]"')

filename = sys.argv[1]
if not os.path.isfile(filename):
    raise Exception('File {} not present', format(filename))
if filename.split('.')[-1] != 'pdf':
    raise Exception('Given file is not a PDF')
if filename.split('/')[-1].split(']')[0] == '[office_print':
    raise Exception('File has already been processed')
print('Processing '+filename.split('/')[-1])

overwrite_status = '-n'
if len(sys.argv) > 3:
    overwrite_status = sys.argv[3]

page_size = sys.argv[2].lower()
if page_size not in ["a4", "letter"]:
    raise Exception(
        'Unknown paper size! Only supported sizes are A4 and Letter.')

pdf = convert_from_path(filename, dpi=300)

dpi = 300
a4size = int(8.27*dpi), int(11.7*dpi)
lettersize = int(8.5*dpi), int(11*dpi)

if page_size == "a4":
    new_size = a4size
else:
    new_size = lettersize

pagenum = len(pdf)

new_pdf = list()
for i in tqdm(range(pagenum)):
    page = Image.new('L', new_size, 'white')
    old_size = pdf[i].size
    ratio = min(new_size[0]/old_size[0], new_size[1]/old_size[1])
    resize_to = round(old_size[0]*ratio), round(old_size[1]*ratio)
    offset = round((new_size[0]-resize_to[0]) /
                   2), round((new_size[1]-resize_to[1])/2)
    page.paste(pdf[i].resize(resize_to, Image.LANCZOS), offset)

    # We apply a curve to deepen the previously colored strokes
    page_bw = page.point(lambda x: round(x/12) if 16 < x < 192 else x, 'L')
    new_pdf.append(page_bw)

new_filename = '[office_print] ' + \
    filename.split('/')[-1].split('.')[0] + '.pdf'
if os.path.isfile(new_filename) and overwrite_status != '-o':
    raise Exception(
        'File '+new_filename+' is already present. Add -o at the end to overwrite')

new_pdf[0].save(new_filename, "PDF", resolution=dpi, quality=100,
                save_all=True, append_images=new_pdf[1:])
print('File '+new_filename+' was created.')
