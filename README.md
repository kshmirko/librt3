# librt3
polradtran library 

Экспортирует следующие функции

```
RADTRAN (NSTOKES, NUMMU, AZIORDER, MAX_DELTA_TAU,&
                         SRC_CODE, QUAD_TYPE, DELTAM,&
                         DIRECT_FLUX, DIRECT_MU,&
                         GROUND_TEMP, GROUND_TYPE,&
                         GROUND_ALBEDO, GROUND_INDEX,&
                         SKY_TEMP, WAVELENGTH,&
                         NUM_LAYERS, HEIGHT, TEMPERATURES,&
                         GAS_EXTINCT, SCAT_FILES,&
                         NOUTLEVELS, OUTLEVELS,&
                         MU_VALUES, UP_FLUX, DOWN_FLUX,&
                         UP_RAD, DOWN_RAD)
C        RADTRAN solves the plane-parallel polarized radiative transfer
C    equation for an inhomogenous atmosphere with randomly oriented
C    particles.  The sources of radiation are solar direct beam and thermal
C    emission.  The ground surface has Lambertian or Fresnel reflection and
C    emission.
C        Input is the relevant parameters for the atmospheric layers and
C    the boundary conditions for a number of different cases.  Output is
C    a Fourier azimuth series of the upwelling and downwelling radiances 
C    at selected levels at the discrete angles.
C        The heights and temperatures are specified at the layer interfaces,
C    i.e. N+1 values for N layers.  The gaseous extinction and scattering
C    files are specified for the N layers.  The layers are listed from the
C    top to the bottom of the atmosphere: HEIGHT(1) is top of the highest
C    layer and HEIGHT(N+1) is bottom of the lowest layer, SCAT_FILES(1) is
C    the scattering file of the top layer and SCAT_FILES(N) is the scattering
C    file of the bottom layer.
C
C
C    Parameter         Type             Description
C
C  NSTOKES           INTEGER       Number of Stokes parameters: 1 for I
C                                    (no polarization), 2 for I,Q,
C                                    3 for I,Q,U,  4 for I,Q,U,V.
C  NUMMU             INTEGER       Number of quadrature angles
C                                    (per hemisphere).
C  AZIORDER          INTEGER       Order of Fourier azimuth series:
C                                    0 is azimuthially symmetric case.
C  MAX_DELTA_TAU     REAL          Initial layer thickness for doubling;
C                                    governs accuracy, 10E-5 should be
C                                    adequate.  Don't go beyond half the
C                                    real precision, i.e. 10e-8 for REAL*8.
C  SRC_CODE          INTEGER       Radiation sources included:
C                                    none=0, solar=1, thermal=2, both=3
C  QUAD_TYPE         CHAR*1        Type of quadrature used: 
C                                    (G-gaussian, D-double gaussian, 
C                                     L-Lobatto, E-extra-angle).
C                                    If extra-angles then end of
C                                    MU_VALUES(<=NUMMU) contains the extra
C                                    angles and rest is zero.
C  DELTAM            CHAR*1        Delta-M scaling flag (Y or N)
C                                    If DELTAM='Y' then the scattering
C                                    properties are delta-M scaled when read in.
C  DIRECT_FLUX       REAL          Flux on horizontal plane from direct
C                                    (solar) source;  units W/(m*m)/um or K.
C  DIRECT_MU         REAL          Cosine of solar zenith angle
C
C  GROUND_TEMP       REAL          Ground surface temperature in Kelvin
C  GROUND_TYPE       CHAR*1        Type of ground surface:
C                                    L for Lambertian, F for Fresnel.
C                                    Only Lambertian allowed for solar source.
C  GROUND_ALBEDO     REAL          Albedo of Lambertian surface
C  GROUND_INDEX      COMPLEX       Index of refraction of Fresnel surface
C  SKY_TEMP          REAL          Temperature of blackbody radiation
C                                    incident on atmosphere from above
C  WAVELENGTH        REAL          Wavelength of radiation in microns.
C
C  NUM_LAYERS        INTEGER       Number of atmosphere layers input
C  HEIGHT            REAL array    Height of layer interfaces from top down
C                                    Units are inverse of units of extinction
C                                    and scattering, e.g. km.
C  TEMPERATURES      REAL array    Temperature (Kelvins) of layer interfaces
C  GAS_EXTINCT       REAL array    Gaseous (nonscattering) extinction of layers
C                                    For processes not in scattering file
C  SCAT_FILES        CHAR*64 array Names of scattering files for layers
C                                    String format 'RAIN.SCA', for no
C                                    scattering use ' '.  See example for
C                                    format of scattering file.
C
C  NOUTLEVELS        INTEGER       Number of output levels
C  OUTLEVELS         INTEGER       The levels numbers to output at,
C                                    from 1 at top to NUM_LAYERS+1 at bottom.
C
C  MU_VALUES         REAL array    Output quadrature angle values
C                                    (also input for QUAD_TYPE='E')
C  UP_FLUX           REAL array    Upward flux for each Stokes parameter
C                                    at each output level 
C                                    UP_FLUX(NSTOKES,NOUTLEVELS)
C  DOWN_FLUX         REAL array    Downward flux (NSTOKES,NOUTLEVELS)
C  UP_RAD            REAL array    Upward radiances
C                                    (NSTOKES,NUMMU,AZIORDER+1,NOUTLEVELS)
C  DOWN_RAD          REAL array    Downward radiances
C                                    (NSTOKES,NUMMU,AZIORDER+1,NOUTLEVELS)
C

OUTPUT_FILE (NSTOKES, NUMMU, AZIORDER,&
                         SRC_CODE, LAYER_FILE, OUT_FILE,&
                         QUAD_TYPE, DELTAM, DIRECT_FLUX, DIRECT_MU,&
                         GROUND_TEMP, GROUND_TYPE,&
                         GROUND_ALBEDO, GROUND_INDEX,&
                         SKY_TEMP, WAVELENGTH, UNITS, OUTPOL,&
                         NUM_LAYERS, HEIGHT,&
                         NOUTLEVELS, OUTLEVELS, NUMAZIMUTHS,&
                         MU_VALUES, UP_FLUX, DOWN_FLUX,&
                         UP_RAD, DOWN_RAD)
INTEGER  NSTOKES, NUMMU, NUMAZI, AZIORDER, SRC_CODE, NUM_LAYERS
INTEGER  NOUTLEVELS, OUTLEVELS(*), NUMAZIMUTHS
REAL*8   GROUND_TEMP, GROUND_ALBEDO
REAL*8   SKY_TEMP, WAVELENGTH
REAL*8   DIRECT_FLUX, DIRECT_MU
REAL*8   HEIGHT(NUM_LAYERS+1)
REAL*8   MU_VALUES(NUMMU)
REAL*8   UP_FLUX(NSTOKES,NOUTLEVELS)
REAL*8   DOWN_FLUX(NSTOKES,NOUTLEVELS)
REAL*8   UP_RAD(NSTOKES,NUMMU,AZIORDER+1,NOUTLEVELS)
REAL*8   DOWN_RAD(NSTOKES,NUMMU,AZIORDER+1,NOUTLEVELS)

                         
SUBROUTINE CONVERT_OUTPUT (UNITS, OUTPOL, NSTOKES, NOUT,
     .                           WAVELEN, FLUXCODE, OUTPUT)
C       Converts the output radiance or flux arrays to VH polarization
C     and effective blackbody temperature if desired.  OUTPOL='VH'
C     converts the polarization basis of the first two Stokes parameters
C     to vertical/horizontal polarization.  If UNITS='T' the radiance is
C     converted to effective blackbody brightness temperature, and if
C     UNITS='R' the radiance is converted to Rayleigh-Jeans brightness
C     temperature.  If the output is flux then FLUXCODE=1, and the flux 
C     is divided by pi before converting to brightness temperature.
      INTEGER NSTOKES, NOUT, FLUXCODE
      REAL*8  WAVELEN, OUTPUT(NSTOKES,NOUT)
      CHARACTER UNITS*1, OUTPOL*2
```

