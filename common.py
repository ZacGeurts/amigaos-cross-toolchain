#!/usr/bin/env python3

# Common utilities for building cross-toolchains.
# Provides reusable functions for managing file operations, executing commands,
# and handling build recipes, with support for variable interpolation and error handling.

from fnmatch import fnmatch
from glob import glob
from logging import debug, info, error
import contextlib
import os
import shutil
import site
import subprocess
import sys
import tarfile
import tempfile
from multiprocessing import cpu_count
from pathlib import Path
import sysconfig
import fileinput
import zipfile
import lhafile

VARS = {}

def setvar(**kwargs):
    VARS.update(kwargs)
    VARS.update({k: v.format(**VARS) for k, v in VARS.items() if isinstance(v, str)})

def fill_in(value):
    return value.format(**VARS) if isinstance(value, str) else value

def fill_in_args(fn):
    def wrapper(*args, **kwargs):
        return fn(*(fill_in(a) for a in args), **{k: fill_in(v) for k, v in kwargs.items()})
    return wrapper

def flatten(*args):
    queue = list(args)
    while queue:
        item = queue.pop(0)
        yield from (item if isinstance(item, (list, tuple)) else [item])

@fill_in_args
def panic(*args):
    error(*args)
    sys.exit(1)

@fill_in_args
def cmpver(op, v1, v2):
    v1, v2 = [int(x) for x in v1.split('.')], [int(x) for x in v2.split('.')]
    def _cmp(l1, l2): return 0 if not l1 and not l2 else -1 if not l1 else 1 if not l2 else (l1[0] - l2[0]) or _cmp(l1[1:], l2[1:])
    return {'eq': lambda x: x == 0, 'lt': lambda x: x < 0, 'gt': lambda x: x > 0}[op](_cmp(v1, v2))

@fill_in_args
def find_executable(name):
    path = os.environ.get('PATH', '/usr/bin:/bin:/usr/local/bin')
    return shutil.which(name, path=path) or panic(f'Executable "{name}" not found!')

@fill_in_args
def find(root, only_files=False, include=['*'], exclude=['']):
    return [str(p) for p in sorted(Path(root).rglob('*')) if (not only_files or p.is_file()) and any(fnmatch(p.name, pat) for pat in include) and not any(fnmatch(p.name, pat) for pat in exclude)]

@fill_in_args
def touch(name):
    Path(name).touch()

@fill_in_args
def mkdtemp(**kwargs):
    if 'dir' in kwargs and not Path(kwargs['dir']).is_dir(): mkdir(kwargs['dir'])
    return tempfile.mkdtemp(**kwargs)

@fill_in_args
def mkstemp(**kwargs):
    if 'dir' in kwargs and not Path(kwargs['dir']).is_dir(): mkdir(kwargs['dir'])
    fd, path = tempfile.mkstemp(**kwargs)
    return fd, path

@fill_in_args
def rmtree(*names):
    [shutil.rmtree(name, ignore_errors=True) for name in flatten(names) if Path(name).is_dir()]

@fill_in_args
def remove(*names):
    [os.remove(name) for name in flatten(names) if Path(name).is_file()]

@fill_in_args
def mkdir(*names):
    [os.makedirs(name, exist_ok=True) for name in flatten(names) if not Path(name).is_dir()]

@fill_in_args
def copy(src, dst):
    shutil.copy2(src, dst)

@fill_in_args
def copytree(src, dst, exclude=[]):
    mkdir(dst)
    [copy(p, Path(dst) / Path(p).relative_to(src)) for p in find(src) if p.name not in exclude]

@fill_in_args
def move(src, dst):
    shutil.move(src, dst)

@fill_in_args
def symlink(src, name):
    if not Path(name).is_symlink(): os.symlink(src, name)

@fill_in_args
def chmod(name, mode):
    os.chmod(name, mode)

@fill_in_args
def execute(*cmd, **kwargs):
    debug(f'execute {" ".join(cmd)}')
    try:
        subprocess.run(cmd, check=True, capture_output=True, text=True, **kwargs)
    except subprocess.CalledProcessError as e:
        error(f'Command failed: {" ".join(cmd)}\n{e.stderr}')
        raise

@fill_in_args
def textfile(*lines):
    fd, name = mkstemp(dir='{tmpdir}')
    os.write(fd, '\n'.encode() + '\n'.join(lines).encode() + '\n'.encode())
    os.close(fd)
    return name

@fill_in_args
def download(url, name):
    info(f'download "{url}" to "{name}"')
    import urllib.request
    with urllib.request.urlopen(url) as u, open(name, 'wb') as f:
        size = int(u.getheader('Content-Length', 0))
        info(f'download: {name}' + (f' (size: {size})' if size else ''))
        done = 0
        while buf := u.read(8192):
            done += len(buf)
            f.write(buf)
            if size: sys.stdout.write(f"\r{done} [{done*100/size:.2f}%]" + ' ' * 10)
            else: sys.stdout.write(f"\r{done}" + ' ' * 10)
            sys.stdout.flush()
    print()

@fill_in_args
def unarc(name):
    info(f'extract files from "{name}"')
    if name.endswith('.lha'):
        import lhafile
        with LhaFile(name) as arc:
            for item in arc.infolist():
                filename = item.filename.replace('\\', os.sep)
                mkdir(Path(filename).parent)
                if not Path(filename).is_dir(): Path(filename).write_bytes(arc.read(item.filename))
    elif name.endswith(('.tar.gz', '.tar.bz2')):
        with tarfile.open(name) as arc: arc.extractall()
    elif name.endswith('.zip'):
        with zipfile.ZipFile(name) as arc: arc.extractall()
    else: raise RuntimeError(f'Unrecognized archive: "{name}"')

@fill_in_args
def fix_python_shebang(filename, prefix):
    PYTHON, SITEDIR = fill_in('{python}'), Path(prefix) / '{sitedir}'
    with fileinput.input(filename, inplace=True) as f:
        for line in f:
            print(f'#!/usr/bin/env PYTHONPATH={SITEDIR} {PYTHON}' if line.startswith('#!') else line.rstrip())

@fill_in_args
def find_site_dir(directory):
    dirname = Path(directory)
    exec_prefix = sysconfig.get_config_var('EXEC_PREFIX')
    destlib = sysconfig.get_config_var('LIBDEST')
    if exec_prefix is None:
        exec_prefix = '/usr'
        info(f"Warning: EXEC_PREFIX not found in sysconfig, using fallback {exec_prefix}")
    if destlib is None:
        panic("Could not determine python's library directory")
    return dirname / Path(destlib).relative_to(exec_prefix)

@fill_in_args
def add_site_dir(directory):
    site.addsitedir(str(find_site_dir(directory)))

@contextlib.contextmanager
def cwd(name):
    old = os.getcwd()
    if not Path(name).exists():
        mkdir(name)
    debug(f'enter directory: "{name}"')
    os.chdir(name)
    try:
        yield
    finally:
        os.chdir(old)

@contextlib.contextmanager
def env(**kwargs):
    backup = {k: os.environ.get(k) for k in kwargs}
    [os.environ.__setitem__(k, fill_in(v)) for k, v in kwargs.items()]
    try:
        yield
    finally:
        [os.environ.__setitem__(k, v) if v is not None else os.environ.pop(k, None) for k, v in backup.items()]

def recipe(name, nargs=0):
    def decorator(fn):
        @fill_in_args
        def wrapper(*args):
            target = '-'.join([args[0], name.replace('.', '-')] + list(args[1:]) if args else [name.replace('.', '-')])
            stamp = f'{{stamps}}/{target.replace("_", "-").replace("/", "-")}'
            mkdir('{stamps}')
            if not Path(stamp).exists():
                fn(*args)
                touch(stamp)
            else:
                info(f'already: "{target}"')
        return wrapper
    return decorator

@fill_in_args
def require_header(headers, lang='c', message=None, include_dirs=None):
    """Check if header files are available by attempting to compile a test file."""
    info(f'Checking for headers: {headers}')
    compiler = 'gcc' if lang == 'c' else 'g++'
    test_code = '\n'.join(f'#include <{h}>' for h in headers) + '\nint main() { return 0; }'
    fd, test_file = mkstemp(suffix='.c' if lang == 'c' else '.cpp', dir='{tmpdir}')
    with open(fd, 'w') as f:
        f.write(test_code)
    try:
        cmd = [compiler, test_file, '-o', '/dev/null']
        if include_dirs:
            cmd.extend(['-I' + dir for dir in include_dirs])
        execute(*cmd)
    except subprocess.CalledProcessError:
        panic(message or f'Missing required headers: {headers}')
    finally:
        remove(test_file)

@recipe('pyinstall', 1)
def pyinstall(name, prefix='{prefix}'):
    info(f'Installing Python package {name}')
    with cwd(f'{{build}}/{{name}}'):
        execute('{python}', 'setup.py', 'build')
        execute('{python}', 'setup.py', 'install', f'--prefix={prefix}')