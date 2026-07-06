#!/usr/bin/env python3
"""Static package checks that do not require Flutter SDK."""
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
LIB = ROOT / 'lib'
ERRORS: list[str] = []
STATEMENT = re.compile(r"^\s*(import|export|part)\s+'([^']+)'", re.MULTILINE)
PART_OF = re.compile(r"^\s*part of\s+'([^']+)'", re.MULTILINE)

for file in ROOT.rglob('*.dart'):
    source = file.read_text(encoding='utf-8')
    for kind, uri in STATEMENT.findall(source):
        if uri.startswith('package:smart_pagination/'):
            ERRORS.append(f'legacy package import in {file.relative_to(ROOT)}')
        if uri.startswith('package:super_pagination/'):
            target = LIB / uri.split('/', 1)[1]
            if not target.exists():
                ERRORS.append(f'missing package target {uri}')
        elif not uri.startswith(('dart:', 'package:')):
            target = (file.parent / uri).resolve()
            if not target.exists():
                ERRORS.append(
                    f'missing {kind} from {file.relative_to(ROOT)}: {uri}'
                )

included_parts: dict[Path, Path] = {}
for library in LIB.rglob('*.dart'):
    for kind, uri in STATEMENT.findall(library.read_text(encoding='utf-8')):
        if kind == 'part':
            included_parts[(library.parent / uri).resolve()] = library.resolve()

for part, owner in included_parts.items():
    match = PART_OF.search(part.read_text(encoding='utf-8'))
    if not match:
        ERRORS.append(f'missing part-of declaration: {part.relative_to(ROOT)}')
        continue
    declared_owner = (part.parent / match.group(1)).resolve()
    if declared_owner != owner:
        ERRORS.append(f'part owner mismatch: {part.relative_to(ROOT)}')

for file in (LIB / 'src/domain').rglob('*.dart'):
    source = file.read_text(encoding='utf-8')
    if 'package:flutter' in source:
        ERRORS.append(f'domain depends on Flutter: {file.relative_to(ROOT)}')
    if '/presentation/' in source:
        ERRORS.append(f'domain depends on Presentation: {file.relative_to(ROOT)}')

for file in (LIB / 'src/application').rglob('*.dart'):
    source = file.read_text(encoding='utf-8')
    if 'package:flutter' in source:
        ERRORS.append(f'application depends on Flutter: {file.relative_to(ROOT)}')
    if '/presentation/' in source:
        ERRORS.append(f'application depends on Presentation: {file.relative_to(ROOT)}')

if ERRORS:
    print('\n'.join(f'ERROR: {error}' for error in ERRORS))
    sys.exit(1)

print(
    f'OK: {len(list(ROOT.rglob("*.dart")))} Dart files, '
    f'{len(included_parts)} part files, architecture boundaries satisfied.'
)
