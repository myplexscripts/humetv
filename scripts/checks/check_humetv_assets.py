"""Fail if a UI symbol loses its bundled Lucide asset or a font is missing."""
from pathlib import Path
import re
import xml.etree.ElementTree as ET

root = Path(__file__).resolve().parents[2]
source = (root / 'lib/widgets/lucide_symbol_assets.dart').read_text()
entries = dict(re.findall(r"Symbols\.(\w+): '([^']+)'", source))
used = set()
for path in (root / 'lib').rglob('*.dart'):
    if path.name != 'lucide_symbol_assets.dart':
        used.update(re.findall(r'Symbols\.(\w+)', path.read_text()))
assert used <= entries.keys(), f'Missing Lucide mapping: {used - entries.keys()}'
for asset in set(entries.values()):
    svg = ET.parse(root / asset).getroot()
    assert svg.attrib['viewBox'] == '0 0 24 24', asset
for weight in (400, 500, 600, 700):
    path = root / f'assets/fonts/Inter-{weight}.ttf'
    assert path.read_bytes()[:4] == b'\x00\x01\x00\x00', path
assert (root / 'assets/fonts/OFL-Inter.txt').is_file()
assert (root / 'assets/lucide/LICENSE').is_file()
print(f'Validated {len(used)} semantic icons, {len(set(entries.values()))} SVGs and four Inter weights.')
