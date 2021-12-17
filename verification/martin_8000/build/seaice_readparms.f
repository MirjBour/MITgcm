












C     *==========================================================*
C     | SEAICE_OPTIONS.h
C     | o CPP options file for sea ice package.
C     *==========================================================*
C     | Use this file for selecting options within the sea ice
C     | package.
C     *==========================================================*








CBOP
C !ROUTINE: CPP_OPTIONS.h
C !INTERFACE:
C #include "CPP_OPTIONS.h"

C !DESCRIPTION:
C *==================================================================*
C | main CPP options file for the model:
C | Control which optional features to compile in model/src code.
C *==================================================================*
CEOP

C CPP flags controlling particular source code features

C-- Forcing code options:

C o Shortwave heating as extra term in external_forcing.F
C Note: this should be a run-time option

C o Include/exclude Geothermal Heat Flux at the bottom of the ocean

C o Allow to account for heating due to friction (and momentum dissipation)

C o Allow mass source or sink of Fluid in the interior
C   (3-D generalisation of oceanic real-fresh water flux)

C o Include pressure loading code

C o Include/exclude balancing surface forcing fluxes code

C o Include/exclude balancing surface forcing relaxation code

C o Include/exclude checking for negative salinity

C-- Options to discard parts of the main code:

C o Exclude/allow external forcing-fields load
C   this allows to read & do simple linear time interpolation of oceanic
C   forcing fields, if no specific pkg (e.g., EXF) is used to compute them.

C o Include/exclude phi_hyd calculation code

C o Include/exclude sound speed calculation code
C o (Note that this is a diagnostic from Del Grasso algorithm, not derived from EOS)

C-- Vertical mixing code options:

C o Include/exclude call to S/R CONVECT

C o Include/exclude call to S/R CALC_DIFFUSIVITY

C o Allow full 3D specification of vertical diffusivity

C o Allow latitudinally varying BryanLewis79 vertical diffusivity

C o Exclude/allow partial-cell effect (physical or enhanced) in vertical mixing
C   this allows to account for partial-cell in vertical viscosity and diffusion,
C   either from grid-spacing reduction effect or as artificially enhanced mixing
C   near surface & bottom for too thin grid-cell

C o Exclude/allow to use isotropic 3-D Smagorinsky viscosity as diffusivity
C   for tracers (after scaling by constant Prandtl number)

C-- Time-stepping code options:

C o Include/exclude combined Surf.Pressure and Drag Implicit solver code

C o Include/exclude Implicit vertical advection code

C o Include/exclude AdamsBashforth-3rd-Order code

C o Include/exclude Quasi-Hydrostatic Stagger Time-step AdamsBashforth code

C-- Model formulation options:

C o Allow/exclude "Exact Convervation" of fluid in Free-Surface formulation
C   that ensures that d/dt(eta) is exactly equal to - Div.Transport

C o Allow the use of Non-Linear Free-Surface formulation
C   this implies that grid-cell thickness (hFactors) varies with time
C o Disable code for rStar coordinate and/or code for Sigma coordinate
c#define DISABLE_RSTAR_CODE
c#define DISABLE_SIGMA_CODE

C o Include/exclude nonHydrostatic code

C o Include/exclude GM-like eddy stress in momentum code

C-- Algorithm options:

C o Include/exclude code for Non Self-Adjoint (NSA) conjugate-gradient solver

C o Include/exclude code for single reduction Conjugate-Gradient solver

C o Choices for implicit solver routines solve_*diagonal.F
C   The following has low memory footprint, but not suitable for AD
C   The following one suitable for AD but does not vectorize

C-- Retired code options:

C o ALLOW isotropic scaling of harmonic and bi-harmonic terms when
C   using an locally isotropic spherical grid with (dlambda) x (dphi*cos(phi))
C *only for use on a lat-lon grid*
C   Setting this flag here affects both momentum and tracer equation unless
C   it is set/unset again in other header fields (e.g., GAD_OPTIONS.h).
C   The definition of the flag is commented to avoid interference with
C   such other header files.
C   The preferred method is specifying a value for viscAhGrid or viscA4Grid
C   in data which is then automatically scaled by the grid size;
C   the old method of specifying viscAh/viscA4 and this flag is provided
C   for completeness only (and for use with the adjoint).
c#define ISOTROPIC_COS_SCALING

C o This flag selects the form of COSINE(lat) scaling of bi-harmonic term.
C *only for use on a lat-lon grid*
C   Has no effect if ISOTROPIC_COS_SCALING is undefined.
C   Has no effect on vector invariant momentum equations.
C   Setting this flag here affects both momentum and tracer equation unless
C   it is set/unset again in other header fields (e.g., GAD_OPTIONS.h).
C   The definition of the flag is commented to avoid interference with
C   such other header files.
c#define COSINEMETH_III

C o Use "OLD" UV discretisation near boundaries (*not* recommended)
C   Note - only works with pkg/mom_fluxform and "no_slip_sides=.FALSE."
C          because the old code did not have no-slip BCs

C o Use LONG.bin, LATG.bin, etc., initialization for ini_curviliear_grid.F
C   Default is to use "new" grid files (OLD_GRID_IO undef) but OLD_GRID_IO
C   is still useful with, e.g., single-domain curvilinear configurations.

C o Use old EXTERNAL_FORCING_U,V,T,S subroutines (for backward compatibility)

C-- Other option files:

C o Execution environment support options
CBOP
C     !ROUTINE: CPP_EEOPTIONS.h
C     !INTERFACE:
C     include "CPP_EEOPTIONS.h"
C
C     !DESCRIPTION:
C     *==========================================================*
C     | CPP\_EEOPTIONS.h                                         |
C     *==========================================================*
C     | C preprocessor "execution environment" supporting        |
C     | flags. Use this file to set flags controlling the        |
C     | execution environment in which a model runs - as opposed |
C     | to the dynamical problem the model solves.               |
C     | Note: Many options are implemented with both compile time|
C     |       and run-time switches. This allows options to be   |
C     |       removed altogether, made optional at run-time or   |
C     |       to be permanently enabled. This convention helps   |
C     |       with the data-dependence analysis performed by the |
C     |       adjoint model compiler. This data dependency       |
C     |       analysis can be upset by runtime switches that it  |
C     |       is unable to recoginise as being fixed for the     |
C     |       duration of an integration.                        |
C     |       A reasonable way to use these flags is to          |
C     |       set all options as selectable at runtime but then  |
C     |       once an experimental configuration has been        |
C     |       identified, rebuild the code with the appropriate  |
C     |       options set at compile time.                       |
C     *==========================================================*
CEOP


C     In general the following convention applies:
C     ALLOW  - indicates an feature will be included but it may
C     CAN      have a run-time flag to allow it to be switched
C              on and off.
C              If ALLOW or CAN directives are "undef'd" this generally
C              means that the feature will not be available i.e. it
C              will not be included in the compiled code and so no
C              run-time option to use the feature will be available.
C
C     ALWAYS - indicates the choice will be fixed at compile time
C              so no run-time option will be present

C=== Macro related options ===
C--   Control storage of floating point operands
C     On many systems it improves performance only to use
C     8-byte precision for time stepped variables.
C     Constant in time terms ( geometric factors etc.. )
C     can use 4-byte precision, reducing memory utilisation and
C     boosting performance because of a smaller working set size.
C     However, on vector CRAY systems this degrades performance.
C     Enable to switch REAL4_IS_SLOW from genmake2 (with LET_RS_BE_REAL4):

C--   Control use of "double" precision constants.
C     Use D0 where it means REAL*8 but not where it means REAL*16

C=== IO related options ===
C--   Flag used to indicate whether Fortran formatted write
C     and read are threadsafe. On SGI the routines can be thread
C     safe, on Sun it is not possible - if you are unsure then
C     undef this option.

C--   Flag used to indicate whether Binary write to Local file (i.e.,
C     a different file for each tile) and read are thread-safe.

C--   Flag to turn off the writing of error message to ioUnit zero

C--   Alternative formulation of BYTESWAP, faster than
C     compiler flag -byteswapio on the Altix.

C--   Flag to turn on old default of opening scratch files with the
C     STATUS='SCRATCH' option. This method, while perfectly FORTRAN-standard,
C     caused filename conflicts on some multi-node/multi-processor platforms
C     in the past and has been replace by something (hopefully) more robust.

C--   Flag defined for eeboot_minimal.F, eeset_parms.F and open_copy_data_file.F
C     to write STDOUT, STDERR and scratch files from process 0 only.
C WARNING: to use only when absolutely confident that the setup is working
C     since any message (error/warning/print) from any proc <> 0 will be lost.

C=== MPI, EXCH and GLOBAL_SUM related options ===
C--   Flag turns off MPI_SEND ready_to_receive polling in the
C     gather_* subroutines to speed up integrations.

C--   Control MPI based parallel processing
CXXX We no longer select the use of MPI via this file (CPP_EEOPTIONS.h)
CXXX To use MPI, use an appropriate genmake2 options file or use
CXXX genmake2 -mpi .
CXXX #undef  ALLOW_USE_MPI

C--   Control use of communication that might overlap computation.
C     Under MPI selects/deselects "non-blocking" sends and receives.
C--   Control use of communication that is atomic to computation.
C     Under MPI selects/deselects "blocking" sends and receives.

C--   Control XY periodicity in processor to grid mappings
C     Note: Model code does not need to know whether a domain is
C           periodic because it has overlap regions for every box.
C           Model assume that these values have been
C           filled in some way.

C--   disconnect tiles (no exchange between tiles, just fill-in edges
C     assuming locally periodic subdomain)

C--   Always cumulate tile local-sum in the same order by applying MPI allreduce
C     to array of tiles ; can get slower with large number of tiles (big set-up)

C--   Alternative way of doing global sum without MPI allreduce call
C     but instead, explicit MPI send & recv calls. Expected to be slower.

C--   Alternative way of doing global sum on a single CPU
C     to eliminate tiling-dependent roundoff errors. Note: This is slow.

C=== Other options (to add/remove pieces of code) ===
C--   Flag to turn on checking for errors from all threads and procs
C     (calling S/R STOP_IF_ERROR) before stopping.

C--   Control use of communication with other component:
C     allow to import and export from/to Coupler interface.

C--   Activate some pieces of code for coupling to GEOS AGCM


CBOP
C     !ROUTINE: CPP_EEMACROS.h
C     !INTERFACE:
C     include "CPP_EEMACROS.h"
C     !DESCRIPTION:
C     *==========================================================*
C     | CPP_EEMACROS.h
C     *==========================================================*
C     | C preprocessor "execution environment" supporting
C     | macros. Use this file to define macros for  simplifying
C     | execution environment in which a model runs - as opposed
C     | to the dynamical problem the model solves.
C     *==========================================================*
CEOP


C     In general the following convention applies:
C     ALLOW  - indicates an feature will be included but it may
C     CAN      have a run-time flag to allow it to be switched
C              on and off.
C              If ALLOW or CAN directives are "undef'd" this generally
C              means that the feature will not be available i.e. it
C              will not be included in the compiled code and so no
C              run-time option to use the feature will be available.
C
C     ALWAYS - indicates the choice will be fixed at compile time
C              so no run-time option will be present

C     Flag used to indicate which flavour of multi-threading
C     compiler directives to use. Only set one of these.
C     USE_SOLARIS_THREADING  - Takes directives for SUN Workshop
C                              compiler.
C     USE_KAP_THREADING      - Takes directives for Kuck and
C                              Associates multi-threading compiler
C                              ( used on Digital platforms ).
C     USE_IRIX_THREADING     - Takes directives for SGI MIPS
C                              Pro Fortran compiler.
C     USE_EXEMPLAR_THREADING - Takes directives for HP SPP series
C                              compiler.
C     USE_C90_THREADING      - Takes directives for CRAY/SGI C90
C                              system F90 compiler.






C--   Define the mapping for the _BARRIER macro
C     On some systems low-level hardware support can be accessed through
C     compiler directives here.

C--   Define the mapping for the BEGIN_CRIT() and  END_CRIT() macros.
C     On some systems we simply execute this section only using the
C     master thread i.e. its not really a critical section. We can
C     do this because we do not use critical sections in any critical
C     sections of our code!

C--   Define the mapping for the BEGIN_MASTER_SECTION() and
C     END_MASTER_SECTION() macros. These are generally implemented by
C     simply choosing a particular thread to be "the master" and have
C     it alone execute the BEGIN_MASTER..., END_MASTER.. sections.

CcnhDebugStarts
C      Alternate form to the above macros that increments (decrements) a counter each
C      time a MASTER section is entered (exited). This counter can then be checked in barrier
C      to try and detect calls to BARRIER within single threaded sections.
C      Using these macros requires two changes to Makefile - these changes are written
C      below.
C      1 - add a filter to the CPP command to kill off commented _MASTER lines
C      2 - add a filter to the CPP output the converts the string N EWLINE to an actual newline.
C      The N EWLINE needs to be changes to have no space when this macro and Makefile changes
C      are used. Its in here with a space to stop it getting parsed by the CPP stage in these
C      comments.
C      #define IF ( a .EQ. 1 ) THEN  IF ( a .EQ. 1 ) THEN  N EWLINE      CALL BARRIER_MS(a)
C      #define ENDIF    CALL BARRIER_MU(a) N EWLINE        ENDIF
C      'CPP = cat $< | $(TOOLSDIR)/set64bitConst.sh |  grep -v '^[cC].*_MASTER' | cpp  -traditional -P'
C      .F.f:
C      $(CPP) $(DEFINES) $(INCLUDES) |  sed 's/N EWLINE/\n/' > $@
CcnhDebugEnds

C--   Control storage of floating point operands
C     On many systems it improves performance only to use
C     8-byte precision for time stepped variables.
C     Constant in time terms ( geometric factors etc.. )
C     can use 4-byte precision, reducing memory utilisation and
C     boosting performance because of a smaller working
C     set size. However, on vector CRAY systems this degrades
C     performance.
C- Note: global_sum/max macros were used to switch to  JAM routines (obsolete);
C  in addition, since only the R4 & R8 S/R are coded, GLOBAL RS & RL macros
C  enable to call the corresponding R4 or R8 S/R.



C- Note: a) exch macros were used to switch to  JAM routines (obsolete)
C        b) exch R4 & R8 macros are not practically used ; if needed,
C           will directly call the corrresponding S/R.

C--   Control use of JAM routines for Artic network (no longer supported)
C     These invoke optimized versions of "exchange" and "sum" that
C     utilize the programmable aspect of Artic cards.
CXXX No longer supported ; started to remove JAM routines.
CXXX #ifdef LETS_MAKE_JAM
CXXX #define CALL GLOBAL_SUM_R8 ( a, b) CALL GLOBAL_SUM_R8_JAM ( a, b)
CXXX #define CALL GLOBAL_SUM_R8 ( a, b ) CALL GLOBAL_SUM_R8_JAM ( a, b )
CXXX #define CALL EXCH_XY_RS ( a, b ) CALL EXCH_XY_R8_JAM ( a, b )
CXXX #define CALL EXCH_XY_RL ( a, b ) CALL EXCH_XY_R8_JAM ( a, b )
CXXX #define CALL EXCH_XYZ_RS ( a, b ) CALL EXCH_XYZ_R8_JAM ( a, b )
CXXX #define CALL EXCH_XYZ_RL ( a, b ) CALL EXCH_XYZ_R8_JAM ( a, b )
CXXX #endif

C--   Control use of "double" precision constants.
C     Use d0 where it means REAL*8 but not where it means REAL*16

C--   Substitue for 1.D variables
C     Sun compilers do not use 8-byte precision for literals
C     unless .Dnn is specified. CRAY vector machines use 16-byte
C     precision when they see .Dnn which runs very slowly!

C--   Set the format for writing processor IDs, e.g. in S/R eeset_parms
C     and S/R open_copy_data_file. The default of I9.9 should work for
C     a long time (until we will use 10e10 processors and more)



C o Include/exclude single header file containing multiple packages options
C   (AUTODIFF, COST, CTRL, ECCO, EXF ...) instead of the standard way where
C   each of the above pkg get its own options from its specific option file.
C   Although this method, inherited from ECCO setup, has been traditionally
C   used for all adjoint built, work is in progress to allow to use the
C   standard method also for adjoint built.
c#ifdef 
c# include "ECCO_CPPOPTIONS.h"
c#endif


C     Package-specific Options & Macros go here

C--   Write "text-plots" of certain fields in STDOUT for debugging.

C--   Allow sea-ice dynamic code.
C     This option is provided to allow use of TAMC
C     on the thermodynamics component of the code only.
C     Sea-ice dynamics can also be turned off at runtime
C     using variable SEAICEuseDYNAMICS.

C--   By default, the sea-ice package uses its own integrated bulk
C     formulae to compute fluxes (fu, fv, EmPmR, Qnet, and Qsw) over
C     open-ocean.  When this flag is set, these variables are computed
C     in a separate external package, for example, pkg/exf, and then
C     modified for sea-ice effects by pkg/seaice.

C--   This CPP flag has been retired.  The number of ice categories
C     used to solve for seaice flux is now specified by run-time
C     parameter SEAICE_multDim.
C     Note: be aware of pickup_seaice.* compatibility issues when
C     restarting a simulation with a different number of categories.
c#define SEAICE_MULTICATEGORY

C--   run with sea Ice Thickness Distribution (ITD);
C     set number of categories (nITD) in SEAICE_SIZE.h

C--   Since the missing sublimation term is now included
C     this flag is needed for backward compatibility

C--   Suspected missing term in coupled ocn-ice heat budget (to be confirmed)

C--   Default is constant seaice salinity (SEAICE_salt0); Define the following
C     flag to consider (space & time) variable salinity: advected and forming
C     seaice with a fraction (=SEAICE_saltFrac) of freezing seawater salinity.
C- Note: SItracer also offers an alternative way to handle variable salinity.

C--   Tracers of ice and/or ice cover.

C--   Enable grease ice parameterization
C     The grease ice parameterization delays formation of solid
C     sea ice from frazil ice by a time constant and provides a
C     dynamic calculation of the initial solid sea ice thickness
C     HO as a function of winds, currents and available grease ice
C     volume. Grease ice does not significantly reduce heat loss
C     from the ocean in winter and area covered by grease is thus
C     handled like open water.
C     (For details see Smedsrud and Martin, 2014, Ann.Glac.)
C     Set SItrName(1) = 'grease' in namelist SEAICE_PARM03 in data.seaice
C     then output SItr01 is SItrNameLong(1) = 'grease ice volume fraction',
C     with SItrUnit(1) = '[0-1]', which needs to be multiplied by SIheff
C     to yield grease ice volume. Additionally, the actual grease ice
C     layer thickness (diagnostic SIgrsLT) can be saved.
C--   grease ice uses SItracer:

C--   Historically, the seaice model was discretized on a B-Grid. This
C     discretization should still work but it is not longer actively tested
C     and supported. The following flag should always be set in order to use
C     the operational C-grid discretization.

C--   Only for the C-grid version it is possible to
C     enable advection of sea ice momentum
C     enable JFNK code by defining the following flag
C     enable Krylov code by defining the following flag
C     enable this flag to reproduce old verification results for JFNK
C     enable LSR to use global (multi-tile) tri-diagonal solver
C     enable EVP code by defining the following flag
C--   When set use SEAICE_zetaMin and SEAICE_evpDampC to limit viscosities
C     from below and above in seaice_evp: not necessary, and not recommended
C     smooth regularization (without max-function) of delta for
C     better differentiability
C     regularize zeta to zmax with a smooth tanh-function instead
C     of a min(zeta,zmax). This improves convergence of iterative
C     solvers (Lemieux and Tremblay 2009, JGR). No effect on EVP
C     allow the truncated ellipse rheology (runtime flag SEAICEuseTEM)
C     allow using a damage parameter that records violations of a Mohr
C     Coulomb criterion for stress
C     allow Maxwell Elasto-Brittle rheology (runtime flat SEAICEuseMEB);
C     the MEB code re-uses a lot of the VP code and can be used together
C     with all implicit solvers, although the parameter tuning requires
C     some care and not all combinations give satisfactory results; you need
C     an accurate solution of the momentum equations to reduce the amount
C     of error accumulation
C     MEB always needs the damage field
C     Use LSR vector code; not useful on non-vector machines, because it
C     slows down convergence considerably, but the extra iterations are
C     more than made up by the much faster code on vector machines. For
C     the only regularly test vector machine these flags a specified
C     in the build options file SUPER-UX_SX-8_sxf90_awi, so that we comment
C     them out here.
C     Use zebra-method (alternate lines) for line-successive-relaxation
C     This modification improves the convergence of the vector code
C     dramatically, so that is may actually be useful in general, but
C     that needs to be tested. Can be used without vectorization options.
C     Use parameterisation of grounding ice for a better representation
C     of fastice in shallow seas

C--   When set limit the Ice-Loading to mass of 1/5 of Surface ocean grid-box
C--   When set use SEAICE_clipVelocties = .true., to clip U/VICE at 40cm/s,
C     not recommended
C--   When set cap the sublimation latent heat flux in solve4temp according
C     to the available amount of ice+snow. Otherwise this term is treated
C     like all of the others -- residuals heat and fw stocks are passed to
C     the ocean at the end of seaice_growth in a conservative manner.
C     SEAICE_CAP_SUBLIM is not needed as of now, but kept just in case.

C--   Enable the adjointable sea-ice thermodynamic model
C     uses seaice_growth_adx.F and seaice_solve4temp_adx.F

C--   Enable free drift code

C--   pkg/seaice cost functions compile flags
c       >>> Sea-ice volume (requires pkg/cost)
c       >>> Sea-ice misfit to obs (requires pkg/cost and ecco)


CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***

CBOP
C     !ROUTINE: SEAICE_READPARMS
C     !INTERFACE:
      SUBROUTINE SEAICE_READPARMS( myThid )

C     !DESCRIPTION: \bv
C     *==========================================================*
C     | S/R SEAICE_READPARMS
C     | o Routine to read in file data.seaice
C     *==========================================================*
C     \ev

C     !USES:
      IMPLICIT NONE

C     === Global variables ===
C $Header: /u/gcmpack/MITgcm/verification/offline_exf_seaice/code/SIZE.h,v 1.4 2012/12/08 00:34:29 jmc Exp $
C $Name:  $

C
CBOP
C    !ROUTINE: SIZE.h
C    !INTERFACE:
C    include SIZE.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | SIZE.h Declare size of underlying computational grid.
C     *==========================================================*
C     | The design here support a three-dimensional model grid
C     | with indices I,J and K. The three-dimensional domain
C     | is comprised of nPx*nSx blocks of size sNx along one axis
C     | nPy*nSy blocks of size sNy along another axis and one
C     | block of size Nz along the final axis.
C     | Blocks have overlap regions of size OLx and OLy along the
C     | dimensions that are subdivided.
C     *==========================================================*
C     \ev
CEOP
C     Voodoo numbers controlling data layout.
C     sNx :: No. X points in sub-grid.
C     sNy :: No. Y points in sub-grid.
C     OLx :: Overlap extent in X.
C     OLy :: Overlat extent in Y.
C     nSx :: No. sub-grids in X.
C     nSy :: No. sub-grids in Y.
C     nPx :: No. of processes to use in X.
C     nPy :: No. of processes to use in Y.
C     Nx  :: No. points in X for the total domain.
C     Ny  :: No. points in Y for the total domain.
C     Nr  :: No. points in Z for full process domain.
      INTEGER sNx
      INTEGER sNy
      INTEGER OLx
      INTEGER OLy
      INTEGER nSx
      INTEGER nSy
      INTEGER nPx
      INTEGER nPy
      INTEGER Nx
      INTEGER Ny
      INTEGER Nr
      PARAMETER (
     &           sNx =  65,
     &           sNy =  65,
     &           OLx =   4,
     &           OLy =   4,
     &           nSx =   1,
     &           nSy =   1,
     &           nPx =   1,
     &           nPy =   1,
     &           Nx  = sNx*nSx*nPx,
     &           Ny  = sNy*nSy*nPy,
     &           Nr  =  1 )

C     MAX_OLX :: Set to the maximum overlap region size of any array
C     MAX_OLY    that will be exchanged. Controls the sizing of exch
C                routine buffers.
      INTEGER MAX_OLX
      INTEGER MAX_OLY
      PARAMETER ( MAX_OLX = OLx,
     &            MAX_OLY = OLy )

      INTEGER     nobcs
      PARAMETER ( nobcs = 4 )

CBOP
C     !ROUTINE: EEPARAMS.h
C     !INTERFACE:
C     include "EEPARAMS.h"
C
C     !DESCRIPTION:
C     *==========================================================*
C     | EEPARAMS.h                                               |
C     *==========================================================*
C     | Parameters for "execution environemnt". These are used   |
C     | by both the particular numerical model and the execution |
C     | environment support routines.                            |
C     *==========================================================*
CEOP

C     ========  EESIZE.h  ========================================

C     MAX_LEN_MBUF  :: Default message buffer max. size
C     MAX_LEN_FNAM  :: Default file name max. size
C     MAX_LEN_PREC  :: Default rec len for reading "parameter" files

      INTEGER MAX_LEN_MBUF
      PARAMETER ( MAX_LEN_MBUF = 512 )
      INTEGER MAX_LEN_FNAM
      PARAMETER ( MAX_LEN_FNAM = 512 )
      INTEGER MAX_LEN_PREC
      PARAMETER ( MAX_LEN_PREC = 200 )

C     MAX_NO_THREADS  :: Maximum number of threads allowed.
CC    MAX_NO_PROCS    :: Maximum number of processes allowed.
CC    MAX_NO_BARRIERS :: Maximum number of distinct thread "barriers"
      INTEGER MAX_NO_THREADS
      PARAMETER ( MAX_NO_THREADS =  4 )
c     INTEGER MAX_NO_PROCS
c     PARAMETER ( MAX_NO_PROCS   =  70000 )
c     INTEGER MAX_NO_BARRIERS
c     PARAMETER ( MAX_NO_BARRIERS = 1 )

C     Particularly weird and obscure voodoo numbers
C     lShare :: This wants to be the length in
C               [148]-byte words of the size of
C               the address "window" that is snooped
C               on an SMP bus. By separating elements in
C               the global sum buffer we can avoid generating
C               extraneous invalidate traffic between
C               processors. The length of this window is usually
C               a cache line i.e. small O(64 bytes).
C               The buffer arrays are usually short arrays
C               and are declared REAL ARRA(lShare[148],LBUFF).
C               Setting lShare[148] to 1 is like making these arrays
C               one dimensional.
      INTEGER cacheLineSize
      INTEGER lShare1
      INTEGER lShare4
      INTEGER lShare8
      PARAMETER ( cacheLineSize = 256 )
      PARAMETER ( lShare1 =  cacheLineSize )
      PARAMETER ( lShare4 =  cacheLineSize/4 )
      PARAMETER ( lShare8 =  cacheLineSize/8 )

CC    MAX_VGS  :: Maximum buffer size for Global Vector Sum
c     INTEGER MAX_VGS
c     PARAMETER ( MAX_VGS = 8192 )

C     ========  EESIZE.h  ========================================

C     Symbolic values
C     precXXXX :: precision used for I/O
      INTEGER precFloat32
      PARAMETER ( precFloat32 = 32 )
      INTEGER precFloat64
      PARAMETER ( precFloat64 = 64 )

C     Real-type constant for some frequently used simple number (0,1,2,1/2):
      Real*8     zeroRS, oneRS, twoRS, halfRS
      PARAMETER ( zeroRS = 0.0D0 , oneRS  = 1.0D0 )
      PARAMETER ( twoRS  = 2.0D0 , halfRS = 0.5D0 )
      Real*8     zeroRL, oneRL, twoRL, halfRL
      PARAMETER ( zeroRL = 0.0D0 , oneRL  = 1.0D0 )
      PARAMETER ( twoRL  = 2.0D0 , halfRL = 0.5D0 )

C     UNSET_xxx :: Used to indicate variables that have not been given a value
      Real*8  UNSET_FLOAT8
      PARAMETER ( UNSET_FLOAT8 = 1.234567D5 )
      Real*4  UNSET_FLOAT4
      PARAMETER ( UNSET_FLOAT4 = 1.234567E5 )
      Real*8     UNSET_RL
      PARAMETER ( UNSET_RL     = 1.234567D5 )
      Real*8     UNSET_RS
      PARAMETER ( UNSET_RS     = 1.234567D5 )
      INTEGER UNSET_I
      PARAMETER ( UNSET_I      = 123456789  )

C     debLevX  :: used to decide when to print debug messages
      INTEGER debLevZero
      INTEGER debLevA, debLevB,  debLevC, debLevD, debLevE
      PARAMETER ( debLevZero=0 )
      PARAMETER ( debLevA=1 )
      PARAMETER ( debLevB=2 )
      PARAMETER ( debLevC=3 )
      PARAMETER ( debLevD=4 )
      PARAMETER ( debLevE=5 )

C     SQUEEZE_RIGHT      :: Flag indicating right blank space removal
C                           from text field.
C     SQUEEZE_LEFT       :: Flag indicating left blank space removal
C                           from text field.
C     SQUEEZE_BOTH       :: Flag indicating left and right blank
C                           space removal from text field.
C     PRINT_MAP_XY       :: Flag indicating to plot map as XY slices
C     PRINT_MAP_XZ       :: Flag indicating to plot map as XZ slices
C     PRINT_MAP_YZ       :: Flag indicating to plot map as YZ slices
C     commentCharacter   :: Variable used in column 1 of parameter
C                           files to indicate comments.
C     INDEX_I            :: Variable used to select an index label
C     INDEX_J               for formatted input parameters.
C     INDEX_K
C     INDEX_NONE
      CHARACTER*(*) SQUEEZE_RIGHT
      PARAMETER ( SQUEEZE_RIGHT = 'R' )
      CHARACTER*(*) SQUEEZE_LEFT
      PARAMETER ( SQUEEZE_LEFT = 'L' )
      CHARACTER*(*) SQUEEZE_BOTH
      PARAMETER ( SQUEEZE_BOTH = 'B' )
      CHARACTER*(*) PRINT_MAP_XY
      PARAMETER ( PRINT_MAP_XY = 'XY' )
      CHARACTER*(*) PRINT_MAP_XZ
      PARAMETER ( PRINT_MAP_XZ = 'XZ' )
      CHARACTER*(*) PRINT_MAP_YZ
      PARAMETER ( PRINT_MAP_YZ = 'YZ' )
      CHARACTER*(*) commentCharacter
      PARAMETER ( commentCharacter = '#' )
      INTEGER INDEX_I
      INTEGER INDEX_J
      INTEGER INDEX_K
      INTEGER INDEX_NONE
      PARAMETER ( INDEX_I    = 1,
     &            INDEX_J    = 2,
     &            INDEX_K    = 3,
     &            INDEX_NONE = 4 )

C     EXCH_IGNORE_CORNERS :: Flag to select ignoring or
C     EXCH_UPDATE_CORNERS    updating of corners during an edge exchange.
      INTEGER EXCH_IGNORE_CORNERS
      INTEGER EXCH_UPDATE_CORNERS
      PARAMETER ( EXCH_IGNORE_CORNERS = 0,
     &            EXCH_UPDATE_CORNERS = 1 )

C     FORWARD_SIMULATION
C     REVERSE_SIMULATION
C     TANGENT_SIMULATION
      INTEGER FORWARD_SIMULATION
      INTEGER REVERSE_SIMULATION
      INTEGER TANGENT_SIMULATION
      PARAMETER ( FORWARD_SIMULATION = 0,
     &            REVERSE_SIMULATION = 1,
     &            TANGENT_SIMULATION = 2 )

C--   COMMON /EEPARAMS_L/ Execution environment public logical variables.
C     eeBootError    :: Flags indicating error during multi-processing
C     eeEndError     :: initialisation and termination.
C     fatalError     :: Flag used to indicate that the model is ended with an error
C     debugMode      :: controls printing of debug msg (sequence of S/R calls).
C     useSingleCpuIO :: When useSingleCpuIO is set, MDS_WRITE_FIELD outputs from
C                       master MPI process only. -- NOTE: read from main parameter
C                       file "data" and not set until call to INI_PARMS.
C     useSingleCpuInput :: When useSingleCpuInput is set, EXF_INTERP_READ
C                       reads forcing files from master MPI process only.
C                       -- NOTE: read from main parameter file "data"
C                          and defaults to useSingleCpuInput = useSingleCpuIO
C     printMapIncludesZeros  :: Flag that controls whether character constant
C                               map code ignores exact zero values.
C     useCubedSphereExchange :: use Cubed-Sphere topology domain.
C     useCoupler     :: use Coupler for a multi-components set-up.
C     useNEST_PARENT :: use Parent Nesting interface (pkg/nest_parent)
C     useNEST_CHILD  :: use Child  Nesting interface (pkg/nest_child)
C     useNest2W_parent :: use Parent 2-W Nesting interface (pkg/nest2w_parent)
C     useNest2W_child  :: use Child  2-W Nesting interface (pkg/nest2w_child)
C     useOASIS       :: use OASIS-coupler for a multi-components set-up.
      COMMON /EEPARAMS_L/
c    &  eeBootError, fatalError, eeEndError,
     &  eeBootError, eeEndError, fatalError, debugMode,
     &  useSingleCpuIO, useSingleCpuInput, printMapIncludesZeros,
     &  useCubedSphereExchange, useCoupler,
     &  useNEST_PARENT, useNEST_CHILD,
     &  useNest2W_parent, useNest2W_child, useOASIS,
     &  useSETRLSTK, useSIGREG
      LOGICAL eeBootError
      LOGICAL eeEndError
      LOGICAL fatalError
      LOGICAL debugMode
      LOGICAL useSingleCpuIO
      LOGICAL useSingleCpuInput
      LOGICAL printMapIncludesZeros
      LOGICAL useCubedSphereExchange
      LOGICAL useCoupler
      LOGICAL useNEST_PARENT
      LOGICAL useNEST_CHILD
      LOGICAL useNest2W_parent
      LOGICAL useNest2W_child
      LOGICAL useOASIS
      LOGICAL useSETRLSTK
      LOGICAL useSIGREG

C--   COMMON /EPARAMS_I/ Execution environment public integer variables.
C     errorMessageUnit    :: Fortran IO unit for error messages
C     standardMessageUnit :: Fortran IO unit for informational messages
C     maxLengthPrt1D :: maximum length for printing (to Std-Msg-Unit) 1-D array
C     scrUnit1      :: Scratch file 1 unit number
C     scrUnit2      :: Scratch file 2 unit number
C     eeDataUnit    :: Unit # for reading "execution environment" parameter file
C     modelDataUnit :: Unit number for reading "model" parameter file.
C     numberOfProcs :: Number of processes computing in parallel
C     pidIO         :: Id of process to use for I/O.
C     myBxLo, myBxHi :: Extents of domain in blocks in X and Y
C     myByLo, myByHi :: that each threads is responsble for.
C     myProcId      :: My own "process" id.
C     myPx          :: My X coord on the proc. grid.
C     myPy          :: My Y coord on the proc. grid.
C     myXGlobalLo   :: My bottom-left (south-west) x-index global domain.
C                      The x-coordinate of this point in for example m or
C                      degrees is *not* specified here. A model needs to
C                      provide a mechanism for deducing that information
C                      if it is needed.
C     myYGlobalLo   :: My bottom-left (south-west) y-index in global domain.
C                      The y-coordinate of this point in for example m or
C                      degrees is *not* specified here. A model needs to
C                      provide a mechanism for deducing that information
C                      if it is needed.
C     nThreads      :: No. of threads
C     nTx, nTy      :: No. of threads in X and in Y
C                      This assumes a simple cartesian gridding of the threads
C                      which is not required elsewhere but that makes it easier
C     ioErrorCount  :: IO Error Counter. Set to zero initially and increased
C                      by one every time an IO error occurs.
      COMMON /EEPARAMS_I/
     &  errorMessageUnit, standardMessageUnit, maxLengthPrt1D,
     &  scrUnit1, scrUnit2, eeDataUnit, modelDataUnit,
     &  numberOfProcs, pidIO, myProcId,
     &  myPx, myPy, myXGlobalLo, myYGlobalLo, nThreads,
     &  myBxLo, myBxHi, myByLo, myByHi,
     &  nTx, nTy, ioErrorCount
      INTEGER errorMessageUnit
      INTEGER standardMessageUnit
      INTEGER maxLengthPrt1D
      INTEGER scrUnit1
      INTEGER scrUnit2
      INTEGER eeDataUnit
      INTEGER modelDataUnit
      INTEGER ioErrorCount(MAX_NO_THREADS)
      INTEGER myBxLo(MAX_NO_THREADS)
      INTEGER myBxHi(MAX_NO_THREADS)
      INTEGER myByLo(MAX_NO_THREADS)
      INTEGER myByHi(MAX_NO_THREADS)
      INTEGER myProcId
      INTEGER myPx
      INTEGER myPy
      INTEGER myXGlobalLo
      INTEGER myYGlobalLo
      INTEGER nThreads
      INTEGER nTx
      INTEGER nTy
      INTEGER numberOfProcs
      INTEGER pidIO

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
C

CBOP
C     !ROUTINE: PARAMS.h
C     !INTERFACE:
C     #include PARAMS.h

C     !DESCRIPTION:
C     Header file defining model "parameters".  The values from the
C     model standard input file are stored into the variables held
C     here. Notes describing the parameters can also be found here.

CEOP

C--   Contants
C     Useful physical values
      Real*8 PI
      PARAMETER ( PI    = 3.14159265358979323844d0   )
      Real*8 deg2rad
      PARAMETER ( deg2rad = 2.d0*PI/360.d0           )

C--   COMMON /PARM_C/ Character valued parameters used by the model.
C     buoyancyRelation :: Flag used to indicate which relation to use to
C                         get buoyancy.
C     eosType         :: choose the equation of state:
C                        LINEAR, POLY3, UNESCO, JMD95Z, JMD95P, MDJWF, IDEALGAS
C     pickupSuff      :: force to start from pickup files (even if nIter0=0)
C                        and read pickup files with this suffix (max 10 Char.)
C     mdsioLocalDir   :: read-write tiled file from/to this directory name
C                        (+ 4 digits Processor-Rank) instead of current dir.
C     adTapeDir       :: read-write checkpointing tape files from/to this
C                        directory name instead of current dir. Conflicts
C                        mdsioLocalDir, so only one of the two can be set.
C     tRefFile      :: File containing reference Potential Temperat.  tRef (1.D)
C     sRefFile      :: File containing reference salinity/spec.humid. sRef (1.D)
C     rhoRefFile    :: File containing reference density profile rhoRef (1.D)
C     gravityFile   :: File containing gravity vertical profile (1.D)
C     delRFile      :: File containing vertical grid spacing delR  (1.D array)
C     delRcFile     :: File containing vertical grid spacing delRc (1.D array)
C     hybSigmFile   :: File containing hybrid-sigma vertical coord. coeff. (2x 1.D)
C     delXFile      :: File containing X-spacing grid definition (1.D array)
C     delYFile      :: File containing Y-spacing grid definition (1.D array)
C     horizGridFile :: File containing horizontal-grid definition
C                        (only when using curvilinear_grid)
C     bathyFile       :: File containing bathymetry. If not defined bathymetry
C                        is taken from inline function.
C     topoFile        :: File containing the topography of the surface (unit=m)
C                        (mainly used for the atmosphere = ground height).
C     addWwallFile    :: File containing 2-D additional Western  cell-edge wall
C     addSwallFile    :: File containing 2-D additional Southern cell-edge wall
C                        (e.g., to add "thin-wall" where it is =1)
C     hydrogThetaFile :: File containing initial hydrographic data (3-D)
C                        for potential temperature.
C     hydrogSaltFile  :: File containing initial hydrographic data (3-D)
C                        for salinity.
C     diffKrFile      :: File containing 3D specification of vertical diffusivity
C     viscAhDfile     :: File containing 3D specification of horizontal viscosity
C     viscAhZfile     :: File containing 3D specification of horizontal viscosity
C     viscA4Dfile     :: File containing 3D specification of horizontal viscosity
C     viscA4Zfile     :: File containing 3D specification of horizontal viscosity
C     zonalWindFile   :: File containing zonal wind data
C     meridWindFile   :: File containing meridional wind data
C     thetaClimFile   :: File containing surface theta climataology used
C                        in relaxation term -lambda(theta-theta*)
C     saltClimFile    :: File containing surface salt climataology used
C                        in relaxation term -lambda(salt-salt*)
C     surfQfile       :: File containing surface heat flux, excluding SW
C                        (old version, kept for backward compatibility)
C     surfQnetFile    :: File containing surface net heat flux
C     surfQswFile     :: File containing surface shortwave radiation
C     EmPmRfile       :: File containing surface fresh water flux
C           NOTE: for backward compatibility EmPmRfile is specified in
C                 m/s when using external_fields_load.F.  It is converted
C                 to kg/m2/s by multiplying by rhoConstFresh.
C     saltFluxFile    :: File containing surface salt flux
C     pLoadFile       :: File containing pressure loading
C     geoPotAnomFile  :: File containing constant geopotential anomaly due to
C                        density structure
C     addMassFile     :: File containing source/sink of fluid in the interior
C     eddyPsiXFile    :: File containing zonal Eddy streamfunction data
C     eddyPsiYFile    :: File containing meridional Eddy streamfunction data
C     the_run_name    :: string identifying the name of the model "run"
      COMMON /PARM_C/
     &                buoyancyRelation, eosType,
     &                pickupSuff, mdsioLocalDir, adTapeDir,
     &                tRefFile, sRefFile, rhoRefFile, gravityFile,
     &                delRFile, delRcFile, hybSigmFile,
     &                delXFile, delYFile, horizGridFile,
     &                bathyFile, topoFile, addWwallFile, addSwallFile,
     &                viscAhDfile, viscAhZfile,
     &                viscA4Dfile, viscA4Zfile,
     &                hydrogThetaFile, hydrogSaltFile, diffKrFile,
     &                zonalWindFile, meridWindFile, thetaClimFile,
     &                saltClimFile,
     &                EmPmRfile, saltFluxFile,
     &                surfQfile, surfQnetFile, surfQswFile,
     &                lambdaThetaFile, lambdaSaltFile,
     &                uVelInitFile, vVelInitFile, pSurfInitFile,
     &                pLoadFile, geoPotAnomFile, addMassFile,
     &                eddyPsiXFile, eddyPsiYFile, geothermalFile,
     &                the_run_name
      CHARACTER*(MAX_LEN_FNAM) buoyancyRelation
      CHARACTER*(6)  eosType
      CHARACTER*(10) pickupSuff
      CHARACTER*(MAX_LEN_FNAM) mdsioLocalDir
      CHARACTER*(MAX_LEN_FNAM) adTapeDir
      CHARACTER*(MAX_LEN_FNAM) tRefFile
      CHARACTER*(MAX_LEN_FNAM) sRefFile
      CHARACTER*(MAX_LEN_FNAM) rhoRefFile
      CHARACTER*(MAX_LEN_FNAM) gravityFile
      CHARACTER*(MAX_LEN_FNAM) delRFile
      CHARACTER*(MAX_LEN_FNAM) delRcFile
      CHARACTER*(MAX_LEN_FNAM) hybSigmFile
      CHARACTER*(MAX_LEN_FNAM) delXFile
      CHARACTER*(MAX_LEN_FNAM) delYFile
      CHARACTER*(MAX_LEN_FNAM) horizGridFile
      CHARACTER*(MAX_LEN_FNAM) bathyFile, topoFile
      CHARACTER*(MAX_LEN_FNAM) addWwallFile, addSwallFile
      CHARACTER*(MAX_LEN_FNAM) hydrogThetaFile, hydrogSaltFile
      CHARACTER*(MAX_LEN_FNAM) diffKrFile
      CHARACTER*(MAX_LEN_FNAM) viscAhDfile
      CHARACTER*(MAX_LEN_FNAM) viscAhZfile
      CHARACTER*(MAX_LEN_FNAM) viscA4Dfile
      CHARACTER*(MAX_LEN_FNAM) viscA4Zfile
      CHARACTER*(MAX_LEN_FNAM) zonalWindFile
      CHARACTER*(MAX_LEN_FNAM) meridWindFile
      CHARACTER*(MAX_LEN_FNAM) thetaClimFile
      CHARACTER*(MAX_LEN_FNAM) saltClimFile
      CHARACTER*(MAX_LEN_FNAM) surfQfile
      CHARACTER*(MAX_LEN_FNAM) surfQnetFile
      CHARACTER*(MAX_LEN_FNAM) surfQswFile
      CHARACTER*(MAX_LEN_FNAM) EmPmRfile
      CHARACTER*(MAX_LEN_FNAM) saltFluxFile
      CHARACTER*(MAX_LEN_FNAM) uVelInitFile
      CHARACTER*(MAX_LEN_FNAM) vVelInitFile
      CHARACTER*(MAX_LEN_FNAM) pSurfInitFile
      CHARACTER*(MAX_LEN_FNAM) pLoadFile
      CHARACTER*(MAX_LEN_FNAM) geoPotAnomFile
      CHARACTER*(MAX_LEN_FNAM) addMassFile
      CHARACTER*(MAX_LEN_FNAM) eddyPsiXFile
      CHARACTER*(MAX_LEN_FNAM) eddyPsiYFile
      CHARACTER*(MAX_LEN_FNAM) geothermalFile
      CHARACTER*(MAX_LEN_FNAM) lambdaThetaFile
      CHARACTER*(MAX_LEN_FNAM) lambdaSaltFile
      CHARACTER*(MAX_LEN_PREC/2) the_run_name

C--   COMMON /PARM_I/ Integer valued parameters used by the model.
C     cg2dMaxIters        :: Maximum number of iterations in the
C                            two-dimensional con. grad solver.
C     cg2dMinItersNSA     :: Minimum number of iterations in the
C                            not-self-adjoint version (cg2d_nsa.F) of the
C                            two-dimensional con. grad solver (default = 0).
C     cg2dPreCondFreq     :: Frequency for updating cg2d preconditioner
C                            (non-linear free-surf.)
C     cg2dUseMinResSol    :: =0 : use last-iteration/converged solution
C                            =1 : use solver minimum-residual solution
C     cg3dMaxIters        :: Maximum number of iterations in the
C                            three-dimensional con. grad solver.
C     printResidualFreq   :: Frequency for printing residual in CG iterations
C     nIter0              :: Start time-step number of for this run
C     nTimeSteps          :: Number of timesteps to execute
C     nTimeSteps_l2       :: Number of inner timesteps to execute per timestep
C     selectCoriMap       :: select setting of Coriolis parameter map:
C                           =0 f-Plane (Constant Coriolis, = f0)
C                           =1 Beta-Plane Coriolis (= f0 + beta.y)
C                           =2 Spherical Coriolis (= 2.omega.sin(phi))
C                           =3 Read Coriolis 2-d fields from files.
C     selectSigmaCoord    :: option related to sigma vertical coordinate
C     nonlinFreeSurf      :: option related to non-linear free surface
C                           =0 Linear free surface ; >0 Non-linear
C     select_rStar        :: option related to r* vertical coordinate
C                           =0 (default) use r coord. ; > 0 use r*
C     selectNHfreeSurf    :: option for Non-Hydrostatic (free-)Surface formulation:
C                           =0 (default) hydrostatic surf. ; > 0 add NH effects.
C     selectP_inEOS_Zc    :: select which pressure to use in EOS (for z-coords)
C                           =0: simply: -g*rhoConst*z
C                           =1: use pRef = integral{-g*rho(Tref,Sref,pRef)*dz}
C                           =2: use hydrostatic dynamical pressure
C                           =3: use full (Hyd+NH) dynamical pressure
C     selectAddFluid      :: option to add mass source/sink of fluid in the interior
C                            (3-D generalisation of oceanic real-fresh water flux)
C                           =0 off ; =1 add fluid ; =-1 virtual flux (no mass added)
C     selectImplicitDrag  :: select Implicit treatment of bottom/top drag
C                           = 0: fully explicit
C                           = 1: implicit on provisional velocity
C                                (i.e., before grad.Eta increment)
C                           = 2: fully implicit (combined with Impl Surf.Press)
C     momForcingOutAB     :: =1: take momentum forcing contribution
C                            out of (=0: in) Adams-Bashforth time stepping.
C     tracForcingOutAB    :: =1: take tracer (Temp,Salt,pTracers) forcing contribution
C                            out of (=0: in) Adams-Bashforth time stepping.
C     tempAdvScheme       :: Temp. Horiz.Advection scheme selector
C     tempVertAdvScheme   :: Temp. Vert. Advection scheme selector
C     saltAdvScheme       :: Salt. Horiz.advection scheme selector
C     saltVertAdvScheme   :: Salt. Vert. Advection scheme selector
C     selectKEscheme      :: Kinetic Energy scheme selector (Vector Inv.)
C     selectVortScheme    :: Scheme selector for Vorticity term (Vector Inv.)
C     selectCoriScheme    :: Scheme selector for Coriolis term
C     selectBotDragQuadr  :: quadratic bottom drag discretisation option:
C                           =0: average KE from grid center to U & V location
C                           =1: use local velocity norm @ U & V location
C                           =2: same with wet-point averaging of other component
C     pCellMix_select     :: select option to enhance mixing near surface & bottom
C                            unit digit: near bottom ; tens digit: near surface
C                            with digit =0 : disable ;
C                           = 1 : increases mixing linearly with recip_hFac
C                           = 2,3,4 : increases mixing by recip_hFac^(2,3,4)
C     readBinaryPrec      :: Precision used for reading binary files
C     writeStatePrec      :: Precision used for writing model state.
C     writeBinaryPrec     :: Precision used for writing binary files
C     rwSuffixType        :: controls the format of the mds file suffix.
C                          =0 (default): use iteration number (myIter, I10.10);
C                          =1: 100*myTime (100th sec); =2: myTime (seconds);
C                          =3: myTime/360 (10th of hr); =4: myTime/3600 (hours).
C     monitorSelect       :: select group of variables to monitor
C                            =1 : dynvars ; =2 : + vort ; =3 : + surface
C-    debugLevel          :: controls printing of algorithm intermediate results
C                            and statistics ; higher -> more writing
C-    plotLevel           :: controls printing of field maps ; higher -> more flds

      COMMON /PARM_I/
     &        cg2dMaxIters, cg2dMinItersNSA,
     &        cg2dPreCondFreq, cg2dUseMinResSol,
     &        cg3dMaxIters, printResidualFreq,
     &        nIter0, nTimeSteps, nTimeSteps_l2, nEndIter,
     &        selectCoriMap,
     &        selectSigmaCoord,
     &        nonlinFreeSurf, select_rStar,
     &        selectNHfreeSurf, selectP_inEOS_Zc,
     &        selectAddFluid, selectImplicitDrag,
     &        momForcingOutAB, tracForcingOutAB,
     &        tempAdvScheme, tempVertAdvScheme,
     &        saltAdvScheme, saltVertAdvScheme,
     &        selectKEscheme, selectVortScheme, selectCoriScheme,
     &        selectBotDragQuadr, pCellMix_select,
     &        readBinaryPrec, writeBinaryPrec, writeStatePrec,
     &        rwSuffixType, monitorSelect, debugLevel, plotLevel
      INTEGER cg2dMaxIters
      INTEGER cg2dMinItersNSA
      INTEGER cg2dPreCondFreq
      INTEGER cg2dUseMinResSol
      INTEGER cg3dMaxIters
      INTEGER printResidualFreq
      INTEGER nIter0
      INTEGER nTimeSteps
      INTEGER nTimeSteps_l2
      INTEGER nEndIter
      INTEGER selectCoriMap
      INTEGER selectSigmaCoord
      INTEGER nonlinFreeSurf
      INTEGER select_rStar
      INTEGER selectNHfreeSurf
      INTEGER selectP_inEOS_Zc
      INTEGER selectAddFluid
      INTEGER selectImplicitDrag
      INTEGER momForcingOutAB, tracForcingOutAB
      INTEGER tempAdvScheme, tempVertAdvScheme
      INTEGER saltAdvScheme, saltVertAdvScheme
      INTEGER selectKEscheme
      INTEGER selectVortScheme
      INTEGER selectCoriScheme
      INTEGER selectBotDragQuadr
      INTEGER pCellMix_select
      INTEGER readBinaryPrec
      INTEGER writeStatePrec
      INTEGER writeBinaryPrec
      INTEGER rwSuffixType
      INTEGER monitorSelect
      INTEGER debugLevel
      INTEGER plotLevel

C--   COMMON /PARM_L/ Logical valued parameters used by the model.
C- Coordinate + Grid params:
C     fluidIsAir       :: Set to indicate that the fluid major constituent
C                         is air
C     fluidIsWater     :: Set to indicate that the fluid major constituent
C                         is water
C     usingPCoords     :: Set to indicate that we are working in a pressure
C                         type coordinate (p or p*).
C     usingZCoords     :: Set to indicate that we are working in a height
C                         type coordinate (z or z*)
C     usingCartesianGrid :: If TRUE grid generation will be in a cartesian
C                           coordinate frame.
C     usingSphericalPolarGrid :: If TRUE grid generation will be in a
C                                spherical polar frame.
C     rotateGrid      :: rotate grid coordinates to geographical coordinates
C                        according to Euler angles phiEuler, thetaEuler, psiEuler
C     usingCylindricalGrid :: If TRUE grid generation will be Cylindrical
C     usingCurvilinearGrid :: If TRUE, use a curvilinear grid (to be provided)
C     hasWetCSCorners :: domain contains CS-type corners where dynamics is solved
C     deepAtmosphere :: deep model (drop the shallow-atmosphere approximation)
C     setInterFDr    :: set Interface depth (put cell-Center at the middle)
C     setCenterDr    :: set cell-Center depth (put Interface at the middle)
C     useMin4hFacEdges :: set hFacW,hFacS as minimum of adjacent hFacC factor
C     interViscAr_pCell :: account for partial-cell in interior vert. viscosity
C     interDiffKr_pCell :: account for partial-cell in interior vert. diffusion
C- Momentum params:
C     no_slip_sides  :: Impose "no-slip" at lateral boundaries.
C     no_slip_bottom :: Impose "no-slip" at bottom boundary.
C     bottomVisc_pCell :: account for partial-cell in bottom visc. (no-slip BC)
C     useSmag3D      :: Use isotropic 3-D Smagorinsky
C     useFullLeith   :: Set to true to use full Leith viscosity(may be unstable
C                       on irregular grids)
C     useStrainTensionVisc:: Set to true to use Strain-Tension viscous terms
C     useAreaViscLength :: Set to true to use old scaling for viscous lengths,
C                          e.g., L2=Raz.  May be preferable for cube sphere.
C     momViscosity  :: Flag which turns momentum friction terms on and off.
C     momAdvection  :: Flag which turns advection of momentum on and off.
C     momForcing    :: Flag which turns external forcing of momentum on and off.
C     momTidalForcing    :: Flag which turns tidal forcing on and off.
C     momPressureForcing :: Flag which turns pressure term in momentum equation
C                          on and off.
C     metricTerms   :: Flag which turns metric terms on or off.
C     useNHMTerms   :: If TRUE use non-hydrostatic metric terms.
C     useCoriolis   :: Flag which turns the coriolis terms on and off.
C     use3dCoriolis :: Turns the 3-D coriolis terms (in Omega.cos Phi) on - off
C     useCDscheme   :: use CD-scheme to calculate Coriolis terms.
C     vectorInvariantMomentum :: use Vector-Invariant form (mom_vecinv package)
C                                (default = F = use mom_fluxform package)
C     useJamartMomAdv :: Use wet-point method for V.I. non-linear term
C     upwindVorticity :: bias interpolation of vorticity in the Coriolis term
C     highOrderVorticity :: use 3rd/4th order interp. of vorticity (V.I., advection)
C     useAbsVorticity :: work with f+zeta in Coriolis terms
C     upwindShear     :: use 1rst order upwind interp. (V.I., vertical advection)
C     momStepping    :: Turns momentum equation time-stepping off
C     calc_wVelocity :: Turns vertical velocity calculation off
C- Temp. & Salt params:
C     tempStepping   :: Turns temperature equation time-stepping on/off
C     saltStepping   :: Turns salinity equation time-stepping on/off
C     addFrictionHeating :: account for frictional heating
C     temp_stayPositive :: use Smolarkiewicz Hack to ensure Temp stays positive
C     salt_stayPositive :: use Smolarkiewicz Hack to ensure Salt stays positive
C     tempAdvection  :: Flag which turns advection of temperature on and off.
C     tempVertDiff4  :: use vertical bi-harmonic diffusion for temperature
C     tempIsActiveTr :: Pot.Temp. is a dynamically active tracer
C     tempForcing    :: Flag which turns external forcing of temperature on/off
C     saltAdvection  :: Flag which turns advection of salinity on and off.
C     saltVertDiff4  :: use vertical bi-harmonic diffusion for salinity
C     saltIsActiveTr :: Salinity  is a dynamically active tracer
C     saltForcing    :: Flag which turns external forcing of salinity on/off
C     maskIniTemp    :: apply mask to initial Pot.Temp.
C     maskIniSalt    :: apply mask to initial salinity
C     checkIniTemp   :: check for points with identically zero initial Pot.Temp.
C     checkIniSalt   :: check for points with identically zero initial salinity
C- Pressure solver related parameters (PARM02)
C     useNSACGSolver :: Set to true to use "not self-adjoint" conjugate
C                       gradient solver that stores the iteration history
C                       for an iterative adjoint as accuate as possible
C     useSRCGSolver  :: Set to true to use conjugate gradient
C                       solver with single reduction (only one call of
C                       s/r mpi_allreduce), default is false
C- Time-stepping & free-surface params:
C     rigidLid            :: Set to true to use rigid lid
C     implicitFreeSurface :: Set to true to use implicit free surface
C     uniformLin_PhiSurf  :: Set to true to use a uniform Bo_surf in the
C                            linear relation Phi_surf = Bo_surf*eta
C     uniformFreeSurfLev  :: TRUE if free-surface level-index is uniform (=1)
C     exactConserv        :: Set to true to conserve exactly the total Volume
C     linFSConserveTr     :: Set to true to correct source/sink of tracer
C                            at the surface due to Linear Free Surface
C     useRealFreshWaterFlux :: if True (=Natural BCS), treats P+R-E flux
C                         as a real Fresh Water (=> changes the Sea Level)
C                         if F, converts P+R-E to salt flux (no SL effect)
C     storePhiHyd4Phys :: store hydrostatic potential for use in Physics/EOS
C                         this requires specific code for restart & exchange
C     quasiHydrostatic :: Using non-hydrostatic terms in hydrostatic algorithm
C     nonHydrostatic   :: Using non-hydrostatic algorithm
C     use3Dsolver      :: set to true to use 3-D pressure solver
C     implicitIntGravWave :: treat Internal Gravity Wave implicitly
C     staggerTimeStep   :: enable a Stagger time stepping U,V (& W) then T,S
C     applyExchUV_early :: Apply EXCH to U,V earlier, just before integr_continuity
C     doResetHFactors   :: Do reset thickness factors @ beginning of each time-step
C     implicitDiffusion :: Turns implicit vertical diffusion on
C     implicitViscosity :: Turns implicit vertical viscosity on
C     tempImplVertAdv   :: Turns on implicit vertical advection for Temperature
C     saltImplVertAdv   :: Turns on implicit vertical advection for Salinity
C     momImplVertAdv    :: Turns on implicit vertical advection for Momentum
C     multiDimAdvection :: Flag that enable multi-dimension advection
C     useMultiDimAdvec  :: True if multi-dim advection is used at least once
C     momDissip_In_AB   :: if False, put Dissipation tendency contribution
C                          out off Adams-Bashforth time stepping.
C     doAB_onGtGs       :: if the Adams-Bashforth time stepping is used, always
C                          apply AB on tracer tendencies (rather than on Tracer)
C- Other forcing params -
C     balanceEmPmR    :: substract global mean of EmPmR at every time step
C     balanceQnet     :: substract global mean of Qnet at every time step
C     balancePrintMean:: print substracted global means to STDOUT
C     doThetaClimRelax :: Set true if relaxation to temperature
C                        climatology is required.
C     doSaltClimRelax  :: Set true if relaxation to salinity
C                        climatology is required.
C     balanceThetaClimRelax :: substract global mean effect at every time step
C     balanceSaltClimRelax :: substract global mean effect at every time step
C     allowFreezing  :: Allows surface water to freeze and form ice
C     periodicExternalForcing :: Set true if forcing is time-dependant
C- I/O parameters -
C     globalFiles    :: Selects between "global" and "tiled" files.
C                       On some platforms with MPI, option globalFiles is either
C                       slow or does not work. Use useSingleCpuIO instead.
C     useSingleCpuIO :: moved to EEPARAMS.h
C     pickupStrictlyMatch :: check and stop if pickup-file do not stricly match
C     startFromPickupAB2 :: with AB-3 code, start from an AB-2 pickup
C     usePickupBeforeC54 :: start from old-pickup files, generated with code from
C                           before checkpoint-54a, Jul 06, 2004.
C     pickup_write_mdsio :: use mdsio to write pickups
C     pickup_read_mdsio  :: use mdsio to read  pickups
C     pickup_write_immed :: echo the pickup immediately (for conversion)
C     writePickupAtEnd   :: write pickup at the last timestep
C     timeave_mdsio      :: use mdsio for timeave output
C     snapshot_mdsio     :: use mdsio for "snapshot" (dumpfreq/diagfreq) output
C     monitor_stdio      :: use stdio for monitor output
C     dumpInitAndLast :: dumps model state to files at Initial (nIter0)
C                        & Last iteration, in addition multiple of dumpFreq iter.

      COMMON /PARM_L/
     & fluidIsAir, fluidIsWater,
     & usingPCoords, usingZCoords,
     & usingCartesianGrid, usingSphericalPolarGrid, rotateGrid,
     & usingCylindricalGrid, usingCurvilinearGrid, hasWetCSCorners,
     & deepAtmosphere, setInterFDr, setCenterDr, useMin4hFacEdges,
     & interViscAr_pCell, interDiffKr_pCell,
     & no_slip_sides, no_slip_bottom, bottomVisc_pCell, useSmag3D,
     & useFullLeith, useStrainTensionVisc, useAreaViscLength,
     & momViscosity, momAdvection, momForcing, momTidalForcing,
     & momPressureForcing, metricTerms, useNHMTerms,
     & useCoriolis, use3dCoriolis,
     & useCDscheme, vectorInvariantMomentum,
     & useJamartMomAdv, upwindVorticity, highOrderVorticity,
     & useAbsVorticity, upwindShear,
     & momStepping, calc_wVelocity, tempStepping, saltStepping,
     & addFrictionHeating, temp_stayPositive, salt_stayPositive,
     & tempAdvection, tempVertDiff4, tempIsActiveTr, tempForcing,
     & saltAdvection, saltVertDiff4, saltIsActiveTr, saltForcing,
     & maskIniTemp, maskIniSalt, checkIniTemp, checkIniSalt,
     & useNSACGSolver, useSRCGSolver,
     & rigidLid, implicitFreeSurface,
     & uniformLin_PhiSurf, uniformFreeSurfLev,
     & exactConserv, linFSConserveTr, useRealFreshWaterFlux,
     & storePhiHyd4Phys, quasiHydrostatic, nonHydrostatic,
     & use3Dsolver, implicitIntGravWave, staggerTimeStep,
     & applyExchUV_early, doResetHFactors,
     & implicitDiffusion, implicitViscosity,
     & tempImplVertAdv, saltImplVertAdv, momImplVertAdv,
     & multiDimAdvection, useMultiDimAdvec,
     & momDissip_In_AB, doAB_onGtGs,
     & balanceEmPmR, balanceQnet, balancePrintMean,
     & balanceThetaClimRelax, balanceSaltClimRelax,
     & doThetaClimRelax, doSaltClimRelax,
     & allowFreezing,
     & periodicExternalForcing,
     & globalFiles,
     & pickupStrictlyMatch, usePickupBeforeC54, startFromPickupAB2,
     & pickup_read_mdsio, pickup_write_mdsio, pickup_write_immed,
     & writePickupAtEnd,
     & timeave_mdsio, snapshot_mdsio, monitor_stdio,
     & outputTypesInclusive, dumpInitAndLast

      LOGICAL fluidIsAir
      LOGICAL fluidIsWater
      LOGICAL usingPCoords
      LOGICAL usingZCoords
      LOGICAL usingCartesianGrid
      LOGICAL usingSphericalPolarGrid, rotateGrid
      LOGICAL usingCylindricalGrid
      LOGICAL usingCurvilinearGrid, hasWetCSCorners
      LOGICAL deepAtmosphere
      LOGICAL setInterFDr
      LOGICAL setCenterDr
      LOGICAL useMin4hFacEdges
      LOGICAL interViscAr_pCell
      LOGICAL interDiffKr_pCell

      LOGICAL no_slip_sides
      LOGICAL no_slip_bottom
      LOGICAL bottomVisc_pCell
      LOGICAL useSmag3D
      LOGICAL useFullLeith
      LOGICAL useStrainTensionVisc
      LOGICAL useAreaViscLength
      LOGICAL momViscosity
      LOGICAL momAdvection
      LOGICAL momForcing
      LOGICAL momTidalForcing
      LOGICAL momPressureForcing
      LOGICAL metricTerms
      LOGICAL useNHMTerms

      LOGICAL useCoriolis
      LOGICAL use3dCoriolis
      LOGICAL useCDscheme
      LOGICAL vectorInvariantMomentum
      LOGICAL useJamartMomAdv
      LOGICAL upwindVorticity
      LOGICAL highOrderVorticity
      LOGICAL useAbsVorticity
      LOGICAL upwindShear
      LOGICAL momStepping
      LOGICAL calc_wVelocity
      LOGICAL tempStepping
      LOGICAL saltStepping
      LOGICAL addFrictionHeating
      LOGICAL temp_stayPositive
      LOGICAL salt_stayPositive
      LOGICAL tempAdvection
      LOGICAL tempVertDiff4
      LOGICAL tempIsActiveTr
      LOGICAL tempForcing
      LOGICAL saltAdvection
      LOGICAL saltVertDiff4
      LOGICAL saltIsActiveTr
      LOGICAL saltForcing
      LOGICAL maskIniTemp
      LOGICAL maskIniSalt
      LOGICAL checkIniTemp
      LOGICAL checkIniSalt
      LOGICAL useNSACGSolver
      LOGICAL useSRCGSolver
      LOGICAL rigidLid
      LOGICAL implicitFreeSurface
      LOGICAL uniformLin_PhiSurf
      LOGICAL uniformFreeSurfLev
      LOGICAL exactConserv
      LOGICAL linFSConserveTr
      LOGICAL useRealFreshWaterFlux
      LOGICAL storePhiHyd4Phys
      LOGICAL quasiHydrostatic
      LOGICAL nonHydrostatic
      LOGICAL use3Dsolver
      LOGICAL implicitIntGravWave
      LOGICAL staggerTimeStep
      LOGICAL applyExchUV_early
      LOGICAL doResetHFactors
      LOGICAL implicitDiffusion
      LOGICAL implicitViscosity
      LOGICAL tempImplVertAdv
      LOGICAL saltImplVertAdv
      LOGICAL momImplVertAdv
      LOGICAL multiDimAdvection
      LOGICAL useMultiDimAdvec
      LOGICAL momDissip_In_AB
      LOGICAL doAB_onGtGs
      LOGICAL balanceEmPmR
      LOGICAL balanceQnet
      LOGICAL balancePrintMean
      LOGICAL doThetaClimRelax
      LOGICAL doSaltClimRelax
      LOGICAL balanceThetaClimRelax
      LOGICAL balanceSaltClimRelax
      LOGICAL allowFreezing
      LOGICAL periodicExternalForcing
      LOGICAL globalFiles
      LOGICAL pickupStrictlyMatch
      LOGICAL usePickupBeforeC54
      LOGICAL startFromPickupAB2
      LOGICAL pickup_read_mdsio, pickup_write_mdsio
      LOGICAL pickup_write_immed, writePickupAtEnd
      LOGICAL timeave_mdsio, snapshot_mdsio, monitor_stdio
      LOGICAL outputTypesInclusive
      LOGICAL dumpInitAndLast

C--   COMMON /PARM_R/ "Real" valued parameters used by the model.
C     cg2dTargetResidual
C          :: Target residual for cg2d solver; no unit (RHS normalisation)
C     cg2dTargetResWunit
C          :: Target residual for cg2d solver; W unit (No RHS normalisation)
C     cg3dTargetResidual
C               :: Target residual for cg3d solver.
C     cg2dpcOffDFac :: Averaging weight for preconditioner off-diagonal.
C     Note. 20th May 1998
C           I made a weird discovery! In the model paper we argue
C           for the form of the preconditioner used here ( see
C           A Finite-volume, Incompressible Navier-Stokes Model
C           ...., Marshall et. al ). The algebra gives a simple
C           0.5 factor for the averaging of ac and aCw to get a
C           symmettric pre-conditioner. By using a factor of 0.51
C           i.e. scaling the off-diagonal terms in the
C           preconditioner down slightly I managed to get the
C           number of iterations for convergence in a test case to
C           drop form 192 -> 134! Need to investigate this further!
C           For now I have introduced a parameter cg2dpcOffDFac which
C           defaults to 0.51 but can be set at runtime.
C     delR      :: Vertical grid spacing ( units of r ).
C     delRc     :: Vertical grid spacing between cell centers (r unit).
C     delX      :: Separation between cell faces (m) or (deg), depending
C     delY         on input flags. Note: moved to header file SET_GRID.h
C     xgOrigin   :: Origin of the X-axis (Cartesian Grid) / Longitude of Western
C                :: most cell face (Lat-Lon grid) (Note: this is an "inert"
C                :: parameter but it makes geographical references simple.)
C     ygOrigin   :: Origin of the Y-axis (Cartesian Grid) / Latitude of Southern
C                :: most face (Lat-Lon grid).
C     rSphere    :: Radius of sphere for a spherical polar grid ( m ).
C     recip_rSphere :: Reciprocal radius of sphere ( m^-1 ).
C     radius_fromHorizGrid :: sphere Radius of input horiz. grid (Curvilinear Grid)
C     seaLev_Z   :: the reference height of sea-level (usually zero)
C     top_Pres   :: pressure (P-Coords) or reference pressure (Z-Coords) at the top
C     rSigmaBnd  :: vertical position (in r-unit) of r/sigma transition (Hybrid-Sigma)
C     gravity    :: Acceleration due to constant gravity ( m/s^2 )
C     recip_gravity :: Reciprocal gravity acceleration ( s^2/m )
C     gBaro      :: Accel. due to gravity used in barotropic equation ( m/s^2 )
C     gravFacC   :: gravity factor (vs surf. gravity) vert. profile at cell-Center
C     gravFacF   :: gravity factor (vs surf. gravity) vert. profile at cell-interF
C     rhoNil     :: Reference density for the linear equation of state
C     rhoConst   :: Vertically constant reference density (Boussinesq)
C     rho1Ref    :: reference vertical profile for density (anelastic)
C     rhoFacC    :: normalized (by rhoConst) reference density at cell-Center
C     rhoFacF    :: normalized (by rhoConst) reference density at cell-interFace
C     rhoConstFresh :: Constant reference density for fresh water (rain)
C     thetaConst :: Constant reference for potential temperature
C     tRef       :: reference vertical profile for potential temperature
C     sRef       :: reference vertical profile for salinity/specific humidity
C     surf_pRef  :: surface reference pressure ( Pa )
C     pRef4EOS   :: reference pressure used in EOS (case selectP_inEOS_Zc=1)
C     phiRef     :: reference potential (press/rho, geopot) profile (m^2/s^2)
C     dBdrRef    :: vertical gradient of reference buoyancy  [(m/s/r)^2]:
C                :: z-coord: = N^2_ref = Brunt-Vaissala frequency [s^-2]
C                :: p-coord: = -(d.alpha/dp)_ref          [(m^2.s/kg)^2]
C     rVel2wUnit :: units conversion factor (Non-Hydrostatic code),
C                :: from r-coordinate vertical velocity to vertical velocity [m/s].
C                :: z-coord: = 1 ; p-coord: wSpeed [m/s] = rVel [Pa/s] * rVel2wUnit
C     wUnit2rVel :: units conversion factor (Non-Hydrostatic code),
C                :: from vertical velocity [m/s] to r-coordinate vertical velocity.
C                :: z-coord: = 1 ; p-coord: rVel [Pa/s] = wSpeed [m/s] * wUnit2rVel
C     mass2rUnit :: units conversion factor (surface forcing),
C                :: from mass per unit area [kg/m2] to vertical r-coordinate unit.
C                :: z-coord: = 1/rhoConst ( [kg/m2] / rho = [m] ) ;
C                :: p-coord: = gravity    ( [kg/m2] *  g = [Pa] ) ;
C     rUnit2mass :: units conversion factor (surface forcing),
C                :: from vertical r-coordinate unit to mass per unit area [kg/m2].
C                :: z-coord: = rhoConst  ( [m] * rho = [kg/m2] ) ;
C                :: p-coord: = 1/gravity ( [Pa] /  g = [kg/m2] ) ;
C     sIceLoadFac:: factor to scale (and turn off) sIceLoad (sea-ice loading)
C                   default = 1
C     f0         :: Reference coriolis parameter ( 1/s )
C                   ( Southern edge f for beta plane )
C     beta       :: df/dy ( s^-1.m^-1 )
C     fPrime     :: Second Coriolis parameter ( 1/s ), related to Y-component
C                   of rotation (reference value = 2.Omega.Cos(Phi))
C     omega      :: Angular velocity ( rad/s )
C     rotationPeriod :: Rotation period (s) (= 2.pi/omega)
C     viscArNr   :: vertical profile of Eddy viscosity coeff.
C                   for vertical mixing of momentum ( units of r^2/s )
C     viscAh     :: Eddy viscosity coeff. for mixing of
C                   momentum laterally ( m^2/s )
C     viscAhW    :: Eddy viscosity coeff. for mixing of vertical
C                   momentum laterally, no effect for hydrostatic
C                   model, defaults to viscAhD if unset ( m^2/s )
C                   Not used if variable horiz. viscosity is used.
C     viscA4     :: Biharmonic viscosity coeff. for mixing of
C                   momentum laterally ( m^4/s )
C     viscA4W    :: Biharmonic viscosity coeff. for mixing of vertical
C                   momentum laterally, no effect for hydrostatic
C                   model, defaults to viscA4D if unset ( m^2/s )
C                   Not used if variable horiz. viscosity is used.
C     viscAhD    :: Eddy viscosity coeff. for mixing of momentum laterally
C                   (act on Divergence part) ( m^2/s )
C     viscAhZ    :: Eddy viscosity coeff. for mixing of momentum laterally
C                   (act on Vorticity  part) ( m^2/s )
C     viscA4D    :: Biharmonic viscosity coeff. for mixing of momentum laterally
C                   (act on Divergence part) ( m^4/s )
C     viscA4Z    :: Biharmonic viscosity coeff. for mixing of momentum laterally
C                   (act on Vorticity  part) ( m^4/s )
C     smag3D_coeff     :: Isotropic 3-D Smagorinsky viscosity coefficient (-)
C     smag3D_diffCoeff :: Isotropic 3-D Smagorinsky diffusivity coefficient (-)
C     viscC2leith  :: Leith non-dimensional viscosity factor (grad(vort))
C     viscC2leithD :: Modified Leith non-dimensional visc. factor (grad(div))
C     viscC2LeithQG:: QG Leith non-dimensional viscosity factor
C     viscC4leith  :: Leith non-dimensional viscosity factor (grad(vort))
C     viscC4leithD :: Modified Leith non-dimensional viscosity factor (grad(div))
C     viscC2smag   :: Smagorinsky non-dimensional viscosity factor (harmonic)
C     viscC4smag   :: Smagorinsky non-dimensional viscosity factor (biharmonic)
C     viscAhMax    :: Maximum eddy viscosity coeff. for mixing of
C                    momentum laterally ( m^2/s )
C     viscAhReMax  :: Maximum gridscale Reynolds number for eddy viscosity
C                     coeff. for mixing of momentum laterally (non-dim)
C     viscAhGrid   :: non-dimensional grid-size dependent viscosity
C     viscAhGridMax:: maximum and minimum harmonic viscosity coefficients ...
C     viscAhGridMin::  in terms of non-dimensional grid-size dependent visc.
C     viscA4Max    :: Maximum biharmonic viscosity coeff. for mixing of
C                     momentum laterally ( m^4/s )
C     viscA4ReMax  :: Maximum Gridscale Reynolds number for
C                     biharmonic viscosity coeff. momentum laterally (non-dim)
C     viscA4Grid   :: non-dimensional grid-size dependent bi-harmonic viscosity
C     viscA4GridMax:: maximum and minimum biharmonic viscosity coefficients ...
C     viscA4GridMin::  in terms of non-dimensional grid-size dependent viscosity
C     diffKhT   :: Laplacian diffusion coeff. for mixing of
C                 heat laterally ( m^2/s )
C     diffK4T   :: Biharmonic diffusion coeff. for mixing of
C                 heat laterally ( m^4/s )
C     diffKrNrT :: vertical profile of Laplacian diffusion coeff.
C                 for mixing of heat vertically ( units of r^2/s )
C     diffKr4T  :: vertical profile of Biharmonic diffusion coeff.
C                 for mixing of heat vertically ( units of r^4/s )
C     diffKhS  ::  Laplacian diffusion coeff. for mixing of
C                 salt laterally ( m^2/s )
C     diffK4S   :: Biharmonic diffusion coeff. for mixing of
C                 salt laterally ( m^4/s )
C     diffKrNrS :: vertical profile of Laplacian diffusion coeff.
C                 for mixing of salt vertically ( units of r^2/s ),
C     diffKr4S  :: vertical profile of Biharmonic diffusion coeff.
C                 for mixing of salt vertically ( units of r^4/s )
C     diffKrBL79surf :: T/S surface diffusivity (m^2/s) Bryan and Lewis, 1979
C     diffKrBL79deep :: T/S deep diffusivity (m^2/s) Bryan and Lewis, 1979
C     diffKrBL79scl  :: depth scale for arctan fn (m) Bryan and Lewis, 1979
C     diffKrBL79Ho   :: depth offset for arctan fn (m) Bryan and Lewis, 1979
C     BL79LatVary    :: polarwise of this latitude diffKrBL79 is applied with
C                       gradual transition to diffKrBLEQ towards Equator
C     diffKrBLEQsurf :: same as diffKrBL79surf but at Equator
C     diffKrBLEQdeep :: same as diffKrBL79deep but at Equator
C     diffKrBLEQscl  :: same as diffKrBL79scl but at Equator
C     diffKrBLEQHo   :: same as diffKrBL79Ho but at Equator
C     pCellMix_maxFac :: maximum enhanced mixing factor for thin partial-cell
C     pCellMix_delR   :: thickness criteria   for too thin partial-cell
C     pCellMix_viscAr :: vertical viscosity   for too thin partial-cell
C     pCellMix_diffKr :: vertical diffusivity for too thin partial-cell
C     deltaT    :: Default timestep ( s )
C     deltaTClock  :: Timestep used as model "clock". This determines the
C                    IO frequencies and is used in tagging output. It can
C                    be totally different to the dynamical time. Typically
C                    it will be the deep-water timestep for accelerated runs.
C                    Frequency of checkpointing and dumping of the model state
C                    are referenced to this clock. ( s )
C     deltaTMom    :: Timestep for momemtum equations ( s )
C     dTtracerLev  :: Timestep for tracer equations ( s ), function of level k
C     deltaTFreeSurf :: Timestep for free-surface equation ( s )
C     freeSurfFac  :: Parameter to turn implicit free surface term on or off
C                     freeSurFac = 1. uses implicit free surface
C                     freeSurFac = 0. uses rigid lid
C     abEps        :: Adams-Bashforth-2 stabilizing weight
C     alph_AB      :: Adams-Bashforth-3 primary factor
C     beta_AB      :: Adams-Bashforth-3 secondary factor
C     implicSurfPress :: parameter of the Crank-Nickelson time stepping :
C                     Implicit part of Surface Pressure Gradient ( 0-1 )
C     implicDiv2DFlow :: parameter of the Crank-Nickelson time stepping :
C                     Implicit part of barotropic flow Divergence ( 0-1 )
C     implicitNHPress :: parameter of the Crank-Nickelson time stepping :
C                     Implicit part of Non-Hydrostatic Pressure Gradient ( 0-1 )
C     hFacMin      :: Minimum fraction size of a cell (affects hFacC etc...)
C     hFacMinDz    :: Minimum dimensional size of a cell (affects hFacC etc..., m)
C     hFacMinDp    :: Minimum dimensional size of a cell (affects hFacC etc..., Pa)
C     hFacMinDr    :: Minimum dimensional size of a cell (-> hFacC etc..., r units)
C     hFacInf      :: Threshold (inf and sup) for fraction size of surface cell
C     hFacSup          that control vanishing and creating levels
C     tauCD         :: CD scheme coupling timescale ( s )
C     rCD           :: CD scheme normalised coupling parameter (= 1 - deltaT/tauCD)
C     epsAB_CD      :: Adams-Bashforth-2 stabilizing weight used in CD scheme
C     baseTime      :: model base time (time origin) = time @ iteration zero
C     startTime     :: Starting time for this integration ( s ).
C     endTime       :: Ending time for this integration ( s ).
C     chkPtFreq     :: Frequency of rolling check pointing ( s ).
C     pChkPtFreq    :: Frequency of permanent check pointing ( s ).
C     dumpFreq      :: Frequency with which model state is written to
C                      post-processing files ( s ).
C     diagFreq      :: Frequency with which model writes diagnostic output
C                      of intermediate quantities.
C     afFacMom      :: Advection of momentum term tracer parameter
C     vfFacMom      :: Momentum viscosity tracer parameter
C     pfFacMom      :: Momentum pressure forcing tracer parameter
C     cfFacMom      :: Coriolis term tracer parameter
C     foFacMom      :: Momentum forcing tracer parameter
C     mtFacMom      :: Metric terms tracer parameter
C     cosPower      :: Power of cosine of latitude to multiply viscosity
C     cAdjFreq      :: Frequency of convective adjustment
C
C     taveFreq      :: Frequency with which time-averaged model state
C                      is written to post-processing files ( s ).
C     tave_lastIter :: (for state variable only) fraction of the last time
C                      step (of each taveFreq period) put in the time average.
C                      (fraction for 1rst iter = 1 - tave_lastIter)
C     tauThetaClimRelax :: Relaxation to climatology time scale ( s ).
C     tauSaltClimRelax :: Relaxation to climatology time scale ( s ).
C     latBandClimRelax :: latitude band where Relaxation to Clim. is applied,
C                         i.e. where |yC| <= latBandClimRelax
C     externForcingPeriod :: Is the period of which forcing varies (eg. 1 month)
C     externForcingCycle :: Is the repeat time of the forcing (eg. 1 year)
C                          (note: externForcingCycle must be an integer
C                           number times externForcingPeriod)
C     convertFW2Salt :: salinity, used to convert Fresh-Water Flux to Salt Flux
C                       (use model surface (local) value if set to -1)
C     temp_EvPrRn :: temperature of Rain & Evap.
C     salt_EvPrRn :: salinity of Rain & Evap.
C     temp_addMass :: temperature of addMass array
C     salt_addMass :: salinity of addMass array
C        (notes: a) tracer content of Rain/Evap only used if both
C                     NonLin_FrSurf & useRealFreshWater are set.
C                b) use model surface (local) value if set to UNSET_RL)
C     hMixCriteria:: criteria for mixed-layer diagnostic
C     dRhoSmall   :: parameter for mixed-layer diagnostic
C     hMixSmooth  :: Smoothing parameter for mixed-layer diag (default=0=no smoothing)
C     ivdc_kappa  :: implicit vertical diffusivity for convection [m^2/s]
C     sideDragFactor     :: side-drag scaling factor (used only if no_slip_sides)
C                           (default=2: full drag ; =1: gives half-slip BC)
C     bottomDragLinear    :: Linear    bottom-drag coefficient (units of [r]/s)
C     bottomDragQuadratic :: Quadratic bottom-drag coefficient (units of [r]/m)
C               (if using zcoordinate, units becomes linear: m/s, quadratic: [-])
C     smoothAbsFuncRange :: 1/2 of interval around zero, for which FORTRAN ABS
C                           is to be replace by a smoother function
C                           (affects myabs, mymin, mymax)
C     nh_Am2        :: scales the non-hydrostatic terms and changes internal scales
C                      (i.e. allows convection at different Rayleigh numbers)
C     tCylIn        :: Temperature of the cylinder inner boundary
C     tCylOut       :: Temperature of the cylinder outer boundary
C     phiEuler      :: Euler angle, rotation about original z-axis
C     thetaEuler    :: Euler angle, rotation about new x-axis
C     psiEuler      :: Euler angle, rotation about new z-axis
      COMMON /PARM_R/ cg2dTargetResidual, cg2dTargetResWunit,
     & cg2dpcOffDFac, cg3dTargetResidual,
     & delR, delRc, xgOrigin, ygOrigin, rSphere, recip_rSphere,
     & radius_fromHorizGrid, seaLev_Z, top_Pres, rSigmaBnd,
     & deltaT, deltaTMom, dTtracerLev, deltaTFreeSurf, deltaTClock,
     & abEps, alph_AB, beta_AB,
     & f0, beta, fPrime, omega, rotationPeriod,
     & viscFacAdj, viscAh, viscAhW, smag3D_coeff, smag3D_diffCoeff,
     & viscAhMax, viscAhGrid, viscAhGridMax, viscAhGridMin,
     & viscC2leith, viscC2leithD, viscC2LeithQG,
     & viscC2smag, viscC4smag,
     & viscAhD, viscAhZ, viscA4D, viscA4Z,
     & viscA4, viscA4W, viscA4Max,
     & viscA4Grid, viscA4GridMax, viscA4GridMin,
     & viscAhReMax, viscA4ReMax,
     & viscC4leith, viscC4leithD, viscArNr,
     & diffKhT, diffK4T, diffKrNrT, diffKr4T,
     & diffKhS, diffK4S, diffKrNrS, diffKr4S,
     & diffKrBL79surf, diffKrBL79deep, diffKrBL79scl, diffKrBL79Ho,
     & BL79LatVary,
     & diffKrBLEQsurf, diffKrBLEQdeep, diffKrBLEQscl, diffKrBLEQHo,
     & pCellMix_maxFac, pCellMix_delR, pCellMix_viscAr, pCellMix_diffKr,
     & tauCD, rCD, epsAB_CD,
     & freeSurfFac, implicSurfPress, implicDiv2DFlow, implicitNHPress,
     & hFacMin, hFacMinDz, hFacInf, hFacSup,
     & gravity, recip_gravity, gBaro,
     & gravFacC, recip_gravFacC, gravFacF, recip_gravFacF,
     & rhoNil, rhoConst, recip_rhoConst, rho1Ref,
     & rhoFacC, recip_rhoFacC, rhoFacF, recip_rhoFacF, rhoConstFresh,
     & thetaConst, tRef, sRef, surf_pRef, pRef4EOS, phiRef, dBdrRef,
     & rVel2wUnit, wUnit2rVel, mass2rUnit, rUnit2mass,
     & baseTime, startTime, endTime,
     & chkPtFreq, pChkPtFreq, dumpFreq, adjDumpFreq,
     & diagFreq, taveFreq, tave_lastIter, monitorFreq, adjMonitorFreq,
     & afFacMom, vfFacMom, pfFacMom, cfFacMom, foFacMom, mtFacMom,
     & cosPower, cAdjFreq,
     & tauThetaClimRelax, tauSaltClimRelax, latBandClimRelax,
     & externForcingCycle, externForcingPeriod,
     & convertFW2Salt, temp_EvPrRn, salt_EvPrRn,
     & temp_addMass, salt_addMass, hFacMinDr, hFacMinDp,
     & ivdc_kappa, hMixCriteria, dRhoSmall, hMixSmooth,
     & sideDragFactor, bottomDragLinear, bottomDragQuadratic, nh_Am2,
     & smoothAbsFuncRange, sIceLoadFac,
     & tCylIn, tCylOut,
     & phiEuler, thetaEuler, psiEuler

      Real*8 cg2dTargetResidual
      Real*8 cg2dTargetResWunit
      Real*8 cg3dTargetResidual
      Real*8 cg2dpcOffDFac
      Real*8 delR(Nr)
      Real*8 delRc(Nr+1)
      Real*8 xgOrigin
      Real*8 ygOrigin
      Real*8 rSphere
      Real*8 recip_rSphere
      Real*8 radius_fromHorizGrid
      Real*8 seaLev_Z
      Real*8 top_Pres
      Real*8 rSigmaBnd
      Real*8 deltaT
      Real*8 deltaTClock
      Real*8 deltaTMom
      Real*8 dTtracerLev(Nr)
      Real*8 deltaTFreeSurf
      Real*8 abEps, alph_AB, beta_AB
      Real*8 f0
      Real*8 beta
      Real*8 fPrime
      Real*8 omega
      Real*8 rotationPeriod
      Real*8 freeSurfFac
      Real*8 implicSurfPress
      Real*8 implicDiv2DFlow
      Real*8 implicitNHPress
      Real*8 hFacMin
      Real*8 hFacMinDz
      Real*8 hFacMinDp
      Real*8 hFacMinDr
      Real*8 hFacInf
      Real*8 hFacSup
      Real*8 viscArNr(Nr)
      Real*8 viscFacAdj
      Real*8 viscAh
      Real*8 viscAhW
      Real*8 viscAhD
      Real*8 viscAhZ
      Real*8 smag3D_coeff, smag3D_diffCoeff
      Real*8 viscAhMax
      Real*8 viscAhReMax
      Real*8 viscAhGrid, viscAhGridMax, viscAhGridMin
      Real*8 viscC2leith
      Real*8 viscC2leithD
      Real*8 viscC2LeithQG
      Real*8 viscC2smag
      Real*8 viscA4
      Real*8 viscA4W
      Real*8 viscA4D
      Real*8 viscA4Z
      Real*8 viscA4Max
      Real*8 viscA4ReMax
      Real*8 viscA4Grid, viscA4GridMax, viscA4GridMin
      Real*8 viscC4leith
      Real*8 viscC4leithD
      Real*8 viscC4smag
      Real*8 diffKhT
      Real*8 diffK4T
      Real*8 diffKrNrT(Nr)
      Real*8 diffKr4T(Nr)
      Real*8 diffKhS
      Real*8 diffK4S
      Real*8 diffKrNrS(Nr)
      Real*8 diffKr4S(Nr)
      Real*8 diffKrBL79surf
      Real*8 diffKrBL79deep
      Real*8 diffKrBL79scl
      Real*8 diffKrBL79Ho
      Real*8 BL79LatVary
      Real*8 diffKrBLEQsurf
      Real*8 diffKrBLEQdeep
      Real*8 diffKrBLEQscl
      Real*8 diffKrBLEQHo
      Real*8 pCellMix_maxFac
      Real*8 pCellMix_delR
      Real*8 pCellMix_viscAr(Nr)
      Real*8 pCellMix_diffKr(Nr)
      Real*8 tauCD, rCD, epsAB_CD
      Real*8 gravity,       recip_gravity
      Real*8 gBaro
      Real*8 gravFacC(Nr),   recip_gravFacC(Nr)
      Real*8 gravFacF(Nr+1), recip_gravFacF(Nr+1)
      Real*8 rhoNil
      Real*8 rhoConst,      recip_rhoConst
      Real*8 rho1Ref(Nr)
      Real*8 rhoFacC(Nr),   recip_rhoFacC(Nr)
      Real*8 rhoFacF(Nr+1), recip_rhoFacF(Nr+1)
      Real*8 rhoConstFresh
      Real*8 thetaConst
      Real*8 tRef(Nr)
      Real*8 sRef(Nr)
      Real*8 surf_pRef, pRef4EOS(Nr)
      Real*8 phiRef(2*Nr+1)
      Real*8 dBdrRef(Nr)
      Real*8 rVel2wUnit(Nr+1), wUnit2rVel(Nr+1)
      Real*8 mass2rUnit, rUnit2mass
      Real*8 baseTime
      Real*8 startTime
      Real*8 endTime
      Real*8 chkPtFreq
      Real*8 pChkPtFreq
      Real*8 dumpFreq
      Real*8 adjDumpFreq
      Real*8 diagFreq
      Real*8 taveFreq
      Real*8 tave_lastIter
      Real*8 monitorFreq
      Real*8 adjMonitorFreq
      Real*8 afFacMom
      Real*8 vfFacMom
      Real*8 pfFacMom
      Real*8 cfFacMom
      Real*8 foFacMom
      Real*8 mtFacMom
      Real*8 cosPower
      Real*8 cAdjFreq
      Real*8 tauThetaClimRelax
      Real*8 tauSaltClimRelax
      Real*8 latBandClimRelax
      Real*8 externForcingCycle
      Real*8 externForcingPeriod
      Real*8 convertFW2Salt
      Real*8 temp_EvPrRn
      Real*8 salt_EvPrRn
      Real*8 temp_addMass
      Real*8 salt_addMass
      Real*8 ivdc_kappa
      Real*8 hMixCriteria
      Real*8 dRhoSmall
      Real*8 hMixSmooth
      Real*8 sideDragFactor
      Real*8 bottomDragLinear
      Real*8 bottomDragQuadratic
      Real*8 smoothAbsFuncRange
      Real*8 sIceLoadFac
      Real*8 nh_Am2
      Real*8 tCylIn, tCylOut
      Real*8 phiEuler, thetaEuler, psiEuler

C--   COMMON /PARM_A/ Thermodynamics constants ?
      COMMON /PARM_A/ HeatCapacity_Cp
      Real*8 HeatCapacity_Cp

C--   COMMON /PARM_ATM/ Atmospheric physical parameters (Ideal Gas EOS, ...)
C     celsius2K :: convert centigrade (Celsius) degree to Kelvin
C     atm_Po    :: standard reference pressure
C     atm_Cp    :: specific heat (Cp) of the (dry) air at constant pressure
C     atm_Rd    :: gas constant for dry air
C     atm_kappa :: kappa = R/Cp (R: constant of Ideal Gas EOS)
C     atm_Rq    :: water vapour specific volume anomaly relative to dry air
C                  (e.g. typical value = (29/18 -1) 10^-3 with q [g/kg])
C     integr_GeoPot :: option to select the way we integrate the geopotential
C                     (still a subject of discussions ...)
C     selectFindRoSurf :: select the way surf. ref. pressure (=Ro_surf) is
C             derived from the orography. Implemented: 0,1 (see INI_P_GROUND)
      COMMON /PARM_ATM/
     &            celsius2K,
     &            atm_Cp, atm_Rd, atm_kappa, atm_Rq, atm_Po,
     &            integr_GeoPot, selectFindRoSurf
      Real*8 celsius2K
      Real*8 atm_Po, atm_Cp, atm_Rd, atm_kappa, atm_Rq
      INTEGER integr_GeoPot, selectFindRoSurf

C----------------------------------------
C-- Logical flags for selecting packages
      LOGICAL useGAD
      LOGICAL useOBCS
      LOGICAL useSHAP_FILT
      LOGICAL useZONAL_FILT
      LOGICAL useOPPS
      LOGICAL usePP81
      LOGICAL useKL10
      LOGICAL useMY82
      LOGICAL useGGL90
      LOGICAL useKPP
      LOGICAL useGMRedi
      LOGICAL useDOWN_SLOPE
      LOGICAL useBBL
      LOGICAL useCAL
      LOGICAL useEXF
      LOGICAL useBulkForce
      LOGICAL useEBM
      LOGICAL useCheapAML
      LOGICAL useAUTODIFF
      LOGICAL useGrdchk
      LOGICAL useSMOOTH
      LOGICAL usePROFILES
      LOGICAL useECCO
      LOGICAL useCTRL
      LOGICAL useSBO
      LOGICAL useFLT
      LOGICAL usePTRACERS
      LOGICAL useGCHEM
      LOGICAL useRBCS
      LOGICAL useOffLine
      LOGICAL useMATRIX
      LOGICAL useFRAZIL
      LOGICAL useSEAICE
      LOGICAL useSALT_PLUME
      LOGICAL useShelfIce
      LOGICAL useStreamIce
      LOGICAL useICEFRONT
      LOGICAL useThSIce
      LOGICAL useLand
      LOGICAL useATM2d
      LOGICAL useAIM
      LOGICAL useAtm_Phys
      LOGICAL useFizhi
      LOGICAL useGridAlt
      LOGICAL useDiagnostics
      LOGICAL useREGRID
      LOGICAL useLayers
      LOGICAL useMNC
      LOGICAL useRunClock
      LOGICAL useEMBED_FILES
      LOGICAL useMYPACKAGE
      COMMON /PARM_PACKAGES/
     &        useGAD, useOBCS, useSHAP_FILT, useZONAL_FILT,
     &        useOPPS, usePP81, useKL10, useMY82, useGGL90, useKPP,
     &        useGMRedi, useBBL, useDOWN_SLOPE,
     &        useCAL, useEXF, useBulkForce, useEBM, useCheapAML,
     &        useGrdchk, useSMOOTH, usePROFILES, useECCO, useCTRL,
     &        useSBO, useFLT, useAUTODIFF,
     &        usePTRACERS, useGCHEM, useRBCS, useOffLine, useMATRIX,
     &        useFRAZIL, useSEAICE, useSALT_PLUME, useShelfIce,
     &        useStreamIce, useICEFRONT, useThSIce, useLand,
     &        useATM2D, useAIM, useAtm_Phys, useFizhi, useGridAlt,
     &        useDiagnostics, useREGRID, useLayers, useMNC,
     &        useRunClock, useEMBED_FILES,
     &        useMYPACKAGE

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
C
CBOP
C    !ROUTINE: GRID.h
C    !INTERFACE:
C    include GRID.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | GRID.h
C     | o Header file defining model grid.
C     *==========================================================*
C     | Model grid is defined for each process by reference to
C     | the arrays set here.
C     | Notes
C     | =====
C     | The standard MITgcm convention of westmost, southern most
C     | and upper most having the (1,1,1) index is used here.
C     | i.e.
C     |----------------------------------------------------------
C     | (1)  Plan view schematic of model grid (top layer i.e. )
C     |      ================================= ( ocean surface )
C     |                                        ( or top of     )
C     |                                        ( atmosphere    )
C     |      This diagram shows the location of the model
C     |      prognostic variables on the model grid. The "T"
C     |      location is used for all tracers. The figure also
C     |      shows the southern most, western most indexing
C     |      convention that is used for all model variables.
C     |
C     |
C     |             V(i=1,                     V(i=Nx,
C     |               j=Ny+1,                    j=Ny+1,
C     |               k=1)                       k=1)
C     |                /|\                       /|\  "PWX"
C     |       |---------|------------------etc..  |---- *---
C     |       |                     |                   *  |
C     |"PWY"*******************************etc..  **********"PWY"
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |U(i=1, ==>       x           |             x     *==>U
C     |  j=Ny,|      T(i=1,         |          T(i=Nx,  *(i=Nx+1,
C     |  k=1) |        j=Ny,        |            j=Ny,  *  |j=Ny,
C     |       |        k=1)         |            k=1)   *  |k=1)
C     |
C     |       .                     .                      .
C     |       .                     .                      .
C     |       .                     .                      .
C     |       e                     e                   *  e
C     |       t                     t                   *  t
C     |       c                     c                   *  c
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |U(i=1, ==>       x           |             x     *  |
C     |  j=2, |      T(i=1,         |          T(i=Nx,  *  |
C     |  k=1) |        j=2,         |            j=2,   *  |
C     |       |        k=1)         |            k=1)   *  |
C     |       |                     |                   *  |
C     |       |        /|\          |            /|\    *  |
C     |      -----------|------------------etc..  |-----*---
C     |       |       V(i=1,        |           V(i=Nx, *  |
C     |       |         j=2,        |             j=2,  *  |
C     |       |         k=1)        |             k=1)  *  |
C     |       |                     |                   *  |
C     |U(i=1, ==>       x         ==>U(i=2,       x     *==>U
C     |  j=1, |      T(i=1,         |  j=1,    T(i=Nx,  *(i=Nx+1,
C     |  k=1) |        j=1,         |  k=1)      j=1,   *  |j=1,
C     |       |        k=1)         |            k=1)   *  |k=1)
C     |       |                     |                   *  |
C     |       |        /|\          |            /|\    *  |
C     |"SB"++>|---------|------------------etc..  |-----*---
C     |      /+\      V(i=1,                    V(i=Nx, *
C     |       +         j=1,                      j=1,  *
C     |       +         k=1)                      k=1)  *
C     |     "WB"                                      "PWX"
C     |
C     |   N, y increasing northwards
C     |  /|\ j increasing northwards
C     |   |
C     |   |
C     |   ======>E, x increasing eastwards
C     |             i increasing eastwards
C     |
C     |    i: East-west index
C     |    j: North-south index
C     |    k: up-down index
C     |    U: x-velocity (m/s)
C     |    V: y-velocity (m/s)
C     |    T: potential temperature (oC)
C     | "SB": Southern boundary
C     | "WB": Western boundary
C     |"PWX": Periodic wrap around in X.
C     |"PWY": Periodic wrap around in Y.
C     |----------------------------------------------------------
C     | (2) South elevation schematic of model grid
C     |     =======================================
C     |     This diagram shows the location of the model
C     |     prognostic variables on the model grid. The "T"
C     |     location is used for all tracers. The figure also
C     |     shows the upper most, western most indexing
C     |     convention that is used for all model variables.
C     |
C     |      "WB"
C     |       +
C     |       +
C     |      \+/       /|\                       /|\       .
C     |"UB"++>|-------- | -----------------etc..  | ----*---
C     |       |    rVel(i=1,        |        rVel(i=Nx, *  |
C     |       |         j=1,        |             j=1,  *  |
C     |       |         k=1)        |             k=1)  *  |
C     |       |                     |                   *  |
C     |U(i=1, ==>       x         ==>U(i=2,       x     *==>U
C     |  j=1, |      T(i=1,         |  j=1,    T(i=Nx,  *(i=Nx+1,
C     |  k=1) |        j=1,         |  k=1)      j=1,   *  |j=1,
C     |       |        k=1)         |            k=1)   *  |k=1)
C     |       |                     |                   *  |
C     |       |        /|\          |            /|\    *  |
C     |       |-------- | -----------------etc..  | ----*---
C     |       |    rVel(i=1,        |        rVel(i=Nx, *  |
C     |       |         j=1,        |             j=1,  *  |
C     |       |         k=2)        |             k=2)  *  |
C     |
C     |       .                     .                      .
C     |       .                     .                      .
C     |       .                     .                      .
C     |       e                     e                   *  e
C     |       t                     t                   *  t
C     |       c                     c                   *  c
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |       |        /|\          |            /|\    *  |
C     |       |-------- | -----------------etc..  | ----*---
C     |       |    rVel(i=1,        |        rVel(i=Nx, *  |
C     |       |         j=1,        |             j=1,  *  |
C     |       |         k=Nr)       |             k=Nr) *  |
C     |U(i=1, ==>       x         ==>U(i=2,       x     *==>U
C     |  j=1, |      T(i=1,         |  j=1,    T(i=Nx,  *(i=Nx+1,
C     |  k=Nr)|        j=1,         |  k=Nr)     j=1,   *  |j=1,
C     |       |        k=Nr)        |            k=Nr)  *  |k=Nr)
C     |       |                     |                   *  |
C     |"LB"++>==============================================
C     |                                               "PWX"
C     |
C     | Up   increasing upwards.
C     |/|\                                                       .
C     | |
C     | |
C     | =====> E  i increasing eastwards
C     | |         x increasing eastwards
C     | |
C     |\|/
C     | Down,k increasing downwards.
C     |
C     | Note: r => height (m) => r increases upwards
C     |       r => pressure (Pa) => r increases downwards
C     |
C     |
C     |    i: East-west index
C     |    j: North-south index
C     |    k: up-down index
C     |    U: x-velocity (m/s)
C     | rVel: z-velocity ( units of r )
C     |       The vertical velocity variable rVel is in units of
C     |       "r" the vertical coordinate. r in m will give
C     |       rVel m/s. r in Pa will give rVel Pa/s.
C     |    T: potential temperature (oC)
C     | "UB": Upper boundary.
C     | "LB": Lower boundary (always solid - therefore om|w == 0)
C     | "WB": Western boundary
C     |"PWX": Periodic wrap around in X.
C     |----------------------------------------------------------
C     | (3) Views showing nomenclature and indexing
C     |     for grid descriptor variables.
C     |
C     |      Fig 3a. shows the orientation, indexing and
C     |      notation for the grid spacing terms used internally
C     |      for the evaluation of gradient and averaging terms.
C     |      These varaibles are set based on the model input
C     |      parameters which define the model grid in terms of
C     |      spacing in X, Y and Z.
C     |
C     |      Fig 3b. shows the orientation, indexing and
C     |      notation for the variables that are used to define
C     |      the model grid. These varaibles are set directly
C     |      from the model input.
C     |
C     | Figure 3a
C     | =========
C     |       |------------------------------------
C     |       |                       |
C     |"PWY"********************************* etc...
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |
C     |       .                       .
C     |       .                       .
C     |       .                       .
C     |       e                       e
C     |       t                       t
C     |       c                       c
C     |       |-----------v-----------|-----------v----------|-
C     |       |                       |                      |
C     |       |                       |                      |
C     |       |                       |                      |
C     |       |                       |                      |
C     |       |                       |                      |
C     |       u<--dxF(i=1,j=2,k=1)--->u           t          |
C     |       |/|\       /|\          |                      |
C     |       | |         |           |                      |
C     |       | |         |           |                      |
C     |       | |         |           |                      |
C     |       |dyU(i=1,  dyC(i=1,     |                      |
C     | ---  ---|--j=2,---|--j=2,-----------------v----------|-
C     | /|\   | |  k=1)   |  k=1)     |          /|\         |
C     |  |    | |         |           |          dyF(i=2,    |
C     |  |    | |         |           |           |  j=1,    |
C     |dyG(   |\|/       \|/          |           |  k=1)    |
C     |   i=1,u---        t<---dxC(i=2,j=1,k=1)-->t          |
C     |   j=1,|                       |           |          |
C     |   k=1)|                       |           |          |
C     |  |    |                       |           |          |
C     |  |    |                       |           |          |
C     | \|/   |           |<---dxV(i=2,j=1,k=1)--\|/         |
C     |"SB"++>|___________v___________|___________v__________|_
C     |       <--dxG(i=1,j=1,k=1)----->
C     |      /+\                                              .
C     |       +
C     |       +
C     |     "WB"
C     |
C     |   N, y increasing northwards
C     |  /|\ j increasing northwards
C     |   |
C     |   |
C     |   ======>E, x increasing eastwards
C     |             i increasing eastwards
C     |
C     |    i: East-west index
C     |    j: North-south index
C     |    k: up-down index
C     |    u: x-velocity point
C     |    V: y-velocity point
C     |    t: tracer point
C     | "SB": Southern boundary
C     | "WB": Western boundary
C     |"PWX": Periodic wrap around in X.
C     |"PWY": Periodic wrap around in Y.
C     |
C     | Figure 3b
C     | =========
C     |
C     |       .                       .
C     |       .                       .
C     |       .                       .
C     |       e                       e
C     |       t                       t
C     |       c                       c
C     |       |-----------v-----------|-----------v--etc...
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       u<--delX(i=1)---------->u           t
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |-----------v-----------------------v--etc...
C     |       |          /|\          |
C     |       |           |           |
C     |       |           |           |
C     |       |           |           |
C     |       u        delY(j=1)      |           t
C     |       |           |           |
C     |       |           |           |
C     |       |           |           |
C     |       |           |           |
C     |       |          \|/          |
C     |"SB"++>|___________v___________|___________v__etc...
C     |      /+\                                                 .
C     |       +
C     |       +
C     |     "WB"
C     |
C     *==========================================================*
C     \ev
CEOP

C     Macros that override/modify standard definitions
C
CBOP
C    !ROUTINE: GRID_MACROS.h
C    !INTERFACE:
C    include GRID_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | GRID_MACROS.h
C     *==========================================================*
C     | These macros are used to substitute definitions for
C     | GRID.h variables for particular configurations.
C     | In setting these variables the following convention
C     | applies.
C     | undef  phi_CONST   - Indicates the variable phi is fixed
C     |                      in X, Y and Z.
C     | undef  phi_FX      - Indicates the variable phi only
C     |                      varies in X (i.e.not in X or Z).
C     | undef  phi_FY      - Indicates the variable phi only
C     |                      varies in Y (i.e.not in X or Z).
C     | undef  phi_FXY     - Indicates the variable phi only
C     |                      varies in X and Y ( i.e. not Z).
C     *==========================================================*
C     \ev
CEOP

C
CBOP
C    !ROUTINE: DXC_MACROS.h
C    !INTERFACE:
C    include DXC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DXC_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: DXF_MACROS.h
C    !INTERFACE:
C    include DXF_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DXF_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: DXG_MACROS.h
C    !INTERFACE:
C    include DXG_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DXG_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: DXV_MACROS.h
C    !INTERFACE:
C    include DXV_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DXV_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: DYC_MACROS.h
C    !INTERFACE:
C    include DYC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DYC_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: DYF_MACROS.h
C    !INTERFACE:
C    include DYF_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DYF_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: DYG_MACROS.h
C    !INTERFACE:
C    include DYG_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DYG_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: DYU_MACROS.h
C    !INTERFACE:
C    include DYU_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DYU_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: HFACC_MACROS.h
C    !INTERFACE:
C    include HFACC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | HFACC_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C
CBOP
C    !ROUTINE: HFACS_MACROS.h
C    !INTERFACE:
C    include HFACS_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | HFACS_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C
CBOP
C    !ROUTINE: HFACW_MACROS.h
C    !INTERFACE:
C    include HFACW_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | HFACW_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C
CBOP
C    !ROUTINE: RECIP_DXC_MACROS.h
C    !INTERFACE:
C    include RECIP_DXC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DXC_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: RECIP_DXF_MACROS.h
C    !INTERFACE:
C    include RECIP_DXF_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DXF_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: RECIP_DXG_MACROS.h
C    !INTERFACE:
C    include RECIP_DXG_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DXG_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: RECIP_DXV_MACROS.h
C    !INTERFACE:
C    include RECIP_DXV_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DXV_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: RECIP_DYC_MACROS.h
C    !INTERFACE:
C    include RECIP_DYC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DYC_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: RECIP_DYF_MACROS.h
C    !INTERFACE:
C    include RECIP_DYF_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DYF_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: RECIP_DYG_MACROS.h
C    !INTERFACE:
C    include RECIP_DYG_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DYG_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: RECIP_DYU_MACROS.h
C    !INTERFACE:
C    include RECIP_DYU_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DYU_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: RECIP_HFACC_MACROS.h
C    !INTERFACE:
C    include RECIP_HFACC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_HFACC_MACROS.h                                      
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C
CBOP
C    !ROUTINE: RECIP_HFACS_MACROS.h
C    !INTERFACE:
C    include RECIP_HFACS_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_HFACS_MACROS.h                                      
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C
CBOP
C    !ROUTINE: RECIP_HFACW_MACROS.h
C    !INTERFACE:
C    include RECIP_HFACW_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_HFACW_MACROS.h                                      
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C
CBOP
C    !ROUTINE: XC_MACROS.h
C    !INTERFACE:
C    include XC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | XC_MACROS.h                                               
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: YC_MACROS.h
C    !INTERFACE:
C    include YC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | YC_MACROS.h                                               
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: RA_MACROS.h
C    !INTERFACE:
C    include RA_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RA_MACROS.h                                               
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP




C
CBOP
C    !ROUTINE: RAW_MACROS.h
C    !INTERFACE:
C    include RAW_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RAW_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP




C
CBOP
C    !ROUTINE: RAS_MACROS.h
C    !INTERFACE:
C    include RAS_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RAS_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: MASKW_MACROS.h
C    !INTERFACE:
C    include MASKW_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | MASKW_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP






C
CBOP
C    !ROUTINE: MASKS_MACROS.h
C    !INTERFACE:
C    include MASKS_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | MASKS_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP






C
CBOP
C    !ROUTINE: TANPHIATU_MACROS.h
C    !INTERFACE:
C    include TANPHIATU_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | TANPHIATU_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: TANPHIATV_MACROS.h
C    !INTERFACE:
C    include TANPHIATV_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | TANPHIATV_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C
CBOP
C    !ROUTINE: FCORI_MACROS.h
C    !INTERFACE:
C    include FCORI_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | FCORI_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C--   COMMON /GRID_RL/ RL valued grid defining variables.
C     deepFacC  :: deep-model grid factor (fct of vertical only) for dx,dy
C     deepFacF     at level-center (deepFacC)  and level interface (deepFacF)
C     deepFac2C :: deep-model grid factor (fct of vertical only) for area dx*dy
C     deepFac2F    at level-center (deepFac2C) and level interface (deepFac2F)
C     gravitySign :: indicates the direction of gravity relative to R direction
C                   (= -1 for R=Z (Z increases upward, -gravity direction  )
C                   (= +1 for R=P (P increases downward, +gravity direction)
C     rkSign     :: Vertical coordinate to vertical index orientation.
C                   ( +1 same orientation, -1 opposite orientation )
C     globalArea :: Domain Integrated horizontal Area [m2]
      COMMON /GRID_RL/
     &  cosFacU, cosFacV, sqCosFacU, sqCosFacV,
     &  deepFacC, deepFac2C, recip_deepFacC, recip_deepFac2C,
     &  deepFacF, deepFac2F, recip_deepFacF, recip_deepFac2F,
     &  gravitySign, rkSign, globalArea
      Real*8 cosFacU        (1-OLy:sNy+OLy,nSx,nSy)
      Real*8 cosFacV        (1-OLy:sNy+OLy,nSx,nSy)
      Real*8 sqCosFacU      (1-OLy:sNy+OLy,nSx,nSy)
      Real*8 sqCosFacV      (1-OLy:sNy+OLy,nSx,nSy)
      Real*8 deepFacC       (Nr)
      Real*8 deepFac2C      (Nr)
      Real*8 deepFacF       (Nr+1)
      Real*8 deepFac2F      (Nr+1)
      Real*8 recip_deepFacC (Nr)
      Real*8 recip_deepFac2C(Nr)
      Real*8 recip_deepFacF (Nr+1)
      Real*8 recip_deepFac2F(Nr+1)
      Real*8 gravitySign
      Real*8 rkSign
      Real*8 globalArea

C--   COMMON /GRID_RS/ RS valued grid defining variables.
C     dxC     :: Cell center separation in X across western cell wall (m)
C     dxG     :: Cell face separation in X along southern cell wall (m)
C     dxF     :: Cell face separation in X thru cell center (m)
C     dxV     :: V-point separation in X across south-west corner of cell (m)
C     dyC     :: Cell center separation in Y across southern cell wall (m)
C     dyG     :: Cell face separation in Y along western cell wall (m)
C     dyF     :: Cell face separation in Y thru cell center (m)
C     dyU     :: U-point separation in Y across south-west corner of cell (m)
C     drC     :: Cell center separation along Z axis ( units of r ).
C     drF     :: Cell face separation along Z axis ( units of r ).
C     R_low   :: base of fluid in r_unit (Depth(m) / Pressure(Pa) at top Atmos.)
C     rLowW   :: base of fluid column in r_unit at Western  edge location.
C     rLowS   :: base of fluid column in r_unit at Southern edge location.
C     Ro_surf :: surface reference (at rest) position, r_unit.
C     rSurfW  :: surface reference position at Western  edge location [r_unit].
C     rSurfS  :: surface reference position at Southern edge location [r_unit].
C     hFac    :: Fraction of cell in vertical which is open i.e how
C              "lopped" a cell is (dimensionless scale factor).
C              Note: The code needs terms like MIN(hFac,hFac(I-1))
C                    On some platforms it may be better to precompute
C                    hFacW, hFacS, ... here than do MIN on the fly.
C     maskInC :: Cell Center 2-D Interior mask (i.e., zero beyond OB)
C     maskInW :: West  face 2-D Interior mask (i.e., zero on and beyond OB)
C     maskInS :: South face 2-D Interior mask (i.e., zero on and beyond OB)
C     maskC   :: cell Center land mask
C     maskW   :: West face land mask
C     maskS   :: South face land mask
C     recip_dxC   :: Reciprocal of dxC
C     recip_dxG   :: Reciprocal of dxG
C     recip_dxF   :: Reciprocal of dxF
C     recip_dxV   :: Reciprocal of dxV
C     recip_dyC   :: Reciprocal of dxC
C     recip_dyG   :: Reciprocal of dyG
C     recip_dyF   :: Reciprocal of dyF
C     recip_dyU   :: Reciprocal of dyU
C     recip_drC   :: Reciprocal of drC
C     recip_drF   :: Reciprocal of drF
C     recip_Rcol  :: Inverse of cell center column thickness (1/r_unit)
C     recip_hFacC :: Inverse of cell open-depth f[X,Y,Z] ( dimensionless ).
C     recip_hFacW    rhFacC center, rhFacW west, rhFacS south.
C     recip_hFacS    Note: This is precomputed here because it involves division.
C     xC        :: X-coordinate of cell center f[X,Y]. The units of xc, yc
C                  depend on the grid. They are not used in differencing or
C                  averaging but are just a convient quantity for I/O,
C                  diagnostics etc.. As such xc is in m for cartesian
C                  coordinates but degrees for spherical polar.
C     yC        :: Y-coordinate of center of cell f[X,Y].
C     yG        :: Y-coordinate of corner of cell ( c-grid vorticity point) f[X,Y].
C     rA        :: R-face are f[X,Y] ( m^2 ).
C                  Note: In a cartesian framework rA is simply dx*dy,
C                      however we use rA to allow for non-globally
C                      orthogonal coordinate frames (with appropriate
C                      metric terms).
C     rC        :: R-coordinate of center of cell f[Z] (units of r).
C     rF        :: R-coordinate of face of cell f[Z] (units of r).
C - *HybSigm* - :: Hybrid-Sigma vert. Coord coefficients
C     aHybSigmF    at level-interface (*HybSigmF) and level-center (*HybSigmC)
C     aHybSigmC    aHybSigm* = constant r part, bHybSigm* = sigma part, such as
C     bHybSigmF    r(ij,k,t) = rLow(ij) + aHybSigm(k)*[rF(1)-rF(Nr+1)]
C     bHybSigmC              + bHybSigm(k)*[eta(ij,t)+Ro_surf(ij) - rLow(ij)]
C     dAHybSigF :: vertical increment of Hybrid-Sigma coefficient: constant r part,
C     dAHybSigC    between interface (dAHybSigF) and between center (dAHybSigC)
C     dBHybSigF :: vertical increment of Hybrid-Sigma coefficient: sigma part,
C     dBHybSigC    between interface (dBHybSigF) and between center (dBHybSigC)
C     tanPhiAtU :: tan of the latitude at U point. Used for spherical polar
C                  metric term in U equation.
C     tanPhiAtV :: tan of the latitude at V point. Used for spherical polar
C                  metric term in V equation.
C     angleCosC :: cosine of grid orientation angle relative to Geographic direction
C               at cell center: alpha=(Eastward_dir,grid_uVel_dir)=(North_d,vVel_d)
C     angleSinC :: sine   of grid orientation angle relative to Geographic direction
C               at cell center: alpha=(Eastward_dir,grid_uVel_dir)=(North_d,vVel_d)
C     u2zonDir  :: cosine of grid orientation angle at U point location
C     v2zonDir  :: minus sine of  orientation angle at V point location
C     fCori     :: Coriolis parameter at grid Center point
C     fCoriG    :: Coriolis parameter at grid Corner point
C     fCoriCos  :: Coriolis Cos(phi) parameter at grid Center point (for NH)

      COMMON /GRID_RS/
     &  dxC,dxF,dxG,dxV,dyC,dyF,dyG,dyU,
     &  R_low, rLowW, rLowS,
     &  Ro_surf, rSurfW, rSurfS,
     &  hFacC, hFacW, hFacS,
     &  recip_dxC,recip_dxF,recip_dxG,recip_dxV,
     &  recip_dyC,recip_dyF,recip_dyG,recip_dyU,
     &  recip_Rcol,
     &  recip_hFacC,recip_hFacW,recip_hFacS,
     &  xC,yC,rA,rAw,rAs,rAz,xG,yG,
     &  maskInC, maskInW, maskInS,
     &  maskC, maskW, maskS,
     &  recip_rA,recip_rAw,recip_rAs,recip_rAz,
     &  drC, drF, recip_drC, recip_drF, rC, rF,
     &  aHybSigmF, bHybSigmF, aHybSigmC, bHybSigmC,
     &  dAHybSigF, dBHybSigF, dBHybSigC, dAHybSigC,
     &  tanPhiAtU, tanPhiAtV,
     &  angleCosC, angleSinC, u2zonDir, v2zonDir,
     &  fCori, fCoriG, fCoriCos
      Real*8 dxC            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dxF            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dxG            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dxV            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dyC            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dyF            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dyG            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dyU            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 R_low          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rLowW          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rLowS          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 Ro_surf        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rSurfW         (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rSurfS         (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 hFacC          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 hFacW          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 hFacS          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 recip_dxC      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dxF      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dxG      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dxV      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dyC      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dyF      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dyG      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dyU      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_Rcol     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_hFacC    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 recip_hFacW    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 recip_hFacS    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 xC             (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 xG             (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 yC             (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 yG             (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rA             (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rAw            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rAs            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rAz            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_rA       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_rAw      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_rAs      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_rAz      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 maskInC        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 maskInW        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 maskInS        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 maskC          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 maskW          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 maskS          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 drC            (Nr+1)
      Real*8 drF            (Nr)
      Real*8 recip_drC      (Nr+1)
      Real*8 recip_drF      (Nr)
      Real*8 rC             (Nr)
      Real*8 rF             (Nr+1)
      Real*8 aHybSigmF      (Nr+1)
      Real*8 bHybSigmF      (Nr+1)
      Real*8 aHybSigmC      (Nr)
      Real*8 bHybSigmC      (Nr)
      Real*8 dAHybSigF      (Nr)
      Real*8 dBHybSigF      (Nr)
      Real*8 dBHybSigC      (Nr+1)
      Real*8 dAHybSigC      (Nr+1)
      Real*8 tanPhiAtU      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 tanPhiAtV      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 angleCosC      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 angleSinC      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 u2zonDir       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 v2zonDir       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 fCori          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 fCoriG         (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 fCoriCos       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)


C--   COMMON /GRID_I/ INTEGER valued grid defining variables.
C     kSurfC  :: vertical index of the surface tracer cell
C     kSurfW  :: vertical index of the surface U point
C     kSurfS  :: vertical index of the surface V point
C     kLowC   :: index of the r-lowest "wet cell" (2D)
C IMPORTANT: kLowC = 0 and kSurfC,W,S = Nr+1 (or =Nr+2 on a thin-wall)
C            where the fluid column is empty (continent)
      COMMON /GRID_I/
     &  kSurfC, kSurfW, kSurfS,
     &  kLowC
      INTEGER kSurfC(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      INTEGER kSurfW(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      INTEGER kSurfS(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      INTEGER kLowC (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP
C !ROUTINE: GAD.h

C !INTERFACE:
C #include "GAD.h"

C !DESCRIPTION:
C Contains enumerated constants for distinguishing between different
C advection schemes and tracers.
C
C Unfortunately, there is no easy way to make use of the
C tokens in namelist input so for now we have to enter the
C tokens value into "data" (ie. 2 for 2nd order etc.)

C !USES:

C !DEFINED PARAMETERS:

C ENUM_UPWIND_1RST :: 1rst Order Upwind
      INTEGER ENUM_UPWIND_1RST
      PARAMETER(ENUM_UPWIND_1RST=1)

C ENUM_CENTERED_2ND :: Centered 2nd order
      INTEGER ENUM_CENTERED_2ND
      PARAMETER(ENUM_CENTERED_2ND=2)

C ENUM_UPWIND_3RD :: 3rd order upwind
      INTEGER ENUM_UPWIND_3RD
      PARAMETER(ENUM_UPWIND_3RD=3)

C ENUM_CENTERED_4TH :: Centered 4th order
      INTEGER ENUM_CENTERED_4TH
      PARAMETER(ENUM_CENTERED_4TH=4)

C ENUM_DST2 :: 2nd Order Direct Space and Time (= Lax-Wendroff)
      INTEGER ENUM_DST2
      PARAMETER(ENUM_DST2=20)

C ENUM_FLUX_LIMIT :: Non-linear flux limiter
      INTEGER ENUM_FLUX_LIMIT
      PARAMETER(ENUM_FLUX_LIMIT=77)

C ENUM_DST3 :: 3rd Order Direst Space and Time
      INTEGER ENUM_DST3
      PARAMETER(ENUM_DST3=30)

C ENUM_DST3_FLUX_LIMIT :: 3-DST flux limited
      INTEGER ENUM_DST3_FLUX_LIMIT
      PARAMETER(ENUM_DST3_FLUX_LIMIT=33)

C ENUM_OS7MP :: 7th Order One Step method with Monotonicity Preserving Limiter
      INTEGER ENUM_OS7MP
      PARAMETER(ENUM_OS7MP=7)

C ENUM_SOM_PRATHER :: 2nd Order-Moment Advection Scheme, Prather, 1986
      INTEGER ENUM_SOM_PRATHER
      PARAMETER(ENUM_SOM_PRATHER=80)

C ENUM_SOM_LIMITER :: 2nd Order-Moment Advection Scheme, Prather Limiter
      INTEGER ENUM_SOM_LIMITER
      PARAMETER(ENUM_SOM_LIMITER=81)

C ENUM_PPM_NULL :: piecewise parabolic method with "null" limiter
      INTEGER ENUM_PPM_NULL_LIMIT
      PARAMETER(ENUM_PPM_NULL_LIMIT=40)

C ENUM_PPM_MONO :: piecewise parabolic method with "mono" limiter
      INTEGER ENUM_PPM_MONO_LIMIT
      PARAMETER(ENUM_PPM_MONO_LIMIT=41)

C ENUM_PPM_WENO :: piecewise parabolic method with "weno" limiter
      INTEGER ENUM_PPM_WENO_LIMIT
      PARAMETER(ENUM_PPM_WENO_LIMIT=42)

C ENUM_PQM_NULL :: piecewise quartic method with "null" limiter
      INTEGER ENUM_PQM_NULL_LIMIT
      PARAMETER(ENUM_PQM_NULL_LIMIT=50)

C ENUM_PQM_MONO :: piecewise quartic method with "mono" limiter
      INTEGER ENUM_PQM_MONO_LIMIT
      PARAMETER(ENUM_PQM_MONO_LIMIT=51)

C ENUM_PQM_WENO :: piecewise quartic method with "weno" limiter
      INTEGER ENUM_PQM_WENO_LIMIT
      PARAMETER(ENUM_PQM_WENO_LIMIT=52)

C GAD_Scheme_MaxNum :: maximum possible number for an advection scheme
      INTEGER GAD_Scheme_MaxNum
      PARAMETER( GAD_Scheme_MaxNum = 100 )

C nSOM :: number of 1rst & 2nd Order-Moments: 1+1 (1D), 2+3 (2D), 3+6 (3D)
      INTEGER nSOM
      PARAMETER( nSOM = 3+6 )

C oneSixth :: Third/fourth order interpolation factor
      Real*8 oneSixth
      PARAMETER(oneSixth=1.d0/6.d0)

C loop range for computing vertical advection tendency
C  iMinAdvR,iMaxAdvR  :: 1rst index (X-dir) loop range for vertical advection
C  jMinAdvR,jMaxAdvR  :: 2nd  index (Y-dir) loop range for vertical advection
      INTEGER iMinAdvR, iMaxAdvR, jMinAdvR, jMaxAdvR
c     PARAMETER ( iMinAdvR = 1-OLx , iMaxAdvR = sNx+OLx )
c     PARAMETER ( jMinAdvR = 1-OLy , jMaxAdvR = sNy+OLy )
C- note: we use to compute vertical advection tracer tendency everywhere
C        (overlap included) as above, but really needs valid tracer tendency
C        in interior only (as below):
      PARAMETER ( iMinAdvR = 1 , iMaxAdvR = sNx )
      PARAMETER ( jMinAdvR = 1 , jMaxAdvR = sNy )

C Differentiate between tracers (needed for KPP - arrgh!!!)
cph                              and GMRedi arrgh*arrgh!!!)
cph  indices are used for TAF key computations, so need to
cph  running from 1, 2, ...
c
C GAD_TEMPERATURE :: temperature
      INTEGER GAD_TEMPERATURE
      PARAMETER(GAD_TEMPERATURE=1)
C GAD_SALINITY :: salinity
      INTEGER GAD_SALINITY
      PARAMETER(GAD_SALINITY=2)
C GAD_TR1 :: passive tracer 1
      INTEGER GAD_TR1
      PARAMETER(GAD_TR1=3)
CEOP

C--   COMMON /GAD_PARM_C/ Character parameters for GAD pkg routines
C      somSfx       :: 1rst & 2nd Order moment suffix
      CHARACTER*2 somSfx(nSOM)
      COMMON /GAD_PARM_C/
     & somSfx

C--   COMMON /GAD_PARM_I/ Integer parameters for GAD pkg routines
C GAD_OlMinSize     :: overlap minimum size for GAD routines
C           1: min required; 2: to add to current min; 3: factor to apply
      INTEGER GAD_OlMinSize(3)
      COMMON /GAD_PARM_I/
     &        GAD_OlMinSize

C--   COMMON /GAD_PARM_L/ Logical parameters for GAD pkg routines
C tempSOM_Advection :: set to T if using 2nd-Order Moment advection for Temp
C saltSOM_Advection :: set to T if using 2nd-Order Moment advection for Salt
C tempMultiDimAdvec :: set to T if using multi-dim advection for Temp
C saltMultiDimAdvec :: set to T if using multi-dim advection for Salt
C AdamsBashforthGt  :: apply Adams-Bashforth extrapolation on T tendency (=Gt)
C AdamsBashforthGs  :: apply Adams-Bashforth extrapolation on S tendency (=Gs)
C AdamsBashforth_T  :: apply Adams-Bashforth extrapolation on Pot.Temp.
C AdamsBashforth_S  :: apply Adams-Bashforth extrapolation on Salinity
      LOGICAL tempSOM_Advection
      LOGICAL saltSOM_Advection
      LOGICAL tempMultiDimAdvec
      LOGICAL saltMultiDimAdvec
      LOGICAL AdamsBashforthGt
      LOGICAL AdamsBashforthGs
      LOGICAL AdamsBashforth_T
      LOGICAL AdamsBashforth_S
      COMMON /GAD_PARM_L/
     & tempSOM_Advection, saltSOM_Advection,
     & tempMultiDimAdvec, saltMultiDimAdvec,
     & AdamsBashforthGt, AdamsBashforthGs,
     & AdamsBashforth_T, AdamsBashforth_S

      Real*8 SmolarkiewiczMaxFrac
      COMMON /GAD_SMOL/ SmolarkiewiczMaxFrac

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
C $Header: /u/gcmpack/MITgcm/verification/offline_exf_seaice/code/SEAICE_SIZE.h,v 1.4 2014/06/25 10:54:27 mlosch Exp $
C $Name:  $


CBOP
C    !ROUTINE: SEAICE_SIZE.h
C    !INTERFACE:
C #include SEAICE_SIZE.h

C    !DESCRIPTION:
C Contains seaice array-size definition (number of tracers,categories).

C SItrMaxNum :: number of passive tracers to allocate
C nITD       :: number of seaice categories to allocate
CEOP

C-    Maximum Number of categories
      INTEGER nITD
C--
      PARAMETER (nITD = 1)

C-    Maximum Number of tracers
      INTEGER SItrMaxNum
      PARAMETER(SItrMaxNum = 3 )



CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
C     *==========================================================*
C     | SEAICE_PARAMS.h
C     | o Basic parameter header for sea ice model.
C     *==========================================================*

C--   COMMON /SEAICE_PARM_L/ Logical parameters of sea ice model.
C - dynamics:
C     SEAICEuseDYNAMICS :: If false, do not use dynamics;
C                          default is to use dynamics.
C     SEAICEuseFREEDRIFT :: If True use free drift velocity instead of EVP
C                           or LSR
C     SEAICEuseStrImpCpl:: If true use strongly implicit coupling formulation
C                          for LSR solver (Hutchings et al 2004,
C                          Ocean Modelling, eq.44)
C     SEAICEuseEVP      :: If true use elastic viscous plastic solver
C     SEAICEuseEVPstar  :: If true use modified elastic viscous plastic
C                          solver (EVP*) by Lemieux et al (2012)
C     SEAICEuseEVPrev   :: If true use "revisited" elastic viscous plastic
C                          solver following Bouillon et al. (2013), very similar
C                          to EVP*, but uses fewer implicit terms and drops
C                          one 1/e^2 in equations for sigma2 and sigma12
C     SEAICEuseEVPpickup :: Set to false in order to start EVP solver with
C                          non-EVP pickup files.  Default is true.
C                          Applied only if SEAICEuseEVP=.TRUE.
C     SEAICEuseMultiTileSolver :: in LSR, use full domain tri-diagonal solver
C     SEAICEuseLSR      :: If true, use default Picard solver with Line-
C                          Successive(-over)-Relaxation, can also be true
C                          if LSR is used as a preconditioner for the
C                          non-linear JFNK solver
C     SEAICEusePicardAsPrecon :: If true, allow SEAICEuseLSR = .TRUE. as a
C                          preconditioner for non-linear JFNK problem (def. = F)
C     SEAICEuseKrylov   :: If true, use matrix-free Krylov solver with Picard
C                          solver instead of LSR (default: false)
C     SEAICEuseJFNK     :: If true, use Jacobi-free Newton-Krylov solver
C                          instead of LSR (default: false)
C     SEAICEuseIMEX     :: use IMplicit/EXplicit scheme with JFNK
C     SEAICEuseTEM      :: to use the truncated ellipse method (Geiger et al.)
C                          1998) set this parameter to true, default is false
C     SEAICEuseMCS      :: to use the Mohr-Coulomb yield curve with a shear
C                          only flow rule (Ip et al 1991), set this parameter to
C                          true, default is false
C     SEAICEuseMCE      :: to use the Mohr-Coulomb yield curve with elliptical
C                          plastic potential (similarly to Hibler and Schulson
C                          2000 without the elliptical cap) set this parameter
C                          to true, default is false
C     SEAICEuseTD       :: to use the teardrop yield curve (Zhang and Rothrock,
C                          2005) set this parameter to true, default is false
C     SEAICEusePL       :: to use the parabolic lens yield curve (Zhang and
C                          Rothrock, 2005) set this parameter to true,
C                          default is false
C     SEAICEuseMEB      :: use Maxwell-Elasto-Brittle rheology (within
C                          implicity solver for momentum equations)
C     SEAICEupdateDamage:: update damage parameter (true for MEB,
C                          false otherwise)
C     SEAICEuseTilt     :: If true then include surface tilt term in dynamics
C     SEAICEuseMetricTerms :: use metric terms for dynamics solver
C                          (default = .true. )
C     SEAICE_no_slip    :: apply no slip boundary conditions to seaice velocity
C     SEAICE_2ndOrderBC :: apply 2nd order no slip boundary conditions (works
C                          only with EVP, JFNK or KRYLOV solver, default=F)
C     SEAICE_maskRHS    :: mask the RHS of the solver where there is no ice
C     SEAICE_clipVelocities :: clip velocities to +/- 40cm/s
C     SEAICEaddSnowMass :: in computing seaiceMass, add snow contribution
C                          default is .TRUE.
C     useHB87stressCoupling :: use an intergral over ice and ocean surface
C                          layer to define surface stresses on ocean
C                          following Hibler and Bryan (1987, JPO)
C     SEAICEupdateOceanStress :: If TRUE, update ocean surface stress
C                                accounting for seaice cover (default= T)
C     SEAICEuseBDF2     :: use 2nd-order backward difference approach
C                          for momentum equations as described in
C                          Lemieux et al. 2014, JCP
C                          so far only implemented for JFNK-solver
C     useHibler79IceStrength :: if true original ice strength parameterization
C                          other use Rothrock (1975) parameterization based
C                          on energetics and an ice thickness distribution
C                          (default = .true.)
C     SEAICEscaleSurfStress :: if TRUE, scale ice-ocean and ice-atmosphere
C                          stress on ice by concenration (AREA) following
C                          Connolley et al. (2004), JPO. (default = .TRUE.)
C     SEAICEsimpleRidging :: use Hibler(1979) ridging (default=.true.)
C     SEAICEuseLinRemapITD :: use linear remapping (Lipscomb et al. 2001)
C                             .TRUE. by default
C - advection:
C     SEAICEuseFluxForm :: use flux form for advection and diffusion
C                          of seaice
C     SEAICEadvHeff     :: turn on advection of effective thickness
C                          (default = .true.)
C     SEAICEadvArea     :: turn on advection of fraction area
C                          (default = .true.)
C     SEAICEadvSnow     :: turn on advection of snow (does not work with
C                          non-default Leap-frog scheme for advection)
C     SEAICEadvSalt     :: turn on advection of salt (does not work with
C                          non-default Leap-frog scheme for advection)
C     SEAICEmultiDimAdvection:: internal flag, set to false if any sea ice
C                          variable uses a non-multi-dimensional advection
C                          scheme
C     SEAICEmomAdvection:: turn on advection of momentum (default = .false.)
C     SEAICEhighOrderVorticity :: momentum advection parameters analogous to
C     SEAICEupwindVorticity    :: highOrderVorticity, upwindVorticity,
C     SEAICEuseAbsVorticity    :: useAbsVorticity, useJamartMomAdv for vector
C     SEAICEuseJamartMomAdv    :: invariant momentum in the ocean
C - thermodynamics:
C     usePW79thermodynamics :: use "0-layer" thermodynamics as described in
C                           Parkinson and Washington (1979) and Hibler (1979)
C     SEAICE_useMultDimSnow :: use same fixed pdf for snow as for
C                              multi-thickness-category ice (default=.TRUE.)
C     SEAICEuseFlooding  :: turn on scheme to convert submerged snow into ice
C     SEAICEheatConsFix  :: If true then fix ocn<->seaice advective heat flux.
C     useMaykutSatVapPoly :: use Maykut Polynomial for saturation vapor pressure
C                         instead of extended temp-range exponential law; def=F.
C     SEAICE_mcPheeStepFunc :: use step function (not linear tapering) in
C                           ocean-ice turbulent flux
C     SEAICE_doOpenWaterGrowth :: use open water heat flux directly to grow ice
C                           (when false cool ocean, and grow later if needed)
C     SEAICE_doOpenWaterMelt   :: use open water heat flux directly to melt ice
C                           (when false warm ocean, and melt later if needed)
C     SEAICE_growMeltByConv :: grow/melt according to convergence of turbulence
C                              and conduction, rather than in two steps (default)
C     SEAICE_salinityTracer    :: use SItracer to exchange and trace ocean
C                           salt in ice
C     SEAICE_ageTracer         :: use SItracer to trace the age of ice
C     SEAICErestoreUnderIce :: restore surface T/S also underneath ice
C                          ( default is false )
C - other (I/O, ...):
C     SEAICEwriteState  :: If true, write sea ice state to file;
C                          default is false.
C     SEAICE_tave_mdsio :: write TimeAverage output using MDSIO
C     SEAICE_dump_mdsio :: write snap-shot output   using MDSIO
C     SEAICE_mon_stdio  :: write monitor to std-outp
C     SEAICE_tave_mnc   :: write TimeAverage output using MNC
C     SEAICE_dump_mnc   :: write snap-shot output   using MNC
C     SEAICE_mon_mnc    :: write monitor to netcdf file
      LOGICAL
     &     SEAICEuseDYNAMICS, SEAICEuseFREEDRIFT, SEAICEuseStrImpCpl,
     &     SEAICEuseEVP, SEAICEuseEVPstar, SEAICEuseEVPrev,
     &     SEAICEuseEVPpickup,
     &     SEAICEuseMultiTileSolver,
     &     SEAICEuseLSR, SEAICEuseKrylov,
     &     SEAICEuseJFNK, SEAICEuseIMEX, SEAICEuseBDF2,SEAICEuseMEB,
     &     SEAICEupdateDamage,
     &     SEAICEusePicardAsPrecon,
     &     useHibler79IceStrength, SEAICEsimpleRidging,
     &     SEAICEuseLinRemapITD, SEAICEuseTD, SEAICEusePL,
     &     SEAICEuseTEM, SEAICEuseTilt, SEAICEuseMetricTerms,
     &     SEAICEuseMCS, SEAICEuseMCE,
     &     SEAICE_no_slip, SEAICE_2ndOrderBC,
     &     SEAICE_maskRHS, SEAICEscaleSurfStress,
     &     SEAICE_clipVelocities, SEAICEaddSnowMass,
     &     useHB87stressCoupling, SEAICEupdateOceanStress,
     &     SEAICEuseFluxForm, SEAICEadvHeff, SEAICEadvArea,
     &     SEAICEmultiDimAdvection,
     &     SEAICEadvSnow, SEAICEadvSalt, SEAICEmomAdvection,
     &     SEAICEhighOrderVorticity, SEAICEupwindVorticity,
     &     SEAICEuseAbsVorticity, SEAICEuseJamartMomAdv,
     &     usePW79thermodynamics,
     &     SEAICE_useMultDimSnow, SEAICEuseFlooding, SEAICEheatConsFix,
     &     useMaykutSatVapPoly, SEAICE_mcPheeStepFunc,
     &     SEAICE_doOpenWaterGrowth, SEAICE_doOpenWaterMelt,
     &     SEAICE_salinityTracer, SEAICE_ageTracer,
     &     SEAICErestoreUnderIce, SEAICE_growMeltByConv,
     &     SEAICEwriteState,
     &     SEAICE_tave_mdsio, SEAICE_dump_mdsio, SEAICE_mon_stdio,
     &     SEAICE_tave_mnc,   SEAICE_dump_mnc,   SEAICE_mon_mnc
      COMMON /SEAICE_PARM_L/
     &     SEAICEuseDYNAMICS, SEAICEuseFREEDRIFT, SEAICEuseStrImpCpl,
     &     SEAICEuseEVP, SEAICEuseEVPstar, SEAICEuseEVPrev,
     &     SEAICEuseEVPpickup,
     &     SEAICEuseMultiTileSolver,
     &     SEAICEuseLSR, SEAICEuseKrylov,
     &     SEAICEuseJFNK, SEAICEuseIMEX, SEAICEuseBDF2, SEAICEuseMEB,
     &     SEAICEupdateDamage,
     &     SEAICEusePicardAsPrecon,
     &     useHibler79IceStrength, SEAICEsimpleRidging,
     &     SEAICEuseLinRemapITD, SEAICEuseTD, SEAICEusePL,
     &     SEAICEuseTEM, SEAICEuseTilt, SEAICEuseMetricTerms,
     &     SEAICEuseMCS, SEAICEuseMCE,
     &     SEAICE_no_slip, SEAICE_2ndOrderBC,
     &     SEAICE_maskRHS, SEAICEscaleSurfStress,
     &     SEAICE_clipVelocities, SEAICEaddSnowMass,
     &     useHB87stressCoupling, SEAICEupdateOceanStress,
     &     SEAICEuseFluxForm, SEAICEadvHeff, SEAICEadvArea,
     &     SEAICEadvSnow, SEAICEadvSalt, SEAICEmomAdvection,
     &     SEAICEmultiDimAdvection,
     &     SEAICEhighOrderVorticity, SEAICEupwindVorticity,
     &     SEAICEuseAbsVorticity, SEAICEuseJamartMomAdv,
     &     usePW79thermodynamics,
     &     SEAICE_useMultDimSnow, SEAICEuseFlooding, SEAICEheatConsFix,
     &     useMaykutSatVapPoly, SEAICE_mcPheeStepFunc,
     &     SEAICE_doOpenWaterGrowth, SEAICE_doOpenWaterMelt,
     &     SEAICE_salinityTracer, SEAICE_ageTracer,
     &     SEAICErestoreUnderIce, SEAICE_growMeltByConv,
     &     SEAICEwriteState,
     &     SEAICE_tave_mdsio, SEAICE_dump_mdsio, SEAICE_mon_stdio,
     &     SEAICE_tave_mnc,   SEAICE_dump_mnc,   SEAICE_mon_mnc

C--   COMMON /SEAICE_PARM_I/ Integer valued parameters of sea ice model.
C     IMAX_TICE         :: number of iterations for ice surface temp
C                          (default=10)
C     postSolvTempIter :: select flux calculation after surf. temp solver
C                         iteration
C                         0 = none, i.e., from last iter
C                         1 = use linearized approx (consistent with tsurf
C                             finding)
C                         2 = full non-lin form
C     SOLV_NCHECK         :: iteration interval for LSR-solver convergence test
C     SEAICEnonLinIterMax :: number of allowed non-linear solver iterations
C                            for implicit solvers (JFNK and Picard) (>= 2)
C     SEAICElinearIterMax :: number of allowed linear solver iterations for
C                            for implicit solvers (JFNK and Picard) C
C     SEAICEpreconNL_Iter :: number non-linear iterations in preconditioner
C     SEAICEpreconLinIter :: number linear iterations in preconditioner
C     SEAICEnEVPstarSteps :: number of evp*-steps
C     SEAICEmomStartBDF   :: number of previous u/vIce time levels available
C                          to start (or restart) BDF2 scheme.
C     SEAICE_JFNK_lsIter  :: number of Newton iterations after which the
C                            line search is started
C     SEAICE_JFNK_tolIter :: number of Newton iterations after which the
C                            the tolerance is relaxed again (default = 100)
C     SEAICE_OLx/y      :: overlaps for LSR-solver and for the
C                          LSR-preconditioner in JFNK and KRYLOV solver;
C                          for 0 < SEAICE_OLx/y 0 <= OLx/y-2 the LSR solver
C                          and preconditioner use a restricted additive
C                          Schwarz method (default = OLx/y-2).
C     LSR_mixIniGuess   :: control mixing of free-drift sol. into LSR initial
C                          guess
C                       :: =0 : nothing; =1 : no mix, but print free-drift
C                          resid.;
C                       :: =2,4 : mix with (1/local-residual)^2,4 factor
C     SEAICEpresPow0    :: HEFF exponent for ice strength below SEAICEpresH0
C     SEAICEpresPow1    :: HEFF exponent for ice strength above SEAICEpresH0
C     rigding parameters (only active when SEAICE_ITD is defined)
C     SEAICEpartFunc    :: =0 use Thorndyke et al (1975) participation function
C                       :: =1 use Lipscomb et al (2007) participation function
C     SEAICEredistFunc  :: =0 assume ridged ice is uniformly distributed
C                             (Hibler, 1980)
C                          =1 Following Lipscomb et al. (2007), ridged ice is
C                             distributed following an exponentially
C                             decaying function
C     SEAICEridgingIterMax :: maximum number of ridging iterations
C     end ridging parameters
C     SEAICEselectKEscheme   :: momentum advection parameters analogous
C     SEAICEselectVortScheme :: to selectKEscheme and selectVortScheme
C     SEAICEadvScheme   :: sets the advection scheme for thickness and area
C                          (default = 77)
C     SEAICEadvSchArea  :: sets the advection scheme for area
C     SEAICEadvSchHeff  :: sets the advection scheme for effective thickness
C                         (=volume), snow thickness, and salt if available
C     SEAICEadvSchSnow  :: sets the advection scheme for snow on sea-ice
C     SEAICEadvSchSalt  :: sets the advection scheme for sea ice salinity
C     SEAICEadvSchSnow  :: sets the advection scheme for snow on sea-ice
C     SEAICE_areaLossFormula :: selects formula for ice cover loss from melt
C                        :: 1=from all but only melt conributions by ATM and OCN
C                        :: 2=from net melt-growth>0 by ATM and OCN
C                        :: 3=from predicted melt by ATM
C     SEAICE_areaGainFormula :: selects formula for ice cover gain from open
C                               water growth
C                        :: 1=from growth by ATM
C                        :: 2=from predicted growth by ATM
C     SEAICEetaZmethod   :: determines how shear-viscosity eta is computed at
C                           Z-points
C                           0=simple averaging from C-points (default and old)
C                           3=weighted averaging of squares of strain rates
C                             (recommended for energy conservation)
C     SEAICE_multDim     :: number of ice categories
C     SEAICE_debugPointI :: I,J index for seaice-specific debuggin
C     SEAICE_debugPointJ
C
      INTEGER IMAX_TICE, postSolvTempIter
      INTEGER SOLV_NCHECK
      INTEGER SEAICEnonLinIterMax, SEAICElinearIterMax
      INTEGER SEAICEpreconLinIter, SEAICEpreconNL_Iter
      INTEGER LSR_mixIniGuess
      INTEGER SEAICEnEVPstarSteps
      INTEGER SEAICEmomStartBDF
      INTEGER SEAICE_JFNK_lsIter, SEAICE_JFNK_tolIter
      INTEGER SEAICE_OLx, SEAICE_OLy
      INTEGER SEAICEselectKEscheme, SEAICEselectVortScheme
      INTEGER SEAICEadvScheme
      INTEGER SEAICEadvSchArea
      INTEGER SEAICEadvSchHeff
      INTEGER SEAICEadvSchSnow
      INTEGER SEAICEadvSchSalt
      INTEGER SEAICEadjMODE
      INTEGER SEAICE_areaLossFormula
      INTEGER SEAICE_areaGainFormula
      INTEGER SEAICEetaZmethod
      INTEGER SEAICE_multDim
      INTEGER SEAICE_debugPointI
      INTEGER SEAICE_debugPointJ
      INTEGER SEAICEpresPow0, SEAICEpresPow1
      INTEGER SEAICEpartFunc, SEAICEredistFunc
      INTEGER SEAICEridgingIterMax
      COMMON /SEAICE_PARM_I/
     &     IMAX_TICE, postSolvTempIter, SOLV_NCHECK,
     &     SEAICEnonLinIterMax, SEAICElinearIterMax,
     &     SEAICEpreconLinIter, SEAICEpreconNL_Iter,
     &     LSR_mixIniGuess,
     &     SEAICEnEVPstarSteps,
     &     SEAICEmomStartBDF,
     &     SEAICE_JFNK_lsIter, SEAICE_OLx, SEAICE_OLy,
     &     SEAICE_JFNK_tolIter,
     &     SEAICEpresPow0, SEAICEpresPow1,
     &     SEAICEpartFunc, SEAICEredistFunc, SEAICEridgingIterMax,
     &     SEAICEselectKEscheme, SEAICEselectVortScheme,
     &     SEAICEadvScheme,
     &     SEAICEadvSchArea,
     &     SEAICEadvSchHeff,
     &     SEAICEadvSchSnow,
     &     SEAICEadvSchSalt,
     &     SEAICEadjMODE,
     &     SEAICE_areaLossFormula,
     &     SEAICE_areaGainFormula,
     &     SEAICE_multDim,
     &     SEAICEetaZmethod,
     &     SEAICE_debugPointI,
     &     SEAICE_debugPointJ

C--   COMMON /SEAICE_PARM_C/ Character valued sea ice model parameters.
C     AreaFile          :: File containing initial sea-ice concentration
C     HsnowFile         :: File containing initial snow thickness
C     HsaltFile         :: File containing initial sea ice salt content
C     HeffFile          :: File containing initial sea-ice thickness
C     uIceFile          :: File containing initial sea-ice U comp. velocity
C     vIceFile          :: File containing initial sea-ice V comp. velocity
C        !!! NOTE !!! Initial sea-ice thickness can also be set using
C        SEAICE_initialHEFF below.  But a constant initial condition
C        can mean large artificial fluxes of heat and freshwater in
C        the surface layer during the first model time step.
C
      CHARACTER*(MAX_LEN_FNAM) AreaFile
      CHARACTER*(MAX_LEN_FNAM) HsnowFile
      CHARACTER*(MAX_LEN_FNAM) HsaltFile
      CHARACTER*(MAX_LEN_FNAM) HeffFile
      CHARACTER*(MAX_LEN_FNAM) uIceFile
      CHARACTER*(MAX_LEN_FNAM) vIceFile
      COMMON /SEAICE_PARM_C/
     &   AreaFile, HsnowFile, HsaltFile, HeffFile,
     &   uIceFile, vIceFile

C--   COMMON /SEAICE_PARM_RL/ Real valued parameters of sea ice model.
C     SEAICE_deltaTtherm :: Seaice timestep for thermodynamic equations (s)
C     SEAICE_deltaTdyn   :: Seaice timestep for dynamic solver          (s)
C     SEAICE_LSRrelaxU/V :: relaxation parameter for LSR-solver: U/V-component
C     SEAICE_deltaTevp   :: Seaice timestep for EVP solver              (s)
C     SEAICE_elasticParm :: parameter that sets relaxation timescale
C                           tau = SEAICE_elasticParm * SEAICE_deltaTdyn
C     SEAICE_evpTauRelax :: relaxation timescale tau                    (s)
C     SEAICE_evpDampC    :: evp damping constant (Hunke,JCP,2001)       (kg/m^2)
C     SEAICE_evpAlpha    :: dimensionless parameter 2*evpTauRelax/deltaTevp
C     SEAICE_evpBeta     :: dimensionless parameter deltaTdyn/deltaTevp
C     SEAICEaEVPcoeff    :: main coefficent for adaptive EVP (largest
C                           stabilized frequency)
C     SEAICEaEVPcStar    :: multiple of stabilty factor: alpha*beta=cstar*gamma
C     SEAICEaEVPalphaMin :: lower limit of alpha and beta, regularisation
C                           to prevent singularities of system matrix,
C                           e.g. when ice concentration is too low.
C     SEAICEnonLinTol    :: non-linear tolerance parameter for implicit solvers
C     JFNKgamma_lin_min/max :: tolerance parameters for linear JFNK solver
C     JFNKres_t          :: tolerance parameter for FGMRES residual
C     JFNKres_tFac       :: if set, JFNKres_t=JFNKres_tFac*(initial residual)
C     SEAICE_JFNKepsilon :: step size for the FD-gradient in s/r seaice_jacvec
C     SEAICE_JFNKphi     :: [0,1] parameter for inexact Newton Method (def = 1)
C     SEAICE_JFNKalpha   :: (1,2] parameter for inexact Newton Method (def = 1)
C     SEAICE_zetaMaxFac  :: factor determining the maximum viscosity    (s)
C                          (default = 5.e+12/2.e4 = 2.5e8)
C     SEAICE_zetaMin     :: lower bound for viscosity (default = 0)    (N s/m^2)
C     SEAICEpresH0       :: HEFF threshold for ice strength            (m)
C     SEAICE_monFreq     :: SEAICE monitor frequency.                   (s)
C     SEAICE_dumpFreq    :: SEAICE dump frequency.                      (s)
C     SEAICE_taveFreq    :: SEAICE time-averaging frequency.            (s)
C     SEAICE_initialHEFF :: initial sea-ice thickness                   (m)
C     SEAICE_rhoAir      :: density of air                              (kg/m^3)
C     SEAICE_rhoIce      :: density of sea ice                          (kg/m^3)
C     SEAICE_rhoSnow     :: density of snow                             (kg/m^3)
C     ICE2WATR           :: ratio of sea ice density to water density
C     SEAICE_cpAir       :: specific heat of air                        (J/kg/K)
C
C     SEAICEpoissonRatio :: Maxwell-Elasto-Brittle parameter (0.3)
C     SEAICEdamageMin    :: lower cut off for regularization (1e-16)
C     SEAICEviscosity    :: SEAICE_strength * 1e7
C     SEAICEcohesion     :: constant cohesion parameter: 25 kN/m^2
C     SEAICEdamageParm   :: parameter alpha that determines ratio of damaged
C                           elasticity modululs undamaged appararent viscosity
C                           > 1 (default = 4.0)
C     SEAICEintFrictCoeff:: used to compute Mohr-Coulomb slope in principle
C                           stress space (default = 0.7)
C     SEAICEmohrCoulombSlope :: slope in stress invariant space,
C                           e.g. cos(45) = 1/sqrt(2)
C     SEAICEhealingTime  :: 1.D5
C     SEAICEdamageTime   :: 2.D0
C
C     OCEAN_drag         :: unitless air-ocean drag coefficient (default 0.001)
C     SEAICE_drag        :: unitless air-ice drag coefficient   (default 0.001)
C     SEAICE_waterDrag   :: unitless water-ice drag coefficient (default 0.0055)
C     SEAICEdWatMin      :: minimum linear water-ice drag applied to DWATN
C                           (default 0.25 m/s)
C
C     SEAICE_dryIceAlb   :: winter albedo
C     SEAICE_wetIceAlb   :: summer albedo
C     SEAICE_drySnowAlb  :: dry snow albedo
C     SEAICE_wetSnowAlb  :: wet snow albedo
C     HO                 :: AKA "lead closing parameter", demarcation thickness
C                           between thin and thick ice. Alternatively, HO (in
C                           meters) can be interpreted as the thickness of ice
C                           formed in open water.
C                           HO is a key ice-growth parameter that determines
C                           the partition between vertical and lateral growth.
C                           The default is 0.5m, increasing this value leads
C                           slower formation of a closed ice cover and thus to
C                           more ice (and thicker) ice, decreasing to faster
C                           formation of a closed ice cover (leads are closing
C                           faster) and thus less (thinner) ice.
C
C     SEAICE_drag_south       :: Southern Ocean SEAICE_drag
C     SEAICE_waterDrag_south  :: Southern Ocean SEAICE_waterDrag
C     SEAICE_dryIceAlb_south  :: Southern Ocean SEAICE_dryIceAlb
C     SEAICE_wetIceAlb_south  :: Southern Ocean SEAICE_wetIceAlb
C     SEAICE_drySnowAlb_south :: Southern Ocean SEAICE_drySnowAlb
C     SEAICE_wetSnowAlb_south :: Southern Ocean SEAICE_wetSnowAlb
C     HO_south                :: Southern Ocean HO
C
C     Parameters for basal drag of grounded ice following
C     Lemieux et al. (2015), doi:10.1002/2014JC010678
C     SEAICE_cBasalStar (default = SEAICE_cStar)
C     SEAICEbasalDragU0 (default = 5e-5)
C     SEAICEbasalDragK1 (default = 8)
C     SEAICEbasalDragK2  :: if > 0, turns on basal drag
C                           (default = 0, Lemieux suggests 15)
C
C     SEAICE_wetAlbTemp  :: Temp (deg.C) above which wet-albedo values are used
C     SEAICE_waterAlbedo :: water albedo
C     SEAICE_strength    :: sea-ice strength Pstar
C     SEAICE_cStar       :: sea-ice strength paramter C* (def: 20)
C     SEAICE_tensilFac   :: sea-ice tensile strength factor, values in [0,1]
C     SEAICE_tensilDepth :: crtical depth for sea-ice tensile strength (def 0.)
C     SEAICEpressReplFac :: interpolator between PRESS0 and regularized PRESS
C                           1. (default): pure pressure replace method (PRESS)
C                           0.          : pure Hibler (1979) method (PRESS0)
C     SEAICE_eccen       :: sea-ice eccentricity of the elliptical yield curve
C     SEAICE_eccfr       :: sea-ice eccentricity of the elliptical flow rule
C     SEAICE_lhFusion    :: latent heat of fusion for ice and snow (J/kg)
C     SEAICE_lhEvap      :: latent heat of evaporation for water (J/kg)
C     SEAICE_dalton      :: Dalton number (= sensible heat transfer coefficient)
C     SEAICE_iceConduct  :: sea-ice conductivity
C     SEAICE_snowConduct :: snow conductivity
C     SEAICE_emissivity  :: longwave ocean-surface emissivity (-)
C     SEAICE_ice_emiss   :: longwave ice-surface emissivity (-)
C     SEAICE_snow_emiss  :: longwave snow-surface emissivity (-)
C     SEAICE_boltzmann   :: Stefan-Boltzman constant (not a run time parameter)
C     SEAICE_snowThick   :: cutoff snow thickness (for snow-albedo)
C     SEAICE_shortwave   :: ice penetration shortwave radiation factor
C     SEAICE_saltFrac    :: salinity of newly formed seaice defined as a
C                           fraction of the ocean surface salinity at the time
C                           of freezing
C     SEAICE_salt0       :: prescribed salinity of seaice (in g/kg).
C     facOpenGrow        :: 0./1. version of logical SEAICE_doOpenWaterGrowth
C     facOpenMelt        :: 0./1. version of logical SEAICE_doOpenWaterMelt
C     SEAICE_mcPheePiston:: ocean-ice turbulent flux "piston velocity" (m/s)
C                           that sets melt efficiency.
C     SEAICE_mcPheeTaper :: tapering down of turbulent flux term with ice
C                           concentration. The 100% cover turb. flux is
C                           multiplied by 1.-SEAICE_mcPheeTaper
C     SEAICE_frazilFrac  :: Fraction of surface level negative heat content
C                           anomalies (relative to the local freezing point)
C                           may contribute as frazil over one time step.
C     SEAICE_tempFrz0    :: sea water freezing point is
C     SEAICE_dTempFrz_dS :: tempFrz = SEAICE_tempFrz0 + salt*SEAICE_dTempFrz_dS
C     SEAICE_PDF         :: prescribed sea-ice distribution within grid box
C     SEAICEstressFactor :: factor by which ice affects wind stress (default=1)
C     LSR_ERROR          :: sets accuracy of LSR solver
C     DIFF1              :: parameter used in advect.F
C     SEAICEtdMU         :: slope parameter for the teardrop and parabolic lens
C                           yield curves
C     SEAICE_deltaMin    :: small number used to reduce singularities of Delta
C     SEAICE_area_max    :: usually set to 1. Seeting areaMax below 1 specifies
C                           the minimun amount of leads (1-areaMax) in the
C                           ice pack.
C     SEAICE_area_floor  :: usually set to 1x10^-5. Specifies a minimun
C                           ice fraction in the ice pack.
C     SEAICE_area_reg    :: usually set to 1x10^-5. Specifies a minimun
C                           ice fraction for the purposes of regularization
C     SEAICE_hice_reg    :: usually set to 5 cm. Specifies a minimun
C                           ice thickness for the purposes of regularization
C     SEAICEdiffKhArea   :: sets the diffusivity for area (m^2/s)
C     SEAICEdiffKhHeff   :: sets the diffusivity for effective thickness (m^2/s)
C     SEAICEdiffKhSnow   :: sets the diffusivity for snow on sea-ice (m^2/s)
C     SEAICEdiffKhSalt   :: sets the diffusivity for sea ice salinity (m^2/s)
C     SEAICE_airTurnAngle   :: turning angles of air-ice interfacial stress
C     SEAICE_waterTurnAngle :: and ice-water interfacial stress (in degrees)
C     SEAICE_tauAreaObsRelax :: Timescale of relaxation to observed
C                               sea ice concentration (s), default=unset
C     ridging parameters (Lipscomb et al, 2007, Bitz et al. 2001):
C     SEAICE_cf       :: ratio of total energy sinks to gravitational sink
C                        (scales ice strength, suggested values: 2 to 17)
C     SEAICEgStar     :: maximum ice concentration that participates in ridging
C     SEAICEhStar     :: empirical thickness (ridging parameter)
C     SEAICEaStar     :: ice concentration parameter similar to gStar for
C                        exponential distribution (Lipscomb et al 2007)
C     SEAICEshearParm :: <=1 reduces amount of energy lost to ridge building
C     SEAICEmuRidging :: tuning parameter similar to hStar for Lipcomb et al
C                        (2007)-scheme
C     SEAICEmaxRaft   :: regularization parameter (default=1)
C     SEAICEsnowFracRidge :: fraction of snow that remains on ridged
C     SINegFac        :: SIADV over/undershoot factor in FW/Adjoint
C     SEAICEmcMu      :: parameter for MC yield curve for useMCE, useMCS and
C                        useTEM options, default is one
C
      Real*8 SEAICE_deltaTtherm, SEAICE_deltaTdyn, SEAICE_deltaTevp
      Real*8 SEAICE_LSRrelaxU, SEAICE_LSRrelaxV
      Real*8 SEAICE_monFreq, SEAICE_dumpFreq, SEAICE_taveFreq
      Real*8 SEAICE_initialHEFF
      Real*8 SEAICE_rhoAir, SEAICE_rhoIce, SEAICE_rhoSnow, ICE2WATR
      Real*8 SEAICE_cpAir
      Real*8 SEAICE_drag, SEAICE_waterDrag, SEAICEdWatMin
      Real*8 SEAICE_dryIceAlb, SEAICE_wetIceAlb
      Real*8 SEAICE_drySnowAlb, SEAICE_wetSnowAlb, HO
      Real*8 SEAICE_drag_south, SEAICE_waterDrag_south
      Real*8 SEAICE_dryIceAlb_south, SEAICE_wetIceAlb_south
      Real*8 SEAICE_drySnowAlb_south, SEAICE_wetSnowAlb_south, HO_south
      Real*8 SEAICE_cBasalStar, SEAICEbasalDragU0
      Real*8 SEAICEbasalDragK1, SEAICEbasalDragK2
      Real*8 SEAICE_wetAlbTemp, SEAICE_waterAlbedo
      Real*8 SEAICE_strength, SEAICE_cStar, SEAICEpressReplFac
      Real*8 SEAICE_tensilFac, SEAICE_tensilDepth
      Real*8 SEAICE_eccen, SEAICE_eccfr
      Real*8 SEAICEmcMu, SEAICEtdMU
      Real*8 SEAICE_lhFusion, SEAICE_lhEvap
      Real*8 SEAICE_dalton
      Real*8 SEAICE_iceConduct, SEAICE_snowConduct
      Real*8 SEAICE_emissivity, SEAICE_ice_emiss, SEAICE_snow_emiss
      Real*8 SEAICE_boltzmann
      Real*8 SEAICE_snowThick, SEAICE_shortwave
      Real*8 SEAICE_saltFrac, SEAICE_salt0, SEAICEstressFactor
      Real*8 SEAICE_mcPheeTaper, SEAICE_mcPheePiston
      Real*8 SEAICE_frazilFrac, SEAICE_availHeatFrac
      Real*8 facOpenGrow, facOpenMelt
      Real*8 SEAICE_tempFrz0, SEAICE_dTempFrz_dS
      Real*8 SEAICE_PDF(nITD)
      Real*8 OCEAN_drag, LSR_ERROR, DIFF1
      Real*8 SEAICEnonLinTol, JFNKres_t, JFNKres_tFac
      Real*8 JFNKgamma_lin_min, JFNKgamma_lin_max, SEAICE_JFNKepsilon
      Real*8 SEAICE_JFNKphi, SEAICE_JFNKalpha
      Real*8 SEAICE_deltaMin
      Real*8 SEAICE_area_reg, SEAICE_hice_reg
      Real*8 SEAICE_area_floor, SEAICE_area_max
      Real*8 SEAICE_airTurnAngle, SEAICE_waterTurnAngle
      Real*8 SEAICE_elasticParm, SEAICE_evpTauRelax
      Real*8 SEAICE_evpAlpha, SEAICE_evpBeta
      Real*8 SEAICE_evpDampC, SEAICE_zetaMin, SEAICE_zetaMaxFac
      Real*8 SEAICEaEVPcoeff, SEAICEaEVPcStar, SEAICEaEVPalphaMin
      Real*8 SEAICEpresH0
      Real*8 SEAICEdiffKhArea, SEAICEdiffKhHeff, SEAICEdiffKhSnow
      Real*8 SEAICEdiffKhSalt
      Real*8 SEAICE_tauAreaObsRelax
      Real*8 SEAICEgStar, SEAICEhStar, SEAICEaStar, SEAICEshearParm
      Real*8 SEAICEmuRidging, SEAICEmaxRaft, SEAICE_cf
      Real*8 SEAICEsnowFracRidge
      Real*8 SINegFac
      Real*8 SEAICEpoissonRatio, SEAICEviscosity, SEAICEcohesion
      Real*8 SEAICEdamageMin, SEAICEdamageParm
      Real*8 SEAICEintFrictCoeff, SEAICEmohrCoulombSlope
      Real*8 SEAICEhealingTime, SEAICEdamageTime

      COMMON /SEAICE_PARM_RL/
     &    SEAICE_deltaTtherm, SEAICE_deltaTdyn,
     &    SEAICE_LSRrelaxU, SEAICE_LSRrelaxV,
     &    SEAICE_deltaTevp, SEAICE_elasticParm, SEAICE_evpTauRelax,
     &    SEAICE_evpAlpha, SEAICE_evpBeta,
     &    SEAICEaEVPcoeff, SEAICEaEVPcStar, SEAICEaEVPalphaMin,
     &    SEAICE_evpDampC, SEAICE_zetaMin, SEAICE_zetaMaxFac,
     &    SEAICEpresH0,
     &    SEAICE_monFreq, SEAICE_dumpFreq, SEAICE_taveFreq,
     &    SEAICE_initialHEFF,
     &    SEAICE_rhoAir, SEAICE_rhoIce, SEAICE_rhoSnow, ICE2WATR,
     &    SEAICE_drag, SEAICE_waterDrag, SEAICEdWatMin,
     &    SEAICE_dryIceAlb, SEAICE_wetIceAlb,
     &    SEAICE_drySnowAlb, SEAICE_wetSnowAlb, HO,
     &    SEAICE_drag_south, SEAICE_waterDrag_south,
     &    SEAICE_dryIceAlb_south, SEAICE_wetIceAlb_south,
     &    SEAICE_drySnowAlb_south, SEAICE_wetSnowAlb_south, HO_south,
     &    SEAICE_cBasalStar, SEAICEbasalDragU0,
     &    SEAICEbasalDragK1, SEAICEbasalDragK2,
     &    SEAICE_wetAlbTemp, SEAICE_waterAlbedo,
     &    SEAICE_strength, SEAICE_cStar, SEAICE_eccen, SEAICE_eccfr,
     &    SEAICEtdMU, SEAICEmcMu,
     &    SEAICEpressReplFac, SEAICE_tensilFac, SEAICE_tensilDepth,
     &    SEAICE_lhFusion, SEAICE_lhEvap,
     &    SEAICE_dalton, SEAICE_cpAir,
     &    SEAICE_iceConduct, SEAICE_snowConduct,
     &    SEAICE_emissivity, SEAICE_ice_emiss, SEAICE_snow_emiss,
     &    SEAICE_boltzmann,
     &    SEAICE_snowThick, SEAICE_shortwave,
     &    SEAICE_saltFrac, SEAICE_salt0, SEAICEstressFactor,
     &    SEAICE_mcPheeTaper, SEAICE_mcPheePiston,
     &    SEAICE_frazilFrac, SEAICE_availHeatFrac,
     &    facOpenGrow, facOpenMelt,
     &    SEAICE_tempFrz0, SEAICE_dTempFrz_dS, SEAICE_PDF,
     &    OCEAN_drag, LSR_ERROR, DIFF1,
     &    SEAICEnonLinTol, JFNKres_t, JFNKres_tFac,
     &    JFNKgamma_lin_min, JFNKgamma_lin_max, SEAICE_JFNKepsilon,
     &    SEAICE_JFNKphi, SEAICE_JFNKalpha,
     &    SEAICE_deltaMin, SEAICE_area_reg, SEAICE_hice_reg,
     &    SEAICE_area_floor, SEAICE_area_max,
     &    SEAICEdiffKhArea, SEAICEdiffKhHeff, SEAICEdiffKhSnow,
     &    SEAICEdiffKhSalt, SEAICE_tauAreaObsRelax,
     &    SEAICE_airTurnAngle, SEAICE_waterTurnAngle,
     &    SEAICEgStar, SEAICEhStar, SEAICEaStar, SEAICEshearParm,
     &    SEAICEmuRidging, SEAICEmaxRaft, SEAICE_cf,
     &    SINegFac,
     &    SEAICEsnowFracRidge,
     &    SEAICEpoissonRatio, SEAICEviscosity, SEAICEcohesion,
     &    SEAICEdamageMin, SEAICEdamageParm,
     &    SEAICEintFrictCoeff, SEAICEmohrCoulombSlope,
     &    SEAICEhealingTime, SEAICEdamageTime

C--   COMMON /SEAICE_BOUND_RL/ Various bounding values
C     MIN_ATEMP         :: minimum air temperature   (deg C)
C     MIN_LWDOWN        :: minimum downward longwave (W/m^2)
C     MIN_TICE          :: minimum ice temperature   (deg C)
C     SEAICE_EPS        :: small number
C     SEAICE_EPS_SQ     :: small number square
C
      Real*8 MIN_ATEMP, MIN_LWDOWN, MIN_TICE
      Real*8 SEAICE_EPS, SEAICE_EPS_SQ
      COMMON /SEAICE_BOUND_RL/
     &     MIN_ATEMP, MIN_LWDOWN, MIN_TICE,
     &     SEAICE_EPS, SEAICE_EPS_SQ


C--   Constants used by sea-ice model
      Real*8         ZERO           , ONE           , TWO
      PARAMETER ( ZERO = 0.0D0, ONE = 1.0D0, TWO = 2.0D0 )
      Real*8         QUART            , HALF
      PARAMETER ( QUART = 0.25D0, HALF = 0.5D0 )
      Real*8 siEps
      PARAMETER ( siEps = 1.D-5 )

C--   Constants needed by McPhee formulas for turbulent ocean fluxes :
C        Stanton number (dimensionless), typical friction velocity
C        beneath sea ice (m/s), and tapering factor (dimensionless)
      Real*8 STANTON_NUMBER, USTAR_BASE, MCPHEE_TAPER_FAC
      PARAMETER ( MCPHEE_TAPER_FAC = 12.5D0 , STANTON_NUMBER =
     &            0.0056D0, USTAR_BASE = 0.0125D0 )

C--   identifiers for advected properties
      INTEGER GAD_HEFF,GAD_AREA,GAD_QICE1,GAD_QICE2,GAD_SNOW
      INTEGER GAD_SALT,GAD_SITR
      PARAMETER ( GAD_HEFF  = 1,
     &            GAD_AREA  = 2,
     &            GAD_SNOW  = 3,
     &            GAD_SALT  = 4,
     &            GAD_QICE1 = 5,
     &            GAD_QICE2 = 6,
     &            GAD_SITR  = 7)

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
CBOP
C !ROUTINE: SEAICE_TRACER.h

C !DESCRIPTION: \bv
C     /==========================================================C     | SEAICE_TRACER.h                                          |
C     | o Begin header for sea ice tracers                       |
C     \==========================================================/
C
C \ev
CEOP


CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
C

CBOP
C     !ROUTINE: MNC_PARAMS.h
C     !INTERFACE:
C     #include MNC_PARAMS.h

C     !DESCRIPTION:
C     Header file defining model "parameters".  The values from the
C     model standard input file are stored into the variables held
C     here. Notes describing the parameters can also be found here.
CEOP

C     ===  PARM_MNC_C Common Block  ===
C     mnc_outdir_str   :: name of the output directory
C     mnc_indir_str    :: name of the input directory

      COMMON /PARM_MNC_C/
     &     mnc_outdir_str,
     &     mnc_indir_str
      CHARACTER*(MAX_LEN_FNAM) mnc_outdir_str
      CHARACTER*(MAX_LEN_FNAM) mnc_indir_str

C     ===  PARM_MNC_L Common Block  ===
C     mnc_use_indir    :: use "mnc_indir_str" as input filename prefix
C     mnc_use_outdir   :: use "mnc_outdir_str" as output filename prefix
C     mnc_outdir_date  :: use a date string within the output dir name
C     mnc_outdir_num   :: use a seq. number within the output dir name 
C     mnc_use_name_ni0 :: use nIter0 in all the file names
C     mnc_echo_gvtypes :: echo type names (fails on many platforms)
C     pickup_write_mnc :: use mnc to write pickups
C     pickup_read_mnc  :: use mnc to read  pickups
C     mon_write_mnc    :: use mnc to write monitor output
C     writegrid_mnc    :: use mnc to write model-grid arrays to file
C     readgrid_mnc     :: read INI_CURVILINEAR_GRID() info using mnc

      COMMON /PARM_MNC_L/ 
     &     mnc_use_indir, mnc_use_outdir, mnc_outdir_date,
     &     mnc_outdir_num, mnc_use_name_ni0, mnc_echo_gvtypes,
     &     pickup_write_mnc, pickup_read_mnc,
     &     timeave_mnc, snapshot_mnc, monitor_mnc, autodiff_mnc, 
     &     writegrid_mnc, readgrid_mnc,
     &     mnc_read_bathy, mnc_read_salt, mnc_read_theta
      LOGICAL 
     &     mnc_use_indir, mnc_use_outdir, mnc_outdir_date,
     &     mnc_outdir_num, mnc_use_name_ni0, mnc_echo_gvtypes,
     &     pickup_write_mnc, pickup_read_mnc,
     &     timeave_mnc, snapshot_mnc, monitor_mnc, autodiff_mnc, 
     &     writegrid_mnc, readgrid_mnc,
     &     mnc_read_bathy, mnc_read_salt, mnc_read_theta

C     ===  PARM_MNC_I Common Block  ===
C     mnc_curr_iter    :: current iter for file names

      COMMON /PARM_MNC_I/
     &     mnc_def_imv, mnc_curr_iter
      INTEGER mnc_def_imv(2)
      INTEGER mnc_curr_iter

C     ===  PARM_MNC_R8 Common Block  ===
C     mnc_max_fsize    :: maximum file size

      COMMON /PARM_MNC_R8/
     &     mnc_def_dmv,
     &     mnc_max_fsize, mnc_filefreq
      REAL*8  mnc_def_dmv(2)
      REAL*8  mnc_max_fsize
      REAL*8  mnc_filefreq

C     ===  PARM_MNC_R8 Common Block  ===
      COMMON /PARM_MNC_R4/
     &     mnc_def_rmv
      REAL*4  mnc_def_rmv(2)

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
c
c
c     ==================================================================
c     HEADER exf_constants
c     ==================================================================
c
c     o Header file for constants.
c       These include  - numbers (e.g. 1, 2, 1/2, ...)
c                      - physical constants (e.g. gravitational const.)
c                      - empirical parameters
c                      - control parameters (e.g. max. no of iteration)
c
c     started: Patrick Heimbach heimbach@mit.edu  06-May-2000
c     mods for pkg/seaice: menemenlis@jpl.nasa.gov 20-Dec-2002
c
c     ==================================================================
c     HEADER exf_constants
c     ==================================================================

c     1. numbers

c     exf_half   0.5
c     exf_one    1.0
c     exf_two    2.0

      Real*8 exf_half
      Real*8 exf_one
      Real*8 exf_two

      PARAMETER(
     &              exf_half =  0.5D0 ,
     &              exf_one  =  1.0D0 ,
     &              exf_two  =  2.0D0
     &         )

c     real       exf_undef
c     PARAMETER( exf_undef = -9000. )

c     2. physical constants

c     stefanBoltzmann :: Stefan-Boltzmann constant [J*K^-4*m^-2*s^-1]
c                        sigma = (2*pi^5*k^4)/(15*h^3*c^2)
c     karman          :: von Karman constant
      Real*8    stefanBoltzmann
      Real*8    karman
      PARAMETER ( stefanBoltzmann = 5.670D-8 )
      PARAMETER ( karman = 0.4D0 )

c     3. empirical parameters

c     To invert the relationship ustar = ustar(umagn) the following
c     parameterization is used:
c
c      ustar**2 = umagn**2 * CDN(umagn)
c
c                  / cquadrag_1 * umagn**2 + cquadrag_2; 0 < u < 11 m/s
c      CDN(umagn) =
c                  \ clindrag_1 * umagn + clindrag_2   ; u > 11 m/s
c
c      clindrag_[n] - n = 1, 2 coefficients used to evaluate
c                     LINEAR relationship of Large and Pond 1981
c      cquadrag_[n] - n = 1, 2 coefficients used to evaluate
c                     quadratic relationship
c      u11          - u = 11 m/s wind speed
c      ustofu11     - ustar = 0.3818 m/s, corresponding to u = 11 m/s

      Real*8 clindrag_1, clindrag_2
      Real*8 cquadrag_1, cquadrag_2
      Real*8 u11
      Real*8 ustofu11

      PARAMETER (
     &            ustofu11    =         0.381800D0 ,
     &            u11         =        11.D0 ,
     &            clindrag_1  =         0.000065D0 ,
     &            clindrag_2  =         0.000490D0 ,
     &            cquadrag_1  = clindrag_1/u11/2 ,
     &            cquadrag_2  = clindrag_1*u11/2 + clindrag_2
     &          )

c     4. control parameters

c     niter_bulk   - Number of iterations to be performed for the
c                    evaluation of the bulk surface fluxes. The ncom
c                    model uses 2 hardwired interation steps (loop
c                    unrolled).
c
      INTEGER     niter_bulk
      PARAMETER ( niter_bulk = 2 )

C     5. other constants or parameters

C     COMMON /EXF_PARAM_R_2/
C     cen2kel      :: conversion of deg. Centigrade to Kelvin
C     gravity_mks  :: gravitational acceleration [m/s^2]
C     atmrho       :: mean atmospheric density [kg/m^3]
C     atmcp        :: mean atmospheric specific heat [J/kg/K]
C     flamb        :: latent heat of evaporation [J/kg]
C     flami        :: latent heat of melting of pure ice [J/kg]
C     cvapor_[]    :: Coeff to calculate Saturation Specific Humidity
C                     see e.g. Gill (1982) p.41 Eq. (3.1.15)
C     humid_fac    :: constant entering the evaluation of the virtual
C                     temperature
C     gamma_blk    :: adiabatic lapse rate
C     saltsat      :: reduction of saturation vapor pressure over salt water
C     sstExtrapol  :: extrapolation coeff from 1rst 2 levels up to surface
C  snow_emissivity :: longwave  snow  emissivity [-] (with pkg thsice/seaice)
C-- to evaluate turbulent transfert coefficients:
C     cdrag_[n]    :: n = 1,2,3 coefficients used to evaluate
C                     drag coefficient
C     cstanton_[n] :: n = 1,2   coefficients used to evaluate
C                     the Stanton number (stable/unstable cond.)
C     cdalton      :: coefficient used to evaluate the Dalton number
C     zolmin       :: minimum stability parameter
C     psim_fac     :: coef used in turbulent fluxes calculation [-]
C     zref         :: reference height
C     hu           :: height of mean wind
C     ht           :: height of mean temperature
C     hq           :: height of mean rel. humidity
C     umin         :: minimum absolute wind speed used to evaluate
C                     drag coefficient [m/s]
C     exf_iceCd    :: drag coefficient over sea-ice (fixed)
C     exf_iceCe    :: transfert coeff. over sea-ice, for Evaporation (fixed)
C     exf_iceCh    :: transfert coeff. over sea-ice, for Sens.Heating (fixed)
C-- radiation:
C     exf_albedo   :: Sea-water albedo
C ocean_emissivity :: longwave ocean-surface emissivity [-]
C   ice_emissivity :: longwave seaice emissivity [-] (with pkg thsice/seaice)
C  snow_emissivity :: longwave  snow  emissivity [-] (with pkg thsice/seaice)

      Real*8    cen2kel
      Real*8    gravity_mks
      Real*8    atmrho
      Real*8    atmcp
      Real*8    flamb, flami
      Real*8    cvapor_fac,     cvapor_exp
      Real*8    cvapor_fac_ice, cvapor_exp_ice
      Real*8    humid_fac
      Real*8    gamma_blk
      Real*8    saltsat
      Real*8    sstExtrapol
      Real*8    cdrag_1,    cdrag_2,     cdrag_3
      Real*8    cstanton_1, cstanton_2
      Real*8    cdalton
      Real*8    zolmin
      Real*8    psim_fac
      Real*8    zref
      Real*8    hu
      Real*8    ht
      Real*8    hq
      Real*8    umin
      Real*8    exf_iceCd
      Real*8    exf_iceCe
      Real*8    exf_iceCh
      Real*8    exf_albedo
      Real*8    ocean_emissivity
      Real*8    ice_emissivity
      Real*8    snow_emissivity

      COMMON /EXF_PARAM_R_2/
     &       cen2kel,
     &       gravity_mks,
     &       atmrho,
     &       atmcp,
     &       flamb,
     &       flami,
     &       cvapor_fac,     cvapor_exp,
     &       cvapor_fac_ice, cvapor_exp_ice,
     &       humid_fac,
     &       gamma_blk,
     &       saltsat,
     &       sstExtrapol,
     &       cdrag_1,    cdrag_2,    cdrag_3,
     &       cstanton_1, cstanton_2,
     &       cdalton,
     &       zolmin,
     &       psim_fac,
     &       zref,
     &       hu,
     &       ht,
     &       hq,
     &       umin,
     &       exf_iceCd,  exf_iceCe,  exf_iceCh,
     &       exf_albedo,
     &       ocean_emissivity,
     &       ice_emissivity,
     &       snow_emissivity


C     !INPUT/OUTPUT PARAMETERS:
C     === Routine arguments ===
C     myThid     :: my Thread Id. number
      INTEGER myThid
CEOP

C     !LOCAL VARIABLES:
C     === Local variables ===
C     msgBuf     :: Informational/error message buffer
C     iUnit      :: Work variable for IO unit number
      CHARACTER*(MAX_LEN_MBUF) msgBuf
      LOGICAL chkFlag
      INTEGER iUnit
      INTEGER l
      INTEGER nRetired, nError
      Real*8 tmp

C     local runtime parameters that are only used in this routine
C     SEAICEelasticWaveSp :: parameter for undamaged elasticity modulus
C                            (500.D0)
      Real*8 SEAICEelasticWaveSp

C-    Old parameters (to be retired one day):
      Real*8 SEAICE_availHeatTaper
      Real*8 SEAICE_gamma_t, SEAICE_gamma_t_frz, SEAICE_availHeatFracFrz

C-    Retired parameters:
C     MAX_TICE          :: maximum ice temperature   (deg C)
C     LAD               :: time stepping used for sea-ice advection:
C                          1 = LEAPFROG,  2 = BACKWARD EULER.
C     SEAICE_freeze     :: FREEZING TEMP. OF SEA WATER
      Real*8 SEAICE_sensHeat, SEAICE_latentWater, SEAICE_latentIce
      Real*8 SEAICE_salinity, SIsalFRAC, SIsal0
      Real*8 SEAICE_lhSublim, SEAICE_freeze, MAX_HEFF
      Real*8 areaMin, areaMax, A22, hiceMin, MAX_TICE
      LOGICAL SEAICEadvAge
      INTEGER SEAICEadvSchAge, LAD, SEAICEturbFluxFormula
      INTEGER NPSEUDOTIMESTEPS, SOLV_MAX_ITERS
      INTEGER SEAICEnewtonIterMax, SEAICEkrylovIterMax
      Real*8 JFNKgamma_nonlin
      Real*8 SEAICEdiffKhAge
      CHARACTER*(MAX_LEN_MBUF) IceAgeFile, IceAgeTrFile(4)
      Real*8 SEAICE_abEps
      LOGICAL SEAICEuseAB2

C--   SEAICE parameters
      NAMELIST /SEAICE_PARM01/
     & SEAICEuseDYNAMICS, SEAICEuseFREEDRIFT, SEAICEuseStrImpCpl,
     & SEAICEuseMCS, SEAICEuseMCE, SEAICEuseTD, SEAICEusePL,
     & SEAICEuseTEM, SEAICEuseMetricTerms, SEAICEuseTilt,
     & useHB87stressCoupling, SEAICEupdateOceanStress,
     & usePW79thermodynamics, useMaykutSatVapPoly, SEAICEuseFlooding,
     & SEAICErestoreUnderIce, SEAICE_growMeltByConv,
     & SEAICE_salinityTracer, SEAICE_ageTracer,
     & SEAICEadvHeff, SEAICEadvArea, SEAICEadvSnow,
     & SEAICEadvSalt, SEAICEadvAge, SEAICEaddSnowMass,
     & SEAICEmomAdvection, SEAICEselectKEscheme, SEAICEselectVortScheme,
     & SEAICEhighOrderVorticity, SEAICEupwindVorticity,
     & SEAICEuseAbsVorticity, SEAICEuseJamartMomAdv,
     & SEAICE_clipVelocities, SEAICE_maskRHS,
     & SEAICE_no_slip, SEAICE_2ndOrderBC,
     & SEAICEetaZmethod, LAD, IMAX_TICE, postSolvTempIter,
     & SEAICEuseFluxForm, SEAICEadvScheme, SEAICEadvSchArea,
     & SEAICEadvSchHeff, SEAICEadvSchSnow,
     & SEAICEadvSchSalt, SEAICEadvSchAge,
     & SEAICEdiffKhHeff, SEAICEdiffKhSnow, SEAICEdiffKhArea,
     & SEAICEdiffKhSalt, SEAICEdiffKhAge, DIFF1,
     & SEAICE_deltaTtherm, SEAICE_deltaTdyn,
     & SEAICE_LSRrelaxU, SEAICE_LSRrelaxV,
     & SOLV_MAX_ITERS, SOLV_NCHECK, NPSEUDOTIMESTEPS,
     & LSR_ERROR, LSR_mixIniGuess, SEAICEuseMultiTileSolver,
     & SEAICE_deltaTevp, SEAICE_elasticParm, SEAICE_evpTauRelax,
     & SEAICE_evpDampC, SEAICEnEVPstarSteps,
     & SEAICE_evpAlpha, SEAICE_evpBeta,
     & SEAICEaEVPcoeff, SEAICEaEVPcStar, SEAICEaEVPalphaMin,
     & SEAICE_zetaMin, SEAICE_zetaMaxFac, SEAICEusePicardAsPrecon,
     & SEAICEuseKrylov, SEAICEuseJFNK, SEAICEuseMEB, SEAICEupdateDamage,
     & SEAICEnonLinIterMax, SEAICElinearIterMax, SEAICEnonLinTol,
     & SEAICEnewtonIterMax, SEAICEkrylovIterMax, JFNKgamma_nonlin,
     & SEAICEpreconNL_Iter, SEAICEpreconLinIter,
     & SEAICE_JFNK_lsIter, SEAICE_JFNK_tolIter, JFNKres_t,JFNKres_tFac,
     & JFNKgamma_lin_min,JFNKgamma_lin_max,
     & SEAICE_JFNKepsilon, SEAICE_OLx, SEAICE_OLy,
     & SEAICE_JFNKphi, SEAICE_JFNKalpha, SEAICEuseIMEX, SEAICEuseBDF2,
     & SEAICEuseLinRemapITD,
     & useHibler79IceStrength, SEAICEpartFunc, SEAICEredistFunc,
     & SEAICEridgingIterMax, SEAICEsimpleRidging, SEAICEsnowFracRidge,
     & SEAICEgStar, SEAICEhStar, SEAICEaStar, SEAICEshearParm,
     & SEAICEmuRidging, SEAICEmaxRaft, SEAICE_cf,
     & SEAICEuseAB2, SEAICE_abEps,
     & SEAICEpresH0, SEAICEpresPow0, SEAICEpresPow1,
     & SEAICE_initialHEFF, SEAICEturbFluxFormula,
     & SEAICE_areaGainFormula, SEAICE_areaLossFormula,
     & SEAICE_doOpenWaterGrowth, SEAICE_doOpenWaterMelt,
     & SEAICE_rhoAir, SEAICE_rhoIce, SEAICE_rhoSnow, ICE2WATR,
     & SEAICE_cpAir, SEAICEscaleSurfStress,
     & SEAICE_drag, SEAICE_waterDrag, SEAICEdWatMin, SEAICE_dryIceAlb,
     & SEAICE_wetIceAlb, SEAICE_drySnowAlb, SEAICE_wetSnowAlb, HO,
     & SEAICE_drag_south, SEAICE_waterDrag_south,
     & SEAICE_dryIceAlb_south, SEAICE_wetIceAlb_south,
     & SEAICE_drySnowAlb_south, SEAICE_wetSnowAlb_south, HO_south,
     & SEAICE_cBasalStar, SEAICEbasalDragU0, SEAICEbasalDragK1,
     & SEAICEbasalDragK2, SEAICE_wetAlbTemp, SEAICE_waterAlbedo,
     & SEAICE_strength, SEAICE_cStar, SEAICE_eccen,
     & SEAICE_eccfr, SEAICEtdMU, SEAICEmcMu,
     & SEAICEpressReplFac, SEAICE_tensilFac, SEAICE_tensilDepth,
     & SEAICEpoissonRatio, SEAICEviscosity, SEAICEcohesion,
     & SEAICEdamageMin, SEAICEdamageParm,
     & SEAICEintFrictCoeff, SEAICEmohrCoulombSlope,
     & SEAICEelasticWaveSp, SEAICEhealingTime, SEAICEdamageTime,
     & SEAICE_lhFusion, SEAICE_lhEvap, SEAICE_dalton,
     & SEAICE_sensHeat, SEAICE_latentWater, SEAICE_latentIce,
     & SEAICE_salinity, SIsalFRAC, SIsal0,
     & areaMin, areaMax, A22, hiceMin,
     & SEAICE_iceConduct, SEAICE_snowConduct,
     & SEAICE_emissivity, SEAICE_ice_emiss, SEAICE_snow_emiss,
     & SEAICE_snowThick, SEAICE_shortwave, SEAICE_freeze, OCEAN_drag,
     & SEAICE_tempFrz0, SEAICE_dTempFrz_dS, SEAICE_salt0,
     & SEAICE_saltFrac, SEAICEstressFactor, SEAICE_availHeatTaper,
     & SEAICE_mcPheePiston, SEAICE_frazilFrac, SEAICE_mcPheeTaper,
     & SEAICE_mcPheeStepFunc, SEAICE_gamma_t, SEAICE_gamma_t_frz,
     & SEAICE_availHeatFrac, SEAICE_availHeatFracFrz, SEAICE_PDF,
     & AreaFile, HeffFile, uIceFile, vIceFile, HsnowFile, HsaltFile,
     & SEAICEheatConsFix, SEAICE_multDim, SEAICE_useMultDimSnow,
     & SEAICE_deltaMin, SEAICE_area_reg, SEAICE_hice_reg,
     & SEAICE_area_floor, SEAICE_area_max, SEAICE_tauAreaObsRelax,
     & SEAICE_airTurnAngle, SEAICE_waterTurnAngle,
     & MAX_HEFF, MIN_ATEMP, MIN_LWDOWN, MAX_TICE, MIN_TICE,
     & SEAICE_EPS, SEAICE_EPS_SQ,
     & SEAICEwriteState, SEAICEuseEVPpickup,
     & SEAICEuseEVPstar, SEAICEuseEVPrev,
     & SEAICE_monFreq, SEAICE_dumpFreq, SEAICE_taveFreq,
     & SEAICE_tave_mnc, SEAICE_dump_mnc, SEAICE_mon_mnc,
     & SEAICE_debugPointI, SEAICE_debugPointJ,
     & SINegFac



C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

      IF ( .NOT.useSEAICE ) THEN
C-    pkg SEAICE is not used
        IF ( myThid .EQ. 1 ) THEN
C-    Track pkg activation status:
C     print a (weak) warning if data.seaice is found
         CALL PACKAGES_UNUSED_MSG( 'useSEAICE', ' ', ' ' )
        ENDIF
        RETURN
      ENDIF

      IF ( myThid .EQ. 1 ) THEN

C--   set default sea ice parameters
      SEAICEuseDYNAMICS  = .TRUE.
      SEAICEadjMODE      = 0
      SEAICEuseFREEDRIFT = .FALSE.
      SEAICEuseStrImpCpl = .FALSE.
      SEAICEuseTilt      = .TRUE.
      SEAICEheatConsFix  = .FALSE.
      SEAICEuseTEM       = .FALSE.
      SEAICEuseMCS       = .FALSE.
      SEAICEuseMCE       = .FALSE.
      SEAICEuseTD        = .FALSE.
      SEAICEusePL        = .FALSE.
      SEAICEuseMetricTerms = .TRUE.
      SEAICEuseEVPpickup = .TRUE.
      SEAICEuseEVPstar   = .TRUE.
      SEAICEuseEVPrev    = .TRUE.
      SEAICErestoreUnderIce = .FALSE.
      SEAICE_growMeltByConv = .FALSE.
      SEAICE_salinityTracer = .FALSE.
      SEAICE_ageTracer      = .FALSE.
      useHB87stressCoupling = .FALSE.
      SEAICEupdateOceanStress = .TRUE.
      SEAICEscaleSurfStress = .TRUE.
      SEAICEaddSnowMass     = .TRUE.
      usePW79thermodynamics = .TRUE.
C     start of ridging parameters
      useHibler79IceStrength= .TRUE.
      SEAICEsimpleRidging   = .TRUE.
C     The range of this proportionality constant is 2 to 17
      SEAICE_cf             = 17.D0
C     By default use partition function of Thorndyke et al. (1975) ...
      SEAICEpartFunc        = 0
C     and redistribution function of Hibler (1980)
      SEAICEredistFunc      = 0
      SEAICEridgingIterMax  = 10
C     This parameter is not well constraint (Lipscomb et al. 2007)
      SEAICEshearParm       = 0.5D0
C     Thorndyke et al. (1975)
      SEAICEgStar           = 0.15D0
C     suggested by Hibler (1980), Flato and Hibler (1995)
C     SEAICEhStar           = 100.D0
C     but this value of 25 seems to give thinner ridges in better agreement
C     with observations (according to Lipscomb et al 2007)
      SEAICEhStar           =  25.D0
C     according to Lipscomb et al. (2007) these values for aStar and mu
C     are approximately equivalent to gStar=0.15 (aStar = gStar/3) for
C     SEAICEpartFunc = 1 ...
      SEAICEaStar           = 0.05D0
C     ... and hStar=25 for SEAICEredistFunc = 1
C     Libscomb et al. (2007): mu =  3,  4,  5,   6
C     correspond to        hStar = 25, 50, 75, 100
      SEAICEmuRidging       = 3.D0
      SEAICEmaxRaft         = 1.D0
      SEAICEsnowFracRidge   = 0.5D0
      SEAICEuseLinRemapITD  = .TRUE.
C     end ridging parampeters
      useMaykutSatVapPoly = .FALSE.
      SEAICEuseFluxForm  = .TRUE.
      SEAICEadvHeff      = .TRUE.
      SEAICEadvArea      = .TRUE.
      SEAICEadvSnow      = .TRUE.
      SEAICEadvSalt      = .FALSE.
      SEAICEmomAdvection       = .FALSE.
      SEAICEselectKEscheme     = 1
      SEAICEselectVortScheme   = 2
      SEAICEhighOrderVorticity = .FALSE.
      SEAICEupwindVorticity    = .FALSE.
      SEAICEuseAbsVorticity    = .FALSE.
      SEAICEuseJamartMomAdv    = .FALSE.
      SEAICEuseFlooding  = .TRUE.
      SEAICE_no_slip     = .FALSE.
      SEAICE_2ndOrderBC  = .FALSE.
      SEAICE_clipVelocities = .FALSE.
      SEAICE_maskRHS     = .FALSE.
      SEAICEetaZmethod   = 3
      SEAICEadvScheme    = 77
      SEAICEadvSchArea   = UNSET_I
      SEAICEadvSchHeff   = UNSET_I
      SEAICEadvSchSnow   = UNSET_I
      SEAICEadvSchSalt   = UNSET_I
      SEAICEdiffKhArea   = UNSET_RL
      SEAICEdiffKhHeff   = UNSET_RL
      SEAICEdiffKhSnow   = UNSET_RL
      SEAICEdiffKhSalt   = UNSET_RL
      DIFF1      = UNSET_RL
C--   old DIFF1 default:
c     DIFF1      = .004D0
      SEAICE_deltaTtherm = dTtracerLev(1)
      SEAICE_deltaTdyn   = dTtracerLev(1)
      SEAICE_deltaTevp   = UNSET_RL
      SEAICEuseBDF2      = .FALSE.
      SEAICEuseKrylov    = .FALSE.
C     JFNK stuff
      SEAICEuseJFNK       = .FALSE.
      SEAICEuseIMEX       = .FALSE.
      SEAICE_JFNK_lsIter  = UNSET_I
      SEAICE_JFNK_tolIter = 100
C     This should be the default for both JFNK and for LSR but in order
C     to not jeopardize any existing results, and because it does not yet
C     work for llc/cubed-sphere topologies, we require that the user knows
C     what he/she is doing when turning this on.
      SEAICE_OLx          = OLx-2
      SEAICE_OLy          = OLy-2
      JFNKgamma_nonlin    = 1.D-05
      JFNKgamma_lin_min   = 0.10D0
      JFNKgamma_lin_max   = 0.99D0
      JFNKres_t           = UNSET_RL
      JFNKres_tFac        = UNSET_RL
      SEAICE_JFNKepsilon  = 1.D-06
C     factor for inexact Newton forcing, .gt. 0 and .le. 1
      SEAICE_JFNKphi      = 1.D0
C     exponent for inexact Newton forcing .gt. 1 and .le. 2
      SEAICE_JFNKalpha    = 1.D0
C     Hunke, JCP, 2001 use 615 kg/m^2 for this, but does not recommend using it
      SEAICE_evpDampC    = -1.D0
      SEAICE_zetaMin     = 0.D0
      SEAICE_zetaMaxFac  = 2.5D8
      SEAICEpresH0       = 1.D0
      SEAICEpresPow0     = 1
      SEAICEpresPow1     = 1
      SEAICE_evpTauRelax = -1.D0
      SEAICE_elasticParm = 0.33333333333333333333333333D0
      SEAICE_evpAlpha    = UNSET_RL
      SEAICE_evpBeta     = UNSET_RL
      SEAICEnEVPstarSteps = UNSET_I
      SEAICEaEVPcoeff    = UNSET_RL
      SEAICEaEVPcStar    = UNSET_RL
      SEAICEaEVPalphaMin = UNSET_RL
      SEAICE_initialHEFF = ZERO
      SEAICE_rhoIce      = 0.91D+03
      SEAICE_rhoSnow     = 330.D0
      ICE2WATR           = UNSET_RL
      SEAICE_drag        = 0.001D0
      OCEAN_drag         = 0.001D0
      SEAICE_waterDrag   = 0.0055D0
      SEAICEdWatMin      = 0.25D0
      SEAICE_dryIceAlb   = 0.75D0
      SEAICE_wetIceAlb   = 0.66D0
      SEAICE_drySnowAlb  = 0.84D0
      SEAICE_wetSnowAlb  = 0.7D0
      HO                 = 0.5D0
      SEAICE_drag_south       = UNSET_RL
      SEAICE_waterDrag_south  = UNSET_RL
      SEAICE_dryIceAlb_south  = UNSET_RL
      SEAICE_wetIceAlb_south  = UNSET_RL
      SEAICE_drySnowAlb_south = UNSET_RL
      SEAICE_wetSnowAlb_south = UNSET_RL
      HO_south                = UNSET_RL
C     basal drag parameters following Lemieux et al. (2015)
      SEAICE_cBasalStar = UNSET_RL
      SEAICEbasalDragU0 =  5.D-05
      SEAICEbasalDragK1 =  8.D0
      SEAICEbasalDragK2 =  0.D0
C     Lemieux et al. (2015) recommend: SEAICEbasalDragK2 = 15.D0
C
      SEAICE_wetAlbTemp  = -1.D-3
      SEAICE_waterAlbedo = UNSET_RL
      SEAICE_strength    = UNSET_RL
      SEAICE_cStar       = 20.D0
      SEAICEpressReplFac = 1.D0
      SEAICE_eccen       = 2.D0
      SEAICE_eccfr       = UNSET_RL
      SEAICE_tensilFac   = 0.D0
      SEAICE_tensilDepth = 0.D0
      SEAICEtdMU         = 1.D0
      SEAICEmcMu         = 1.D0
C     coefficients for flux computations/bulk formulae
      SEAICE_dalton      = 1.75D-03
      IF ( useEXF ) THEN
C     Use parameters that have already been set in data.exf
C     to be consistent
       SEAICE_rhoAir     = atmrho
       SEAICE_cpAir      = atmcp
       SEAICE_lhEvap     = flamb
       SEAICE_lhFusion   = flami
       SEAICE_boltzmann  = stefanBoltzmann
       SEAICE_emissivity = ocean_emissivity
       SEAICE_ice_emiss  = ice_emissivity
       SEAICE_snow_emiss = snow_emissivity
      ELSE
       SEAICE_rhoAir     = 1.3D0
       SEAICE_cpAir      = 1004.D0
       SEAICE_lhEvap     = 2.50D6
       SEAICE_lhFusion   = 3.34D5
       SEAICE_boltzmann  = 5.670D-08
C     old default value of 0.97001763668430343479
       SEAICE_emissivity = 5.5D-08/5.670D-08
       SEAICE_ice_emiss  = SEAICE_emissivity
       SEAICE_snow_emiss = SEAICE_emissivity
      ENDIF
      SEAICE_iceConduct  = 2.1656D+00
      SEAICE_snowConduct = 3.1D-01
      SEAICE_snowThick   = 0.15D0
      SEAICE_shortwave   = 0.30D0
      SEAICE_salt0       = 0.0D0
      SEAICE_saltFrac    = 0.0D0
      SEAICE_multDim     = 1
      DO l=1,nITD
       SEAICE_PDF(l)     = UNSET_RL
      ENDDO
      SEAICE_useMultDimSnow = .TRUE.
C     default to be set later (ocean-seaice turbulent flux coeff):
      SEAICE_mcPheeStepFunc = .FALSE.
      SEAICE_mcPheeTaper    = UNSET_RL
      SEAICE_availHeatTaper = UNSET_RL
      SEAICE_mcPheePiston   = UNSET_RL
      SEAICE_frazilFrac     = UNSET_RL
      SEAICE_gamma_t        = UNSET_RL
      SEAICE_gamma_t_frz    = UNSET_RL
      SEAICE_availHeatFrac  = UNSET_RL
      SEAICE_availHeatFracFrz = UNSET_RL
      SEAICE_doOpenWaterGrowth=.TRUE.
      SEAICE_doOpenWaterMelt=.FALSE.
      SEAICE_areaLossFormula=1
      SEAICE_areaGainFormula=1
      SEAICE_tempFrz0    = 0.0901D0
      SEAICE_dTempFrz_dS = -0.0575D0
C     old default for constant freezing point
c     SEAICE_tempFrz0    = -1.96D0
c     SEAICE_dTempFrz_dS = 0.D0
      SEAICEstressFactor = 1.D0
      SEAICE_tauAreaObsRelax = -999.D0
      AreaFile   = ' '
      HsnowFile  = ' '
      HsaltFile  = ' '
      HeffFile   = ' '
      uIceFile   = ' '
      vIceFile   = ' '
      IMAX_TICE  = 10
      postSolvTempIter = 2
C     LSR parameters
      SEAICEuseLSR = .TRUE.
      SEAICEusePicardAsPrecon = .FALSE.
      SEAICE_LSRrelaxU = 0.95D0
      SEAICE_LSRrelaxV = 0.95D0
      SOLV_NCHECK= 2
      SEAICEnonLinIterMax = UNSET_I
      SEAICElinearIterMax = UNSET_I
      SEAICEpreconNL_Iter =  0
      SEAICEpreconLinIter = 10
      LSR_mixIniGuess = -1
      LSR_ERROR  = 0.00001D0
      SEAICEuseMultiTileSolver = .FALSE.

      SEAICE_area_floor = siEPS
      SEAICE_area_reg   = siEPS
      SEAICE_hice_reg   = 0.05D0
      SEAICE_area_max   = 1.00D0

      SEAICE_airTurnAngle   = 0.0D0
      SEAICE_waterTurnAngle = 0.0D0
      MIN_ATEMP         = -50.D0
      MIN_LWDOWN        = 60.D0
      MIN_TICE          = -50.D0
      SEAICE_deltaMin   = UNSET_RL
      SEAICE_EPS        = 1.D-10
      SEAICE_EPS_SQ     = -99999.

      SEAICEwriteState  = .FALSE.
      SEAICE_monFreq    = monitorFreq
      SEAICE_dumpFreq   = dumpFreq
      SEAICE_taveFreq   = taveFreq
      SEAICE_tave_mnc = timeave_mnc
      SEAICE_dump_mnc = snapshot_mnc
      SEAICE_mon_mnc  = monitor_mnc
      SEAICE_debugPointI = UNSET_I
      SEAICE_debugPointJ = UNSET_I
      SINegFac = 1.D0
C-    Retired parameters:
c     LAD        = 2
      LAD        = UNSET_I
      NPSEUDOTIMESTEPS   = UNSET_I
      SOLV_MAX_ITERS     = UNSET_I
      SEAICEnewtonIterMax= UNSET_I
      SEAICEkrylovIterMax= UNSET_I
      JFNKgamma_nonlin   = UNSET_RL
c     SEAICE_sensHeat    = 1.75D-03 * 1004 * 1.3
c     SEAICE_sensHeat    = 2.284D+00
      SEAICE_sensHeat    = UNSET_RL
c     SEAICE_latentWater = 1.75D-03 * 2.500D06 * 1.3
c     SEAICE_latentWater = 5.6875D+03
      SEAICE_latentWater = UNSET_RL
c     SEAICE_latentIce   = 1.75D-03 * 2.834D06 * 1.3
c     SEAICE_latentIce   = 6.4474D+03
      SEAICE_latentIce   = UNSET_RL
      SEAICE_salinity    = UNSET_RL
      SIsalFRAC          = UNSET_RL
      SIsal0             = UNSET_RL
      IceAgeFile         = ' '
c     MAX_TICE           = 30.D0
      MAX_TICE           = UNSET_RL
      areaMin            = UNSET_RL
      hiceMin            = UNSET_RL
      A22                = UNSET_RL
      areaMax            = UNSET_RL
      SEAICE_lhSublim    = UNSET_RL
      SEAICEadvAge       = .TRUE.
      SEAICEadvSchAge    = UNSET_I
      SEAICEdiffKhAge    = UNSET_RL
      IceAgeTrFile(1)    = ' '
      IceAgeTrFile(2)    = ' '
      IceAgeTrFile(3)    = ' '
      IceAgeTrFile(4)    = ' '
      SEAICEturbFluxFormula =UNSET_I
      SEAICE_freeze      = UNSET_RL
      MAX_HEFF           = UNSET_RL
      SEAICEuseAB2       = .FALSE.
      SEAICE_abEps       = UNSET_RL
C
      SEAICEupdateDamage  = .FALSE.
C     MEB parameters
      SEAICEuseMEB        = .FALSE.
      SEAICEpoissonRatio  = 0.3
      SEAICEdamageMin     = 1.D-16
      SEAICEviscosity     = UNSET_RL
      SEAICEcohesion      = 25.0D3
      SEAICEdamageParm    = 4.0D0
      SEAICEintFrictCoeff = UNSET_RL
      SEAICEmohrCoulombSlope = UNSET_RL
      SEAICEelasticWaveSp = 500.D0
      SEAICEhealingTime   = 1.D15
      SEAICEdamageTime    = SEAICE_deltaTdyn

C-    end retired parameters


      nRetired = 0
      nError   = 0

C     Open and read the data.seaice file
      WRITE(msgBuf,'(A)')
     &' '
      CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                    SQUEEZE_RIGHT , myThid)
      WRITE(msgBuf,'(A)') ' SEAICE_READPARMS: opening data.seaice'
      CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                    SQUEEZE_RIGHT , myThid)

      CALL OPEN_COPY_DATA_FILE(
     I                          'data.seaice', 'SEAICE_READPARMS',
     O                          iUnit,
     I                          myThid )

C--   Read settings from model parameter file "data.seaice".
      READ(UNIT=iUnit,NML=SEAICE_PARM01)



      CLOSE(iUnit,STATUS='DELETE')


      WRITE(msgBuf,'(A)')
     &     ' SEAICE_READPARMS: finished reading data.seaice'
      CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                    SQUEEZE_RIGHT , myThid)

C--   Set default values (if not specified in data.seaice namelist)

C--   damage always needs to be updated for MEB
      IF ( SEAICEuseMEB ) SEAICEupdateDamage = .TRUE.
C--   Default ice strength (Pstar)
      IF (SEAICE_strength .EQ. UNSET_RL ) THEN
       SEAICE_strength = 2.75D+04
       IF ( SEAICEuseMEB ) SEAICE_strength = 2.*SEAICEelasticWaveSp**2
     &      * (1+SEAICEpoissonRatio) * SEAICE_rhoIce
      ENDIF
      IF (SEAICEviscosity .EQ. UNSET_RL )
     &     SEAICEviscosity = SEAICE_strength*1.D07
C--   Default for regularizing Delta to remain backward compatible
      IF ( SEAICE_deltaMin .EQ. UNSET_RL ) SEAICE_deltaMin = SEAICE_EPS
C--   Default is to have a normal flow rule if SEAICE_eccfr is not set
      IF (SEAICE_eccfr .EQ. UNSET_RL ) SEAICE_eccfr = SEAICE_eccen

C--   If no PDF was prescribed use the default uniform pdf
      tmp = SEAICE_multDim
      DO l = 1, SEAICE_multDim
       IF (SEAICE_PDF(l).EQ.UNSET_RL) SEAICE_PDF(l) = ONE/tmp
      ENDDO
      DO l = SEAICE_multDim+1, nITD
       IF (SEAICE_PDF(l).EQ.UNSET_RL) SEAICE_PDF(l) = 0.D0
      ENDDO

      IF (ICE2WATR.EQ.UNSET_RL) ICE2WATR = SEAICE_rhoIce*recip_rhoConst
      IF (SEAICE_drag_south       .EQ. UNSET_RL)
     &    SEAICE_drag_south       = SEAICE_drag
      IF (SEAICE_waterDrag_south  .EQ. UNSET_RL)
     &    SEAICE_waterDrag_south  = SEAICE_waterDrag
      IF (SEAICE_dryIceAlb_south  .EQ. UNSET_RL)
     &    SEAICE_dryIceAlb_south  = SEAICE_dryIceAlb
      IF (SEAICE_wetIceAlb_south  .EQ. UNSET_RL)
     &    SEAICE_wetIceAlb_south  = SEAICE_wetIceAlb
      IF (SEAICE_drySnowAlb_south .EQ. UNSET_RL)
     &    SEAICE_drySnowAlb_south = SEAICE_drySnowAlb
      IF (SEAICE_wetSnowAlb_south .EQ. UNSET_RL)
     &    SEAICE_wetSnowAlb_south = SEAICE_wetSnowAlb
      IF (HO_south                .EQ. UNSET_RL)
     &    HO_south                = HO
C     Basal drag parameter
      IF (SEAICE_cBasalStar .EQ. UNSET_RL)
     &     SEAICE_cBasalStar = SEAICE_cStar

C     Check that requested time step size is supported.  The combination
C     below is the only one that is supported at this time.  Does not
C     mean that something fancier will not work, just that it has not
C     yet been tried nor thought through.
      IF ( SEAICE_deltaTtherm .NE. dTtracerLev(1)     .OR.
     &     SEAICE_deltaTdyn   .LT. SEAICE_deltaTtherm .OR.
     &     (SEAICE_deltaTdyn/SEAICE_deltaTtherm) .NE.
     &     INT(SEAICE_deltaTdyn/SEAICE_deltaTtherm) ) THEN
         WRITE(msgBuf,'(A)')
     &        'Unsupported combination of SEAICE_deltaTtherm,'
         CALL PRINT_ERROR( msgBuf , myThid)
         WRITE(msgBuf,'(A)')
     &        ' SEAICE_deltaTdyn, and dTtracerLev(1)'
         CALL PRINT_ERROR( msgBuf , myThid)
         nError = nError + 1
      ENDIF
      SEAICEuseEVP = .FALSE.
C     There are three ways to turn on EVP
C     1. original EVP (Hunke, 2001)
      IF ( SEAICE_deltaTevp .NE. UNSET_RL ) SEAICEuseEVP = .TRUE.
C     2. modified EVP (Lemieux et al., 2012) or revised EVP (Bouillon
C     et al., 2014) by setting alpha and beta
      IF ( SEAICE_evpAlpha  .NE. UNSET_RL
     &  .OR. SEAICE_evpBeta .NE. UNSET_RL ) SEAICEuseEVP = .TRUE.
C     3. adaptive EVP
      IF ( SEAICEaEVPcoeff  .NE. UNSET_RL ) SEAICEuseEVP = .TRUE.
C     if EVP is turned on, a couple of parameters need to be computed
      IF ( SEAICEuseEVP ) THEN
       IF (    (SEAICE_deltaTdyn/SEAICE_deltaTevp) .NE.
     &      INT(SEAICE_deltaTdyn/SEAICE_deltaTevp) .AND.
     &      .NOT. (SEAICEuseEVPstar.OR.SEAICEuseEVPrev) ) THEN
        WRITE(msgBuf,'(A)')
     &       'SEAICE_deltaTevp must be a factor of SEAICE_deltaTdyn.'
        CALL PRINT_ERROR( msgBuf , myThid)
        nError = nError + 1
       ENDIF
       IF ( SEAICE_elasticParm .LE. 0.D0 ) THEN
        WRITE(msgBuf,'(A)')
     &       'SEAICE_elasticParm must greater than 0.'
        CALL PRINT_ERROR( msgBuf , myThid)
        nError = nError + 1
       ENDIF
       IF ( SEAICE_evpTauRelax .LE. 0.D0 )
     &      SEAICE_evpTauRelax = SEAICE_deltaTdyn*SEAICE_elasticParm
C     determine number of internal steps
       IF ( SEAICEnEVPstarSteps.EQ.UNSET_I ) THEN
        IF ( SEAICE_deltaTevp.EQ.UNSET_RL ) THEN
         WRITE(msgBuf,'(A,A)') 'S/R SEAICE_readparms: Either ',
     &        'SEAICEnEVPstarSteps or SEAICE_deltaTevp need to be set.'
         CALL PRINT_ERROR( msgBuf , myThid)
         nError = nError + 1
        ELSE
         SEAICEnEVPstarSteps = INT(SEAICE_deltaTdyn/SEAICE_deltaTevp)
        ENDIF
       ENDIF
C     default: evpAlpha = evpBeta
       IF ( SEAICE_evpAlpha .NE. UNSET_RL .AND.
     &  SEAICE_evpBeta .EQ. UNSET_RL ) SEAICE_evpBeta = SEAICE_evpAlpha
       IF ( SEAICE_evpBeta .NE. UNSET_RL .AND.
     & SEAICE_evpAlpha .EQ. UNSET_RL ) SEAICE_evpAlpha = SEAICE_evpBeta
C     derive other parameters
       IF ( SEAICE_evpBeta .EQ. UNSET_RL ) THEN
        SEAICE_evpBeta   = SEAICE_deltaTdyn/SEAICE_deltaTevp
       ELSE
        SEAICE_deltaTevp = SEAICE_deltaTdyn/SEAICE_evpBeta
       ENDIF
       IF ( SEAICE_evpAlpha .EQ. UNSET_RL ) THEN
        SEAICE_evpAlpha = 2.D0 * SEAICE_evpTauRelax/SEAICE_deltaTevp
       ELSE
        SEAICE_evpTauRelax = 0.5D0 *SEAICE_evpAlpha*SEAICE_deltaTevp
       ENDIF
C     this turns on adaptive EVP
       IF ( SEAICEaEVPcoeff .NE. UNSET_RL ) THEN
        IF ( SEAICEaEVPcStar  .EQ.UNSET_RL) SEAICEaEVPcStar   =4.D0
        IF (SEAICEaEVPalphaMin.EQ.UNSET_RL) SEAICEaEVPalphaMin=5.D0
C     requires EVP* to work well, so make sure we set it here (commented out
C     for now, but these values are the default values now)
CML        SEAICEuseEVPstar   = .TRUE.
CML        SEAICEuseEVPrev    = .TRUE.
C     For adaptive EVP we do not need constant parameters alpha and
C     beta, because they are computed dynamically. Reset them to
C     undefined here, so that we know if something funny is going on.
        SEAICE_evpAlpha     = UNSET_RL
        SEAICE_evpBeta      = UNSET_RL
       ENDIF
C     Check if all parameters are set.
      ENDIF

      IF ( SEAICEmohrCoulombSlope .NE. UNSET_RL
     &     .AND. SEAICEintFrictCoeff .NE. UNSET_RL ) THEN
       WRITE(msgBuf,'(A)')
     &      'cannot set SEAICEmohrCoulomb and SEAICEintFrictCoeff '//
     &      'at the same time.'
       CALL PRINT_ERROR( msgBuf , myThid)
       STOP 'ABNORMAL END: S/R SEAICE_READPARMS'
      ENDIF
      IF ( SEAICEintFrictCoeff .NE. UNSET_RL ) THEN
       SEAICEmohrCoulombSlope = SEAICEintFrictCoeff
     &      /SQRT(1.D0 + SEAICEintFrictCoeff**2)
      ELSE
       IF ( SEAICEmohrCoulombSlope .NE. UNSET_RL ) THEN
        SEAICEintFrictCoeff = SEAICEmohrCoulombSlope
     &       /SQRT(1.D0 - SEAICEmohrCoulombSlope**2)
       ELSE
        SEAICEintFrictCoeff = 0.7D0
        SEAICEmohrCoulombSlope = SEAICEintFrictCoeff
     &       /SQRT(1.D0 + SEAICEintFrictCoeff**2)
       ENDIF
      ENDIF


      IF ( .NOT.useHibler79IceStrength ) THEN
       useHibler79IceStrength = .TRUE.
       WRITE(msgBuf,'(A,A)')
     &      'WARNING FROM S/R SEAICE_READPARMS:',
     &      ' resetting useHibler79IceStrength = .TRUE., because'
      CALL PRINT_MESSAGE( msgBuf, errorMessageUnit,
     &                    SQUEEZE_RIGHT , myThid)
       WRITE(msgBuf,'(A,A)')
     &      'WARNING FROM S/R SEAICE_READPARMS:',
     &      ' SEAICE_ITD is not defined.'
      CALL PRINT_MESSAGE( msgBuf, errorMessageUnit,
     &                    SQUEEZE_RIGHT , myThid)
      ENDIF

C     reset default SEAICEuseLSR according to parameters from namelist
      SEAICEuseLSR = .NOT.SEAICEuseFREEDRIFT .AND. .NOT.SEAICEuseEVP
     &     .AND. .NOT.SEAICEuseJFNK .AND. .NOT. SEAICEuseKrylov
C     allow SEAICEuseLSR = .TRUE. if used as a preconditioner for non-linear
C     JFNK problem (and Krylov solver is not used)
      IF ( SEAICEuseJFNK .AND. SEAICEusePicardAsPrecon .AND.
     &     .NOT. SEAICEuseKrylov ) SEAICEuseLSR = .TRUE.
      IF ( SEAICEuseJFNK .AND. .NOT. SEAICEusePicardAsPrecon )
     &     SEAICEuseKrylov = .FALSE.

C     Set different defaults for different solvers
      IF ( SEAICEnonLinIterMax .EQ. UNSET_I ) THEN
C     two nonlinear iterations correspond to the original modified
C     Euler time stepping scheme of Zhang+Hibler (1997)
       IF ( SEAICEuseLSR ) SEAICEnonLinIterMax = 2
       IF ( SEAICEuseJFNK.OR.SEAICEuseKrylov ) SEAICEnonLinIterMax = 10
      ENDIF
C     Make sure that we have least two pseudo time steps for Picard-LSR
      IF ( SEAICEuseLSR .AND. .NOT. SEAICEusePicardAsPrecon )
     &     SEAICEnonLinIterMax = MAX(SEAICEnonLinIterMax,2)

C-    different defaults for different linear solvers
      IF ( SEAICElinearIterMax .EQ. UNSET_I ) THEN
C     maximum number of LSOR steps in default Picard solver
C     (=previous default for retired SOLV_MAX_ITERS)
       SEAICElinearIterMax = 1500
C     the maximum number of Krylov dimensions of 50 is hard coded in
C     S/R SEAICE_FGMRES, so that more than 50 linear iterations will
C     restart GMRES
       IF ( SEAICEuseJFNK.OR.SEAICEuseKrylov ) SEAICElinearIterMax = 10
      ENDIF

C     Turn line search with JFNK solver off by default by making this
C     number much larger than the maximum allowed Newton iterations
      IF ( SEAICE_JFNK_lsIter .EQ. UNSET_I )
     &     SEAICE_JFNK_lsIter  = 2*SEAICEnewtonIterMax

C     2nd order boundary conditions only possible for no_slip,
C     and EVP, JFNK, and Krylov solvers
      IF ( .NOT. SEAICE_no_slip ) SEAICE_2ndOrderBC = .FALSE.
      IF ( SEAICEuseLSR ) SEAICE_2ndOrderBC = .FALSE.

C     2nd order boundary conditions require one more row of overlap for the additive Schwartz method
      IF ( SEAICE_2ndOrderBC ) THEN
       SEAICE_OLx = OLx-3
       SEAICE_OLy = OLy-3
      ENDIF

C-    The old ways of specifying mcPheeTaper, mcPheePiston & frazilFrac:
C     a) prevent multiple specification of the same coeff;
C     b) if specified, then try to recover old way of setting & default.
      IF ( SEAICE_mcPheeTaper .EQ. UNSET_RL ) THEN
       IF ( SEAICE_availHeatTaper.EQ.UNSET_RL ) THEN
         SEAICE_mcPheeTaper = 0.0D0
       ELSE
         SEAICE_mcPheeTaper = SEAICE_availHeatTaper
       ENDIF
      ELSEIF ( SEAICE_availHeatTaper.NE.UNSET_RL ) THEN
         WRITE(msgBuf,'(2A)') 'S/R SEAICE_READPARMS: Cannot specify ',
     &    'both SEAICE_mcPheeTaper & SEAICE_availHeatTaper'
         CALL PRINT_ERROR( msgBuf , myThid)
         nError = nError + 1
      ENDIF

C-    set SEAICE_frazilFrac if not yet done
      IF ( SEAICE_gamma_t_frz .NE. UNSET_RL ) THEN
       IF ( SEAICE_frazilFrac .EQ. UNSET_RL ) THEN
         SEAICE_frazilFrac = SEAICE_deltaTtherm/SEAICE_gamma_t_frz
       ELSE
         WRITE(msgBuf,'(2A)') 'S/R SEAICE_READPARMS: Cannot specify ',
     &    'both SEAICE_frazilFrac & SEAICE_gamma_t_frz'
         CALL PRINT_ERROR( msgBuf , myThid)
         nError = nError + 1
       ENDIF
      ENDIF
      IF ( SEAICE_availHeatFracFrz.NE.UNSET_RL ) THEN
       IF ( SEAICE_frazilFrac .EQ. UNSET_RL ) THEN
         SEAICE_frazilFrac = SEAICE_availHeatFracFrz
       ELSE
        IF ( SEAICE_gamma_t_frz .EQ. UNSET_RL ) THEN
         WRITE(msgBuf,'(2A)') 'S/R SEAICE_READPARMS: Cannot specify ',
     &    'both SEAICE_frazilFrac  & SEAICE_availHeatFracFrz'
        ELSE
         WRITE(msgBuf,'(2A)') 'S/R SEAICE_READPARMS: Cannot specify ',
     &    'both SEAICE_gamma_t_frz & SEAICE_availHeatFracFrz'
        ENDIF
        CALL PRINT_ERROR( msgBuf , myThid)
        nError = nError + 1
       ENDIF
      ENDIF
C     the default for SEAICE_gamma_t_frz use to be SEAICE_gamma_t:
      IF ( SEAICE_gamma_t .NE. UNSET_RL .AND.
     &     SEAICE_frazilFrac .EQ. UNSET_RL ) THEN
         SEAICE_frazilFrac = SEAICE_deltaTtherm/SEAICE_gamma_t
      ENDIF
C     the default for SEAICE_availHeatFracFrz use to be SEAICE_availHeatFrac:
      IF ( SEAICE_availHeatFrac.NE.UNSET_RL .AND.
     &     SEAICE_frazilFrac .EQ. UNSET_RL ) THEN
         SEAICE_frazilFrac = SEAICE_availHeatFrac
      ENDIF
      IF ( SEAICE_frazilFrac .EQ. UNSET_RL ) THEN
         SEAICE_frazilFrac = 1.D0
      ENDIF

C-    start by setting SEAICE_availHeatFrac (used in seaice_init_fixed.F
C     to set SEAICE_mcPheePiston once drF is known)
      IF ( SEAICE_gamma_t .NE. UNSET_RL ) THEN
       IF ( SEAICE_availHeatFrac.EQ.UNSET_RL ) THEN
         SEAICE_availHeatFrac = SEAICE_deltaTtherm/SEAICE_gamma_t
       ELSE
         WRITE(msgBuf,'(2A)') 'S/R SEAICE_READPARMS: Cannot specify ',
     &    'both SEAICE_gamma_t & SEAICE_availHeatFrac'
         CALL PRINT_ERROR( msgBuf , myThid)
         nError = nError + 1
       ENDIF
      ENDIF
      IF ( SEAICE_mcPheePiston .NE. UNSET_RL .AND.
     &     SEAICE_availHeatFrac.NE. UNSET_RL ) THEN
        IF ( SEAICE_gamma_t .EQ. UNSET_RL ) THEN
         WRITE(msgBuf,'(2A)') 'S/R SEAICE_READPARMS: Cannot specify ',
     &    'both SEAICE_mcPheePiston & SEAICE_availHeatFrac'
        ELSE
         WRITE(msgBuf,'(2A)') 'S/R SEAICE_READPARMS: Cannot specify ',
     &    'both SEAICE_mcPheePiston & SEAICE_gamma_t'
        ENDIF
        CALL PRINT_ERROR( msgBuf , myThid)
        nError = nError + 1
      ENDIF

      IF ( useThSice ) THEN
C     If the thsice package with the Winton thermodynamics is used
C     is does not make sense to have the following parameters defined,
C     so we reset them here
       usePW79thermodynamics = .FALSE.
       SEAICEadvHeff         = .FALSE.
       SEAICEadvArea         = .FALSE.
       SEAICEadvSnow         = .FALSE.
       SEAICEadvSalt         = .FALSE.
      ENDIF
C     Set advection schemes to some sensible values if not done in data.seaice
      IF ( SEAICEadvSchArea .EQ. UNSET_I )
     &     SEAICEadvSchArea = SEAICEadvSchHeff
      IF ( SEAICEadvSchArea .EQ. UNSET_I )
     &     SEAICEadvSchArea = SEAICEadvScheme
      IF ( SEAICEadvScheme .NE. SEAICEadvSchArea )
     &     SEAICEadvScheme  = SEAICEadvSchArea
      IF ( SEAICEadvSchHeff .EQ. UNSET_I )
     &     SEAICEadvSchHeff = SEAICEadvSchArea
      IF ( SEAICEadvSchSnow .EQ. UNSET_I )
     &     SEAICEadvSchSnow = SEAICEadvSchHeff
      IF ( SEAICEadvSchSalt .EQ. UNSET_I )
     &     SEAICEadvSchSalt = SEAICEadvSchHeff
C     Set diffusivity to some sensible values if not done in data.seaice
      IF ( SEAICEdiffKhArea .EQ. UNSET_RL )
     &     SEAICEdiffKhArea = SEAICEdiffKhHeff
      IF ( SEAICEdiffKhArea .EQ. UNSET_RL )
     &     SEAICEdiffKhArea = 0.D0
      IF ( SEAICEdiffKhHeff .EQ. UNSET_RL )
     &     SEAICEdiffKhHeff = SEAICEdiffKhArea
      IF ( SEAICEdiffKhSnow .EQ. UNSET_RL )
     &     SEAICEdiffKhSnow = SEAICEdiffKhHeff
      IF ( SEAICEdiffKhSalt .EQ. UNSET_RL )
     &     SEAICEdiffKhSalt = SEAICEdiffKhHeff
      IF ( SEAICE_EPS_SQ .EQ. -99999. )
     &     SEAICE_EPS_SQ = SEAICE_EPS * SEAICE_EPS

      SEAICEmultiDimAdvection = .TRUE.
      IF ( SEAICEadvScheme.EQ.ENUM_CENTERED_2ND
     & .OR.SEAICEadvScheme.EQ.ENUM_UPWIND_3RD
     & .OR.SEAICEadvScheme.EQ.ENUM_CENTERED_4TH ) THEN
       SEAICEmultiDimAdvection = .FALSE.
      ENDIF

C-    Retired parameters
      IF ( SEAICEnewtonIterMax .NE. UNSET_I ) THEN
       nRetired = nRetired + 1
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: "SEAICEnewtonIterMax" ',
     &  'is no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A)')
     &  'S/R SEAICE_READPARMS: use "SEAICEnonLinIterMax" instead'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( SEAICEkrylovIterMax .NE. UNSET_I ) THEN
       nRetired = nRetired + 1
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: "SEAICEkrylovIterMax" ',
     &  'is no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A)')
     &  'S/R SEAICE_READPARMS: use "SEAICElinearIterMax" instead'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( NPSEUDOTIMESTEPS    .NE. UNSET_I ) THEN
       nRetired = nRetired + 1
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: "NPSEUDOTIMESTEPS" ',
     &  'is no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A)')
     &  'S/R SEAICE_READPARMS: use "SEAICEnonLinIterMax" instead'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( SOLV_MAX_ITERS .NE. UNSET_I ) THEN
       nRetired = nRetired + 1
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: "SOLV_MAX_ITERS" ',
     &  'is no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A)')
     &  'S/R SEAICE_READPARMS: use "SEAICElinearIterMax" instead'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( JFNKgamma_nonlin   .NE. UNSET_RL ) THEN
       nRetired = nRetired + 1
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: "JFNKgamma_nonlin" ',
     &  'is no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A)')
     &  'S/R SEAICE_READPARMS: use "SEAICEnonLinTol" instead'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( SEAICE_sensHeat    .NE. UNSET_RL ) THEN
       nRetired = nRetired + 1
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: "SEAICE_sensHeat" ',
     &  'is no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: set "SEAICE_cpAir", ',
     &  '"SEAICE_dalton", and "SEAICE_rhoAir" instead'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( SEAICE_latentWater .NE. UNSET_RL ) THEN
       nRetired = nRetired + 1
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: "SEAICE_latentWater" ',
     &  'is no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: set "SEAICE_lhEvap", ',
     &  '"SEAICE_dalton", and "SEAICE_rhoAir" instead'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( SEAICE_latentIce   .NE. UNSET_RL ) THEN
       nRetired = nRetired + 1
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: "SEAICE_latentIce" ',
     &  'is no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: set "SEAICE_lhFusion", ',
     &  '"SEAICE_dalton", and "SEAICE_rhoAir" instead'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( SEAICE_freeze .NE. UNSET_RL ) THEN
       WRITE(msgBuf,'(A,A)')'S/R SEAICE_READPARMS: ',
     &  '"SEAICE_freeze" no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A,A)')'S/R SEAICE_READPARMS: ',
     &  'set instead "SEAICE_tempFrz0" and "SEAICE_dTempFrz_dS"'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( SEAICE_salinity   .NE. UNSET_RL ) THEN
       nRetired = nRetired + 1
       WRITE(msgBuf,'(A,A)') 'S/R SEAICE_READPARMS: ',
     &  '"SEAICE_salinity" is no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A,A)') 'S/R SEAICE_READPARMS: ',
     &  'set "SEAICE_saltFrac" instead'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( SIsalFrac .NE. UNSET_RL ) THEN
       nRetired = nRetired + 1
       WRITE(msgBuf,'(A,A)') 'S/R SEAICE_READPARMS: ',
     &  '"SIsalFrac" is no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A,A)') 'S/R SEAICE_READPARMS: ',
     &  'set "SEAICE_saltFrac" instead'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( SIsal0 .NE. UNSET_RL ) THEN
       nRetired = nRetired + 1
       WRITE(msgBuf,'(A,A)') 'S/R SEAICE_READPARMS: ',
     &  '"SIsal0" is no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A,A)') 'S/R SEAICE_READPARMS: ',
     &  'set "SEAICE_salt0" instead'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( IceAgeFile .NE. ' ' ) THEN
       nRetired = nRetired + 1
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: "IceAgeFile" ',
     &  'is no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: replaced by ',
     &  '"IceAgeTrFile(SEAICE_num)" array '
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( areaMax .NE. UNSET_RL ) THEN
       nRetired = nRetired + 1
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: "areaMax" ',
     &  'is no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: replaced by ',
     &  '"SEAICE_area_max"'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( areaMin .NE. UNSET_RL ) THEN
       nRetired = nRetired + 1
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: "areaMin" ',
     &  'is no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: replaced by ',
     &  '"SEAICE_area_reg" for regularization and ',
     &  '"SEAICE_area_floor" setting a lower bound'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF (SEAICE_lhSublim .NE. UNSET_RL ) THEN
       nRetired = nRetired + 1
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: "SEAICE_lhSublim" ',
     &  'is no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: specify ',
     &  '"SEAICE_lhFusion" and "SEAICE_lhEvap" instead'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( A22 .NE. UNSET_RL ) THEN
       nRetired = nRetired + 1
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: "A22" ',
     &  'is no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: replaced by ',
     &  '"SEAICE_area_reg" for regularization'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( LAD .NE. UNSET_I ) THEN
       nRetired = nRetired + 1
       WRITE(msgBuf,'(A,A)') 'S/R SEAICE_READPARMS: "LAD" ',
     &  'is no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A,A)') 'always use modified Euler step ',
     &  '(LAD==2) since Leap frog code (LAD==1) is gone.'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( MAX_TICE .NE. UNSET_RL ) THEN
       nRetired = nRetired + 1
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: "MAX_TICE" ',
     &  'is no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( hiceMin .NE. UNSET_RL ) THEN
       nRetired = nRetired + 1
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: "hiceMin" ',
     &  'is no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: replaced by ',
     &  '"SEAICE_hice_reg" for regularization'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( .NOT. SEAICEadvAge ) THEN
       nRetired = nRetired + 1
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: "SEAICEadvAge" ',
     &  'is no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: since ALLOW_SITRACER ',
     &  'replaced and extended SEAICE_AGE'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( SEAICEadvSchAge .NE. UNSET_I ) THEN
       nRetired = nRetired + 1
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: "SEAICEadvSchAge" ',
     &  'is no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: since ALLOW_SITRACER ',
     &  'replaced and extended SEAICE_AGE'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( SEAICEdiffKhAge .NE. UNSET_RL ) THEN
       nRetired = nRetired + 1
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: "SEAICEdiffKhAge" ',
     &  'is no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: since ALLOW_SITRACER ',
     &  'replaced and extended SEAICE_AGE'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( ( IceAgeTrFile(1) .NE. ' ' ).OR.
     &     ( IceAgeTrFile(2) .NE. ' ' ).OR.
     &     ( IceAgeTrFile(3) .NE. ' ' ).OR.
     &     ( IceAgeTrFile(4) .NE. ' ' ) ) THEN
       nRetired = nRetired + 1
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: "IceAgeTrFile" ',
     &  'is no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: since ALLOW_SITRACER ',
     &  'replaced and extended SEAICE_AGE'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( SEAICEturbFluxFormula .NE. UNSET_I ) THEN
       WRITE(msgBuf,'(A,A)')'S/R SEAICE_READPARMS: ',
     &  '"SEAICEturbFluxFormula" no longer allowed in "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A,A)')'S/R SEAICE_READPARMS: ',
     &  ' Set instead "SEAICE_mcPheePiston" and "SEAICE_frazilFrac"'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( MAX_HEFF .NE. UNSET_RL ) THEN
       nRetired = nRetired + 1
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: "MAX_HEFF" ',
     &  'is no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( SEAICEuseAB2 ) THEN
       nRetired = nRetired + 1
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: "SEAICEuseAB2" ',
     &  'is no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( SEAICE_abEps .NE. UNSET_RL ) THEN
       nRetired = nRetired + 1
       WRITE(msgBuf,'(A,A)')
     &  'S/R SEAICE_READPARMS: "SEAICE_abEps" ',
     &  'is no longer allowed in file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF
      IF ( nRetired .GT. 0 ) THEN
       WRITE(msgBuf,'(2A)') 'S/R SEAICE_READPARMS: ',
     &  'Error reading parameter file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A,I3,A)') 'S/R SEAICE_READPARMS: ', nRetired,
     &      ' out of date parameters were found in the namelist'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF

      IF ( nError .GT. 0 ) THEN
       WRITE(msgBuf,'(2A)') 'S/R SEAICE_READPARMS: ',
     &  'Error reading parameter file "data.seaice"'
       CALL PRINT_ERROR( msgBuf, myThid )
       WRITE(msgBuf,'(A,I3,A)') 'S/R SEAICE_READPARMS: ', nError,
     &  ' parameters values are inconsistent or incomplete'
       CALL PRINT_ERROR( msgBuf, myThid )
      ENDIF

      IF ( nRetired .GT. 0 .OR. nError .GT. 0 ) THEN
       CALL ALL_PROC_DIE( 0 )
       STOP 'ABNORMAL END: S/R SEAICE_READPARMS'
      ENDIF

C--   Now set-up any remaining parameters that result from other params

C-    convert SEAICE_doOpenWaterGrowth/Melt logical switch to numerical
C     facOpenGrow/facOpenMelt
      facOpenGrow = 0.D0
      facOpenMelt = 0.D0
      IF (SEAICE_doOpenWaterGrowth) facOpenGrow = 1.D0
      IF (SEAICE_doOpenWaterMelt)   facOpenMelt = 1.D0

C-    Set Output type flags :
      SEAICE_tave_mdsio = .TRUE.
      SEAICE_dump_mdsio = .TRUE.
      SEAICE_mon_stdio  = .TRUE.
      IF (useMNC) THEN
        IF ( .NOT.outputTypesInclusive
     &       .AND. SEAICE_tave_mnc ) SEAICE_tave_mdsio = .FALSE.
        IF ( .NOT.outputTypesInclusive
     &       .AND. SEAICE_dump_mnc ) SEAICE_dump_mdsio = .FALSE.
        IF ( .NOT.outputTypesInclusive
     &       .AND. SEAICE_mon_mnc  ) SEAICE_mon_stdio  = .FALSE.
      ENDIF

C-    store value of logical flag which might be changed in AD mode

C     Check the consitency of a few parameters
      IF ( SEAICE_emissivity .LT. 1.D-04 ) THEN
       WRITE(msgBuf,'(2A)')
     &      'SEAICE_emissivity is no longer emissivity*(boltzmann ',
     &      'constant) but really an emissivity.'
       CALL PRINT_ERROR( msgBuf , myThid)
       WRITE(msgBuf,'(2A)')
     &      'Typical values are near 1 ',
     &      '(default is 5.5/5.67=0.9700176...).'
       CALL PRINT_ERROR( msgBuf , myThid)
       WRITE(msgBuf,'(A,E13.6,A)')
     &      'Please change SEAICE_emissivity in data.seaice to ',
     &      SEAICE_emissivity, '/5.67e-8.'
       CALL PRINT_ERROR( msgBuf , myThid)
       STOP 'ABNORMAL END: S/R SEAICE_READPARMS'
      ENDIF

C--   Since the default of SEAICE_waterDrag has changed, issue a warning
C     in case of large values
      chkFlag = .FALSE.
      IF ( SEAICE_waterDrag .GT. 1.D0 ) THEN
       WRITE(msgBuf,'(A,A,F5.2)') '** WARNING ** SEAICE_READPARMS: ',
     &      'SEAICE_waterDrag = ', SEAICE_waterDrag
       CALL PRINT_MESSAGE( msgBuf, errorMessageUnit,
     &                     SQUEEZE_RIGHT, myThid )
       chkFlag = .TRUE.
      ENDIF
      IF ( SEAICE_waterDrag_South .GT. 1.D0 ) THEN
       WRITE(msgBuf,'(A,A,F5.2)') '** WARNING ** SEAICE_READPARMS: ',
     &      'SEAICE_waterDrag_South = ', SEAICE_waterDrag_South
       CALL PRINT_MESSAGE( msgBuf, errorMessageUnit,
     &                     SQUEEZE_RIGHT, myThid )
       chkFlag = .TRUE.
      ENDIF
      IF ( chkFlag ) THEN
       WRITE(msgBuf,'(3A)') '** WARNING ** SEAICE_READPARMS: ',
     &      'That is 3 orders of magnitude larger',
     &      ' than the default of 5.5e-3.'
       CALL PRINT_MESSAGE( msgBuf, errorMessageUnit,
     &                     SQUEEZE_RIGHT, myThid )
       WRITE(msgBuf,'(2A)') '** WARNING ** SEAICE_READPARMS: ',
     &      'Are you maybe using an old (pre Jun2018) data.seaice?'
       CALL PRINT_MESSAGE( msgBuf, errorMessageUnit,
     &                     SQUEEZE_RIGHT, myThid )
      ENDIF

      IF ( DIFF1 .EQ. UNSET_RL ) THEN
        DIFF1 = 0.D0
        chkFlag = .FALSE.
        IF ( SEAICEadvScheme.EQ.2 ) THEN
C--   Since DIFF1 default value has been changed (2011/05/29), issue a warning
C     in case using centered avection scheme without any diffusion:
         IF ( SEAICEadvHeff .AND. SEAICEdiffKhHeff .EQ. 0.D0 ) THEN
          WRITE(msgBuf,'(2A)') '** WARNING ** SEAICE_READPARMS: ',
     &    'will use AdvScheme = 2 for HEFF  without any diffusion'
          CALL PRINT_MESSAGE( msgBuf, errorMessageUnit,
     &                        SQUEEZE_RIGHT, myThid )
          chkFlag = .TRUE.
         ENDIF
         IF ( SEAICEadvArea .AND. SEAICEdiffKhArea .EQ. 0.D0 ) THEN
          WRITE(msgBuf,'(2A)') '** WARNING ** SEAICE_READPARMS: ',
     &    'will use AdvScheme = 2 for AREA  without any diffusion'
          CALL PRINT_MESSAGE( msgBuf, errorMessageUnit,
     &                        SQUEEZE_RIGHT, myThid )
          chkFlag = .TRUE.
         ENDIF
         IF ( SEAICEadvSnow .AND. SEAICEdiffKhSnow .EQ. 0.D0 ) THEN
          WRITE(msgBuf,'(2A)') '** WARNING ** SEAICE_READPARMS: ',
     &    'will use AdvScheme = 2 for HSNOW without any diffusion'
          CALL PRINT_MESSAGE( msgBuf, errorMessageUnit,
     &                        SQUEEZE_RIGHT, myThid )
          chkFlag = .TRUE.
         ENDIF
         IF ( SEAICEadvSalt .AND. SEAICEdiffKhSalt .EQ. 0.D0 ) THEN
          WRITE(msgBuf,'(2A)') '** WARNING ** SEAICE_READPARMS: ',
     &    'will use AdvScheme = 2 for HSALT without any diffusion'
          CALL PRINT_MESSAGE( msgBuf, errorMessageUnit,
     &                        SQUEEZE_RIGHT, myThid )
          chkFlag = .TRUE.
         ENDIF
         IF ( chkFlag ) THEN
          WRITE(msgBuf,'(2A)') '** WARNING ** SEAICE_READPARMS: ',
     &      'since DIFF1 is set to 0 (= new DIFF1 default value)'
          CALL PRINT_MESSAGE( msgBuf, errorMessageUnit,
     &                        SQUEEZE_RIGHT, myThid )
         ENDIF
        ENDIF
      ENDIF

      ENDIF

C--   Everyone else must wait for the parameters to be loaded
      CALL BARRIER(myThid)

      RETURN
      END
