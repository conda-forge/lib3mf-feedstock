import ctypes.util
import platform
import os.path
import sys

from .Lib3MF import *

libname = ctypes.util.find_library("3mf")
if not libname and platform.system() == "Windows":
    libname = os.path.join(
        os.path.dirname(sys.executable), "Library", "bin", "lib3mf.dll"
    )
    if not os.path.isfile(libname):
        libname = None


if libname is None:
    raise ImportError("Could not find required library lib3mf")


def get_library_path() -> str:
    return libname


def get_library_path_for_wrapper() -> str:
    return libname


def get_wrapper():
    try:
        return Wrapper(get_library_path_for_wrapper())
    except ELib3MFException as e:
        print("Failed to initialize the Lib3MF wrapper: ", e)
        raise
