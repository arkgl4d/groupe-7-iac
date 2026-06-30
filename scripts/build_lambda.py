from pathlib import Path
import zipfile

root = Path(__file__).resolve().parent.parent
build_dir = root / '.lambda_build'
package_path = root / 'terraform' / 'lambda_package.zip'

if not build_dir.exists():
    raise SystemExit('Build directory not found: ' + str(build_dir))

package_path.parent.mkdir(parents=True, exist_ok=True)
with zipfile.ZipFile(package_path, 'w', zipfile.ZIP_DEFLATED) as archive:
    for path in sorted(build_dir.rglob('*')):
        archive.write(path, path.relative_to(build_dir))
print(f'Created {package_path}')
