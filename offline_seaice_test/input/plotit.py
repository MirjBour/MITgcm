import numpy as np
import matplotlib.pyplot as plt
import os
import sys
import cmocean.cm as cmo

sys.path.append('/Users/mlosch/python')
sys.path.append('/Users/mlosch/MITgcm/MITgcm/utils/python/MITgcmutils')
from myutils import *
from MITgcmutils import rdmds

#import xmitgcm

u = rdmds('UICE',np.nan)
v = rdmds('VICE',np.nan)
a = rdmds('AREA',np.nan)
# fx = rdmds('FORCEX',np.nan)
# fy = rdmds('FORCEY',np.nan)
# s1 = rdmds('SIGMA1',np.nan)
# s2 = rdmds('SIGMA2',np.nan)
# s12 = rdmds('SIGMA12',np.nan)

xu = rdmds('XG')*1e-3
xv = rdmds('XC')*1e-3
yu = rdmds('YC')*1e-3
yv = rdmds('YG')*1e-3

area_maskc = np.where(a>0,1,0)
area_maskw = np.where(a+np.roll(a,1,axis=-1)>0,1,0)
area_masks = np.where(a+np.roll(a,1,axis=-2)>0,1,0)

anti_maskw = (1-area_maskw)
anti_masks = (1-area_masks)

fig, ax = plt.subplots(2,1,sharex=True,sharey=True)


vm = 0.5
areaargs = dict(vmin=0,vmax=1,cmap=cmo.solar,alpha=.5) #,edgecolor='k')
pargs = dict(vmin=-vm,vmax=vm,cmap=cmo.delta)
cargs = dict(levels=np.linspace(-vm,vm,11),colors='k') #,linestyles=':',linewidths=2)

t=3
cma = ax[0].pcolormesh(xv,yu,sq(a[t,:,:]),**areaargs)
#ax[0].pcolormesh(xu,yu,sq(u[t,:,:]),alpha=1,**pargs)
ax[0].contour(xu,yu,sq(u[t,:,:]),**cargs)
cmu = ax[0].pcolormesh(xu,yu,sq(anti_maskw*u)[t,:,:],**pargs)

cam = ax[1].pcolormesh(xv,yu,sq(a[t,:,:]),**areaargs)
#ax[1].pcolormesh(xv,yv,sq(v[t,:,:]),alpha=1,**pargs)
ax[1].contour(xv,yv,sq(v[t,:,:]),**cargs)
cmv = ax[1].pcolormesh(xv,yv,sq(anti_masks*v)[t,:,:],**pargs)

plt.colorbar(cmu,ax=ax[0],location='right',extend='both',label='UICE')
plt.colorbar(cmv,ax=ax[1],location='right',extend='both',label='VICE')
plt.colorbar(cma,ax=ax,location='left',label='AREA',shrink=0.5)
