import numpy as np
from myutils import *

nx=80
ny=42

ice = np.zeros((ny,nx))

ice[11:31,20:60] = 1.

writefield('ice_floe.bin',ice)
