#!/usr/env/bin ruby

top_srcdir = ".."
srcdir     = "."
lib        = "../lib"

CFLAGS_SOUND = ""
RSVG_CFLAGS = ""
WEBKIT_CFLAGS= ""
CAIRO_CFLAGS = ""
IMAGEMAGICK_CFLAGS= ""
LIBXML2_CFLAGS = ""
LCMS2_CFLAGS = ""
XRANDR_CFLAGS = ""
XINERAMA_CFLAGS = ""
XFIXES_CFLAGS = ""
XDBE_CFLAGS = ""

## Flags to pass to the compiler to enable build warnings
WARN_CFLAGS   = ""
WERROR_CFLAGS = ""

## Machine-specific CFLAGS.
C_SWITCH_MACHINE = ""
## System-specific CFLAGS.
C_SWITCH_SYSTEM = ""

GNUSTEP_CFLAGS = ""
PNG_CFLAGS = "-I/usr/include/libpng16"

AUTO_DEPEND = true
DEPDIR = "deps"
DEPFLAGS = ""
if AUTO_DEPEND == true then
  # DEPFLAGS = "-MMD -MF $(DEPDIR)/$*.d -MP"
  # -include $(ALLOBJS:%.o=$(DEPDIR)/%.d)
else
  DEPFLAGS = ""
  # include $(srcdir)/deps.mk
end

## Define C_SWITCH_X_SITE to contain any special flags your compiler
## may need to deal with X Windows.  For instance, if you've defined
## HAVE_X_WINDOWS and your X include files aren't in a place that your
## compiler can find on its own, you might want to add "-I/..." or
## something similar.  This is normally set by configure.
C_SWITCH_X_SITE = "-I/usr/include/uuid -I/usr/include/freetype2 -I/usr/include/libpng16"

## This must come before LD_SWITCH_SYSTEM.
## If needed, a -rpath option that says where to find X windows at run time.
LD_SWITCH_X_SITE_RPATH = ""

## System-specific LDFLAGS.
LD_SWITCH_SYSTEM = ""

## This holds any special options for linking temacs only (i.e., not
## used by configure).
LD_SWITCH_SYSTEM_TEMACS = "-Wl,-znocombreloc #{LD_SWITCH_X_SITE_RPATH} -no-pie"

## Flags to pass to ld only for temacs.
TEMACS_LDFLAGS = "#{LD_SWITCH_SYSTEM} #{LD_SWITCH_SYSTEM_TEMACS}"

## If available, the names of the paxctl and setfattr programs.
## On grsecurity/PaX systems, unexec will fail due to a gap between
## the bss section and the heap.  Older versions need paxctl to work
## around this, newer ones setfattr.  See Bug#11398 and Bug#16343.
PAXCTL = ""
SETFATTR = ""
## Commands to set PaX flags on dumped and not-dumped instances of Emacs.
PAXCTL_dumped = ""
PAXCTL_notdumped = ""

## Some systems define this to request special libraries.
LIBS_SYSTEM = ""

## -lm, or empty.
LIB_MATH = "-lm"

## -lpthread, or empty.
LIB_PTHREAD = "-lpthread"

LIBIMAGE = "-ltiff -ljpeg -lpng16 -lgif -lXpm"

FONTCONFIG_CFLAGS = "-I/usr/include/uuid -I/usr/include/freetype2 -I/usr/include/libpng16"
FONTCONFIG_LIBS = "-lfontconfig -lfreetype"
FREETYPE_CFLAGS = "-I/usr/include/freetype2 -I/usr/include/libpng16"
FREETYPE_LIBS = "-lfreetype"
LIBOTF_CFLAGS = ""
LIBOTF_LIBS = ""
M17N_FLT_CFLAGS = ""
M17N_FLT_LIBS = ""

LIB_ACL= ""
LIB_CLOCK_GETTIME= ""
LIB_EACCESS= ""
LIB_FDATASYNC= ""
LIB_TIMER_TIME = "-lrt"

DBUS_CFLAGS = ""
DBUS_LIBS = ""

## xwidgets.o if HAVE_XWIDGETS, else empty.

LIB_EXECINFO= ""

SETTINGS_CFLAGS = ""
SETTINGS_LIBS = ""

LIBSYSTEMD_CFLAGS = ""

## inotify.o if HAVE_INOTIFY.
## kqueue.o if HAVE_KQUEUE.
## gfilenotify.o if HAVE_GFILENOTIFY.
## w32notify.o if HAVE_W32NOTIFY.
NOTIFY_CFLAGS = ""

LIBGNUTLS_CFLAGS = ""

# MYCPPFLAGS is for by-hand Emacs-specific overrides, e.g.,
# "make MYCPPFLAGS='-DDBUS_DEBUG'".
MYCPPFLAGS = ""

@emacs_cflags = []
@emacs_cflags = @emacs_cflags + ["-Demacs"]
@emacs_cflags = @emacs_cflags + [MYCPPFLAGS]
@emacs_cflags = @emacs_cflags + ["-I."]
@emacs_cflags = @emacs_cflags + ["-I#{srcdir}"]
@emacs_cflags = @emacs_cflags + ["-I#{lib}"]
@emacs_cflags = @emacs_cflags + ["-I#{top_srcdir}/lib"]
@emacs_cflags = @emacs_cflags + [C_SWITCH_MACHINE]
@emacs_cflags = @emacs_cflags + [C_SWITCH_SYSTEM]
@emacs_cflags = @emacs_cflags + [C_SWITCH_X_SITE]
@emacs_cflags = @emacs_cflags + [GNUSTEP_CFLAGS]
@emacs_cflags = @emacs_cflags + [CFLAGS_SOUND]
@emacs_cflags = @emacs_cflags + [RSVG_CFLAGS]
@emacs_cflags = @emacs_cflags + [IMAGEMAGICK_CFLAGS]
@emacs_cflags = @emacs_cflags + [PNG_CFLAGS]
@emacs_cflags = @emacs_cflags + [LIBXML2_CFLAGS]
@emacs_cflags = @emacs_cflags + [DBUS_CFLAGS]
@emacs_cflags = @emacs_cflags + [XRANDR_CFLAGS]
@emacs_cflags = @emacs_cflags + [XINERAMA_CFLAGS]
@emacs_cflags = @emacs_cflags + [XFIXES_CFLAGS]
@emacs_cflags = @emacs_cflags + [XDBE_CFLAGS]
@emacs_cflags = @emacs_cflags + [WEBKIT_CFLAGS]
@emacs_cflags = @emacs_cflags + [LCMS2_CFLAGS]
@emacs_cflags = @emacs_cflags + [SETTINGS_CFLAGS]
@emacs_cflags = @emacs_cflags + [FREETYPE_CFLAGS]
@emacs_cflags = @emacs_cflags + [FONTCONFIG_CFLAGS]
@emacs_cflags = @emacs_cflags + [LIBOTF_CFLAGS]
@emacs_cflags = @emacs_cflags + [M17N_FLT_CFLAGS]
@emacs_cflags = @emacs_cflags + [DEPFLAGS]
@emacs_cflags = @emacs_cflags + [LIBSYSTEMD_CFLAGS]
@emacs_cflags = @emacs_cflags + [LIBGNUTLS_CFLAGS]
@emacs_cflags = @emacs_cflags + [NOTIFY_CFLAGS]
@emacs_cflags = @emacs_cflags + [CAIRO_CFLAGS]
@emacs_cflags = @emacs_cflags + [WERROR_CFLAGS]


NON_OBJC_CFLAGS = "-Wignored-attributes -Wignored-qualifiers -Wopenmp-simd"
