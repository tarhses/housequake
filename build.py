#!/usr/bin/env python3

"""Create a love archive from files in the local directory.

OUTPUT_NAME contains the name of the generated file. IGNORED_GLOBS contains a
list of name patterns that will be ignored (see Python's glob module).
"""

import os
from glob import glob
from zipfile import ZipFile, ZIP_DEFLATED

OUTPUT_NAME = 'housequake.love'
IGNORED_GLOBS = [
    '.*',
    '.*/**',
    '*.love',
    'README.md',
    'LICENSE',
    'assets/source/**',
    'screenshots/**',
]

ignored_files = set.union(*(set(glob(i.removeprefix('./'), recursive=True)) for i in IGNORED_GLOBS))
ignored_files.add(os.path.basename(__file__))

with ZipFile(OUTPUT_NAME, 'w', compression=ZIP_DEFLATED) as file:
    for dirpath, dirnames, filenames in os.walk('.'):
        for filename in filenames:
            filepath = os.path.join(dirpath, filename).removeprefix('./')
            if filepath in ignored_files:
                print(f'  {filepath}')
            else:
                print(f'> {filepath}')
                file.write(filepath)
