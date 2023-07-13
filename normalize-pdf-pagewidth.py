#!/bin/env python3

# This script resized all pages of a given pdf to make them all the same width.
# It can be set up to make them all the same as the min width of the given pdf,
# or the max width, or a custom width.

from argparse import ArgumentParser
from pypdf import PdfReader, PdfWriter
from pathlib import Path

parser = ArgumentParser(
    prog = 'Normalize PDF pagewidth',
    description = 'A small program that does exactly what it says',
    epilog = 'For each input file \'input.pdf\', the output file will be named \'input-norm.pdf\''
)

parser.add_argument('filename', help = 'The name of the input file. Multiple files can be supplied at once.', nargs = '+')
parser.add_argument('-w', '--width', default = 'min', help = 'The desired width. Can be \'max\', \'min\', or a number in pixels. Defaults to min.')
args = vars(parser.parse_args())

w = args['width']
if w != 'min' and w != 'max' and not w.isnumeric():
    print('Invalid width. Only min, max or numeric values are supported.')
    exit(-1)

for file in args['filename']:
    print('Processing ' + file + '...')
    try:
        reader = PdfReader(file)
    except:
        print('There was some error trying to read the file.')
    else:
        pages = reader.pages
        outfile = Path(file).stem + '-norm.pdf'
        if w == 'min':
            outw = min([pages[i].mediabox.width for i in range(len(pages))])
        elif w == 'max':
            outw = max([pages[i].mediabox.width for i in range(len(pages))])
        else:
            outw = w
        writer = PdfWriter()
        for page in pages:
            dim = page.mediabox
            outh = dim.height * (outw / dim.width)
            page.scale_to(width = outw, height = outh)
            writer.add_page(page)
        with open(outfile, 'wb+') as f:
            writer.write(f)