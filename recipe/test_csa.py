import ctypes
import math
import os


class Point(ctypes.Structure):
    _fields_ = [("x", ctypes.c_double), ("y", ctypes.c_double), ("z", ctypes.c_double)]


prefix = os.environ["PREFIX"]
library = (
    os.path.join(prefix, "Library", "bin", "csa.dll")
    if os.name == "nt"
    else os.path.join(prefix, "lib", "libcsa.so")
)
csa = ctypes.CDLL(library)
csa.csa_create.restype = ctypes.c_void_p
csa.csa_addpoints.argtypes = [ctypes.c_void_p, ctypes.c_int, ctypes.POINTER(Point)]
csa.csa_calculatespline.argtypes = [ctypes.c_void_p]
csa.csa_approximatepoint.argtypes = [ctypes.c_void_p, ctypes.POINTER(Point)]
csa.csa_destroy.argtypes = [ctypes.c_void_p]

points = (Point * 100)(
    *(Point(x, y, x + 2 * y) for x in range(10) for y in range(10))
)
approximation = csa.csa_create()
assert approximation
csa.csa_addpoints(approximation, len(points), points)
csa.csa_calculatespline(approximation)
for x, y in [(4.0, 4.0), (4.25, 4.75)]:
    point = Point(x, y, 0)
    csa.csa_approximatepoint(approximation, ctypes.byref(point))
    assert math.isclose(point.z, x + 2 * y, rel_tol=1e-6, abs_tol=1e-6), point.z
csa.csa_destroy(approximation)
