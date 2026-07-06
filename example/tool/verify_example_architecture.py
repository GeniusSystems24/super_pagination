#!/usr/bin/env python3
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
LIB = ROOT / 'lib'
BASELINE_ROUTE_COUNT = 60
errors: list[str] = []

# Local package imports and exports must resolve.
for file in LIB.rglob('*.dart'):
    source = file.read_text(encoding='utf-8', errors='ignore')
    for match in re.finditer(r"(?:import|export|part)\s+['\"]([^'\"]+)['\"]", source):
        uri = match.group(1)
        if uri.startswith('package:super_pagination_example/'):
            target = LIB / uri.split('/', 1)[1]
            if not target.exists():
                errors.append(f'Missing target: {file.relative_to(ROOT)} -> {uri}')
        elif uri.startswith('.'):
            target = (file.parent / uri).resolve()
            if not target.exists():
                errors.append(f'Missing relative target: {file.relative_to(ROOT)} -> {uri}')


# Local import/export graph must remain acyclic.
files = {file.resolve() for file in LIB.rglob('*.dart')}
graph = {file: set() for file in files}
for file in files:
    source = file.read_text(encoding='utf-8', errors='ignore')
    for uri in re.findall(r"(?:import|export|part)\s+['\"]([^'\"]+)['\"]", source):
        if uri.startswith('package:super_pagination_example/'):
            target = (LIB / uri.split('/', 1)[1]).resolve()
        elif uri.startswith('.'):
            target = (file.parent / uri).resolve()
        else:
            continue
        if target in files:
            graph[file].add(target)

visiting: set[Path] = set()
visited: set[Path] = set()

def visit(node: Path, trail: list[Path]) -> None:
    if node in visiting:
        start = trail.index(node)
        cycle = trail[start:] + [node]
        errors.append('Import cycle: ' + ' -> '.join(str(x.relative_to(ROOT)) for x in cycle))
        return
    if node in visited:
        return
    visiting.add(node)
    trail.append(node)
    for dependency in graph[node]:
        visit(dependency, trail)
    trail.pop()
    visiting.remove(node)
    visited.add(node)

for file in files:
    visit(file, [])

# Shared inward layers must stay framework/implementation independent.
for layer in [LIB / 'shared/domain', LIB / 'shared/application']:
    for file in layer.rglob('*.dart'):
        source = file.read_text(encoding='utf-8', errors='ignore')
        forbidden = ['package:flutter/', '/infrastructure/', '/presentation/']
        for token in forbidden:
            if token in source:
                errors.append(f'Boundary violation in {file.relative_to(ROOT)}: {token}')

# Non-Firebase presentation must not import implementations directly.
for folder in [
    'features/home/presentation',
    'features/pagination_examples/presentation',
    'features/stream_examples/presentation',
    'features/search_examples/presentation',
    'features/error_examples/presentation',
    'shared/presentation',
]:
    for file in (LIB / folder).rglob('*.dart'):
        if '/infrastructure/' in file.read_text(encoding='utf-8', errors='ignore'):
            errors.append(f'Presentation imports infrastructure: {file.relative_to(ROOT)}')

router = LIB / 'app/routing/app_router.dart'
router_source = router.read_text(encoding='utf-8')
route_classes = set(re.findall(r'(?m)^class\s+(\w+Route)\s+extends', router_source))
route_paths = re.findall(r"path:\s*'([^']+)'", router_source)
if len(route_classes) != BASELINE_ROUTE_COUNT:
    errors.append(f'Expected {BASELINE_ROUTE_COUNT} route classes, found {len(route_classes)}')
if len(route_paths) != BASELINE_ROUTE_COUNT:
    errors.append(f'Expected {BASELINE_ROUTE_COUNT} route path declarations, found {len(route_paths)}')

# Legacy locations are export shims.
for folder in ['models', 'services', 'utils', 'widgets', 'screens', 'router']:
    path = LIB / folder
    if not path.exists():
        errors.append(f'Missing compatibility directory: {folder}')
        continue
    for file in path.rglob('*.dart'):
        if file.name == 'app_router.g.dart':
            continue
        if 'export ' not in file.read_text(encoding='utf-8', errors='ignore'):
            errors.append(f'Compatibility file is not an export: {file.relative_to(ROOT)}')

if errors:
    print('\n'.join(f'ERROR: {error}' for error in errors))
    sys.exit(1)

print('Example architecture verification passed.')
print(f'Dart files: {sum(1 for _ in LIB.rglob("*.dart"))}')
print(f'Route classes: {len(route_classes)}')
print(f'Route path declarations: {len(route_paths)}')
