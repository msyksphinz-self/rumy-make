#!/usr/env/bin ruby

load "rumy-main.rb"
load './build_options.rb'

EXEEXT = ""

srcdir     = "."
top_srcdir = ".."
lispsource = top_srcdir + "/lisp"

lib         = "../lib"
libsrc      = "../lib-src"
etc         = "../etc"
oldXMenudir = "../oldXMenu"
lwlibdir    = "../lwlib"

charsets = top_srcdir + "/admin/charsets/charsets.stamp"

RUN_TEMACS = "./temacs"
BUILD_DETAILS = ""

oldXMenudir = "../oldXMenu"

LIBXMENU = oldXMenudir + "/libXMenu11.a"

FIRSTFILE_OBJ  = []
VMLIMIT_OBJ    = []
TERMCAP_OBJ    = ["terminfo.o"]
PRE_ALLOC_OBJ  = ["lastfile.o"]
GMALLOC_OBJ    = ["gmalloc.o"]
RALLOC_OBJ     = []
POST_ALLOC_OBJ = []
WIDGET_OBJ     = []
LIBOBJS        = []
XMENU_OBJ     = ["xmenu.o"]
CM_OBJ        = ["cm.o"]
XOBJ          = ["xterm.o", "xfns.o", "xselect.o", "xrdb.o", "xsmfns.o", "xsettings.o"]
GTK_OBJ       = []
DBUS_OBJ      = []
MODULES_OBJ   = []
UNEXEC_OBJ    = ["unexelf.o"]
NOTIFY_OBJ    = ["inotify.o"]
XWIDGETS_OBJ  = []
NS_OBJC_OBJ   = []
GNU_OBJC_CFLAGS = ""

LIBGPM            = ""
LIBSELINUX_LIBS   = "-lselinux"
LIBGNUTLS_LIBS    = ""
LIBSYSTEMD_LIBS   = ""
INTERVALS_H       = "dispextern.h intervals.h composite.h"
GETLOADAVG_LIBS   = ""
NOTIFY_LIBS       = ""
# Whether builds should contain details. '--no-build-details' or empty.
CANNOT_DUMP       = false
## -ltermcap, or -lncurses, or -lcurses, or "".
LIBS_TERMCAP      = "-ltinfo"
## terminfo.o if TERMINFO, else (on MS-DOS only: termcap.o +) tparam.o.
LIBXMU            = ""
LIBXSM            = "-lSM -lICE"
LIBXTR6           = ""

otherobj       = TERMCAP_OBJ + PRE_ALLOC_OBJ + GMALLOC_OBJ + RALLOC_OBJ + \
                 POST_ALLOC_OBJ + WIDGET_OBJ + LIBOBJS

HYBRID_MALLOC = 1

base_obj = ["dispnew.o", "frame.o", "scroll.o", "xdisp.o", "menu.o", XMENU_OBJ, "window.o",
	    "charset.o", "coding.o", "category.o", "ccl.o", "character.o", "chartab.o", "bidi.o",
	    CM_OBJ, "term.o", "terminal.o", "xfaces.o", XOBJ, GTK_OBJ, DBUS_OBJ,
	    "emacs.o", "keyboard.o", "macros.o", "keymap.o", "sysdep.o",
	    "buffer.o", "filelock.o", "insdel.o", "marker.o",
	    "minibuf.o", "fileio.o", "dired.o",
	    "cmds.o", "casetab.o", "casefiddle.o", "indent.o", "search.o", "regex.o", "undo.o",
	    "alloc.o", "data.o", "doc.o", "editfns.o", "callint.o",
	    "eval.o", "floatfns.o", "fns.o", "font.o", "print.o", "lread.o", MODULES_OBJ,
	    "syntax.o", UNEXEC_OBJ, "bytecode.o",
	    "process.o", "gnutls.o", "callproc.o",
	    "region-cache.o", "sound.o", "atimer.o",
	    "doprnt.o", "intervals.o", "textprop.o", "composite.o", "xml.o", "lcms.o", NOTIFY_OBJ,
	    XWIDGETS_OBJ,
	    "profiler.o", "decompress.o",
	    "thread.o", "systhread.o"] + if HYBRID_MALLOC then ["sheap.o"] else [] end

obj = base_obj + NS_OBJC_OBJ

ALLOBJS        = FIRSTFILE_OBJ + VMLIMIT_OBJ + obj + otherobj

LIBEGNU_ARCHIVE = lib + "/lib" + if HYBRID_MALLOC then "e" else "" end + "gnu.a"

lispintdir = lispsource + "/international"

charsets = top_srcdir + "/admin/charsets/charsets.stamp"
charscript = lispintdir + "/charscript.el"

CC     = "gcc"
CFLAGS = "-g3 -O2"
LDFLAGS = ""
ALL_CFLAGS = @emacs_cflags.join(' ').to_s + WARN_CFLAGS + CFLAGS
W32_RES_LINK = ""

# ALL_OBJC_CFLAGS = EMACS_CFLAGS + \
#   $(filter-out NON_OBJC_CFLAGS,$(WARN_CFLAGS)) + CFLAGS + GNU_OBJC_CFLAGS
ALL_OBJC_CFLAGS = @emacs_cflags.join(' ').to_s + WARN_CFLAGS + CFLAGS + GNU_OBJC_CFLAGS
EMACSRES = ""

LIBS     = ""
W32_LIBS = ""

## Used only for GNUstep.
LD_SWITCH_X_SITE= ""
LIBS_GNUSTEP = ""

XCB_LIBS   = ""
XFT_LIBS   = "-lXrender -lXft"
LIBX_EXTRA = "-lX11" + XCB_LIBS + XFT_LIBS
LIBXT_OTHER = LIBXSM
TOOLKIT_LIBW = ""
## Only used if HAVE_X11, in LIBX_OTHER.
LIBXT=TOOLKIT_LIBW + LIBXT_OTHER
## If HAVE_X11, $(LIBXT) $(LIBX_EXTRA), else empty.
LIBX_OTHER=LIBXT + LIBX_EXTRA
LIBX_BASE=LIBXMENU + LD_SWITCH_X_SITE

LIBSOUND           = ""
RSVG_LIBS          = ""
WEBKIT_LIBS        = ""
CAIRO_LIBS         = ""
IMAGEMAGICK_LIBS   = ""
LIBXML2_LIBS       = ""
LCMS2_LIBS         = ""
LIBZ               = "-lz"
XRANDR_LIBS        = ""
XINERAMA_LIBS      = ""
XFIXES_LIBS        = ""
XDBE_LIBS          = "-lXext"
GETADDRINFO_A_LIBS = "-lanl"
LIBMODULES         = ""

shortlisp = ["loaddefs.el", "loadup.el"]
lisp = shortlisp.map{|t| lispsource + t}

## Construct full set of libraries to be linked.
libes = []
libes = libes + [LIBS]
libes = libes + [W32_LIBS]
libes = libes + [LIBS_GNUSTEP]
libes = libes + [LIBX_BASE]
libes = libes + [LIBIMAGE]
libes = libes + [LIBX_OTHER]
libes = libes + [LIBSOUND]
libes = libes + [RSVG_LIBS]
libes = libes + [IMAGEMAGICK_LIBS]
libes = libes + [LIB_ACL]
libes = libes + [LIB_CLOCK_GETTIME]
libes = libes + [WEBKIT_LIBS]
libes = libes + [LIB_EACCESS]
libes = libes + [LIB_FDATASYNC]
libes = libes + [LIB_TIMER_TIME]
libes = libes + [DBUS_LIBS]
libes = libes + [LIB_EXECINFO]
libes = libes + [XRANDR_LIBS]
libes = libes + [XINERAMA_LIBS]
libes = libes + [XFIXES_LIBS]
libes = libes + [XDBE_LIBS]
libes = libes + [LIBXML2_LIBS]
libes = libes + [LIBGPM]
libes = libes + [LIBS_SYSTEM]
libes = libes + [CAIRO_LIBS]
libes = libes + [LIBS_TERMCAP]
libes = libes + [GETLOADAVG_LIBS]
libes = libes + [SETTINGS_LIBS]
libes = libes + [LIBSELINUX_LIBS]
libes = libes + [FREETYPE_LIBS]
libes = libes + [FONTCONFIG_LIBS]
libes = libes + [LIBOTF_LIBS]
libes = libes + [M17N_FLT_LIBS]
libes = libes + [LIBGNUTLS_LIBS]
libes = libes + [LIB_PTHREAD]
libes = libes + [GETADDRINFO_A_LIBS]
libes = libes + [LCMS2_LIBS]
libes = libes + [NOTIFY_LIBS]
libes = libes + [LIB_MATH]
libes = libes + [LIBZ]
libes = libes + [LIBMODULES]
libes = libes + [LIBSYSTEMD_LIBS]

make_target "temacs" + EXEEXT do
  depends [LIBXMENU, ALLOBJS, LIBEGNU_ARCHIVE, EMACSRES, charsets, charscript]
  executes ["#{CC} #{ALL_CFLAGS} #{TEMACS_LDFLAGS} #{LDFLAGS} -o temacs #{ALLOBJS.join(' ').to_s} #{LIBEGNU_ARCHIVE} #{W32_RES_LINK} #{@libes}"]
  executes ["mkdir -p #{etc}"]
end

make_target charsets do
  executes ["make -C ../admin/charsets all"]
end

make_target charscript do
  target_name = File.basename(name)
  executes ["make -C ../admin/unidata #{target_name}"]
end

make_target "emacs" + EXEEXT do
  depends ["temacs" + EXEEXT, "lisp.mk" "#{etc}/DOC", "#{lisp}",
           "#{lispsource}/international/charprop.el" "#{charsets}"]
  executes ["unset EMACS_HEAP_EXEC; LC_ALL=C #{RUN_TEMACS} -batch #{BUILD_DETAILS} -l loadup dump"]
  executes ["ln -f #{name} bootstrap-emacs"]
end

config_h = ["config.h", srcdir + "/conf_post.h"]

make_target "atimer.o" do
  executes ["#{CC} #{ALL_CFLAGS} -c #{name} #{name.sub(".o", ".c")}"]
  depends ["atimer.c", "atimer.h", "syssignal.h", "systime.h", "lisp.h", "blockinput.h",
           "globals.h", "../lib/unistd.h", "msdos.h", config_h]
end
make_target "bidi.o" do
  executes ["#{CC} #{ALL_CFLAGS} -c #{name} #{name.sub(".o", ".c")}"]
  depends ["bidi.c", "buffer.h", "character.h", "dispextern.h", "msdos.h", "lisp.h",
           "globals.h", config_h]
end
make_target "buffer.o" do
  executes ["#{CC} #{ALL_CFLAGS} -c #{name} #{name.sub(".o", ".c")}"]
  depends ["buffer.c", "buffer.h", "region-cache.h", "commands.h", "window.h",
           INTERVALS_H, "blockinput.h", "atimer.h", "systime.h", "character.h", "../lib/unistd.h",
           "indent.h", "keyboard.h", "coding.h", "keymap.h", "frame.h", "lisp.h", "globals.h", config_h]
end
make_target "callint.o" do
  executes ["#{CC} #{ALL_CFLAGS} -c #{name} #{name.sub(".o", ".c")}"]
  depends ["callint.c", "window.h", "commands.h", "buffer.h", "keymap.h", "globals.h", "msdos.h",
           "keyboard.h", "dispextern.h", "systime.h", "coding.h", "composite.h", "lisp.h",
           "character.h", config_h]
end
make_target "callproc.o" do
  executes ["#{CC} #{ALL_CFLAGS} -c #{name} #{name.sub(".o", ".c")}"]
  depends ["callproc.c", "epaths.h", "buffer.h", "commands.h", "lisp.h", config_h,
           "process.h", "systty.h", "syssignal.h", "character.h", "coding.h", "ccl.h", "msdos.h",
           "composite.h", "w32.h", "blockinput.h", "atimer.h", "systime.h", "frame.h", "termhooks.h",
           "buffer.h", "gnutls.h", "dispextern.h", "../lib/unistd.h", "globals.h"]
end
make_target "casefiddle.o" do
  depends ["casefiddle.c", "syntax.h", "commands.h", "buffer.h", "character.h",
           "composite.h", "keymap.h", "lisp.h", "globals.h", config_h]
end
make_target "casetab.o" do
  depends ["casetab.c", "buffer.h", "character.h", "lisp.h", "globals.h", config_h]
end
make_target "category.o" do
  depends ["category.c", "category.h", "buffer.h", "charset.h", "keymap.h",
           "character.h", "lisp.h", "globals.h", config_h]
end
make_target "ccl.o" do
  depends ["ccl.c", "ccl.h", "charset.h", "character.h", "coding.h", "composite.h", "lisp.h",
           "globals.h", config_h]
end
make_target "character.o" do
  depends ["character.c", "character.h", "buffer.h", "charset.h", "composite.h", "disptab.h",
           "lisp.h", "globals.h", config_h]
end
make_target "charset.o" do
  depends ["charset.c", "charset.h", "character.h", "buffer.h", "coding.h", "composite.h",
           "disptab.h", "lisp.h", "globals.h", "../lib/unistd.h", config_h]
end
make_target "chartab.o" do
  depends ["charset.h", "character.h", "ccl.h", "lisp.h", "globals.h", config_h]
end
make_target "coding.o" do
  depends ["coding.c", "coding.h", "ccl.h", "buffer.h", "character.h", "charset.h", "composite.h",
           "window.h", "dispextern.h", "msdos.h", "frame.h", "termhooks.h",
           "lisp.h", "globals.h", config_h]
end
make_target "cm.o" do
  depends ["cm.c", "frame.h", "cm.h", "termhooks.h", "termchar.h", "dispextern.h", "msdos.h",
           "tparam.h", "lisp.h", "globals.h", config_h]
end
make_target "cmds.o" do
  depends ["cmds.c", "syntax.h", "buffer.h", "character.h", "commands.h", "window.h", "lisp.h",
           "globals.h", config_h, "msdos.h", "dispextern.h", "keyboard.h", "keymap.h", "systime.h",
           "coding.h", "frame.h", "composite.h"]
end
make_target "pre-crt0.o" do
  depends ["pre-crt0.c"]
end
make_target "dbusbind.o" do
  depends ["dbusbind.c", "termhooks.h", "frame.h", "keyboard.h", "lisp.h", config_h]
end
make_target "dired.o" do
  depends ["dired.c", "commands.h", "buffer.h", "lisp.h", config_h, "character.h", "charset.h",
           "coding.h", "regex.h", "systime.h", "blockinput.h", "atimer.h", "composite.h",
           "../lib/filemode.h", "../lib/unistd.h", "globals.h"]
end
make_target "dispnew.o" do
  depends ["dispnew.c", "systime.h", "commands.h", "process.h", "frame.h", "coding.h",
           "window.h", "buffer.h", "termchar.h", "termopts.h", "termhooks.h", "cm.h",
           "disptab.h", "indent.h", "INTERVALS_H nsgui.h", "../lib/unistd.h",
           "xterm.h", "blockinput.h", "atimer.h", "character.h", "msdos.h", "keyboard.h",
           "syssignal.h", "gnutls.h", "lisp.h", "globals.h", config_h]
end
# doc.o's dependency on buildobj.h", "is in src/Makefile.in.
make_target "doc.o" do
  depends ["doc.c", "lisp.h", config_h, "buffer.h", "keyboard.h", "keymap.h",
           "character.h", "systime.h", "coding.h", "composite.h", "../lib/unistd.h", "globals.h"]
end
make_target "doprnt.o" do
  depends ["doprnt.c", "character.h", "lisp.h", "globals.h", "../lib/unistd.h", config_h]
end
make_target "dosfns.o" do
  depends ["buffer.h", "termchar.h", "termhooks.h", "frame.h", "blockinput.h", "window.h",
           "msdos.h", "dosfns.h", "dispextern.h", "charset.h", "coding.h", "atimer.h", "systime.h",
           "lisp.h", config_h]
end
make_target "editfns.o" do
  depends ["editfns.c", "window.h", "buffer.h", "systime.h", "INTERVALS_H character.h",
           "coding.h", "frame.h", "blockinput.h", "atimer.h",
           "../lib/intprops.h", "../lib/strftime.h", "../lib/unistd.h",
           "lisp.h", "globals.h", config_h]
end
make_target "emacs.o" do
  depends ["emacs.c", "commands.h", "systty.h", "syssignal.h", "blockinput.h", "process.h",
           "termhooks.h", "buffer.h", "atimer.h", "systime.h", "INTERVALS_H lisp.h", config_h,
           "globals.h", "../lib/unistd.h", "window.h", "dispextern.h", "keyboard.h", "keymap.h",
           "frame.h", "coding.h", "gnutls.h", "msdos.h", "dosfns.h", "unexec.h"]
end
make_target "fileio.o" do
  depends ["fileio.c", "window.h", "buffer.h", "systime.h", INTERVALS_H, "character.h",
           "coding.h", "msdos.h", "blockinput.h", "atimer.h", "lisp.h", config_h, "frame.h",
           "commands.h", "globals.h", "../lib/unistd.h"]
end
make_target "filelock.o" do
  depends ["filelock.c", "buffer.h", "character.h", "coding.h", "systime.h", "composite.h",
           "../lib/unistd.h", "lisp.h", "globals.h", config_h]
end
make_target "font.o" do
  depends ["font.c", "dispextern.h", "frame.h", "window.h", "ccl.h", "character.h", "charset.h",
           "font.h", "lisp.h", "globals.h", config_h, "buffer.h", "composite.h", "fontset.h",
           "xterm.h", "nsgui.h", "msdos.h"]
end
make_target "fontset.o" do
  depends ["fontset.c", "fontset.h", "ccl.h", "buffer.h", "character.h",
           "charset.h", "frame.h", "keyboard.h", "termhooks.h", "font.h", "lisp.h", config_h,
           "blockinput.h", "atimer.h", "systime.h", "coding.h", "INTERVALS_H nsgui.h",
           "window.h", "xterm.h", "globals.h"]
end
make_target "frame.o" do
  depends ["frame.c", "xterm.h", "window.h", "frame.h", "termhooks.h", "commands.h", "keyboard.h",
           "blockinput.h", "atimer.h", "systime.h", "buffer.h", "character.h", "fontset.h", "font.h",
           "msdos.h", "dosfns.h", "dispextern.h", "w32term.h", "nsgui.h", "termchar.h", "coding.h",
           "composite.h", "lisp.h", "globals.h", config_h, "termhooks.h", "ccl.h"]
end
make_target "fringe.o" do
  depends ["fringe.c", "dispextern.h", "nsgui.h", "frame.h", "window.h", "buffer.h", "termhooks.h",
           "blockinput.h", "atimer.h", "systime.h", "lisp.h", "globals.h", config_h]
end
make_target "ftfont.o" do
  depends ["ftfont.c", "dispextern.h", "frame.h", "character.h", "charset.h", "composite.h",
           "font.h", "lisp.h", config_h, "blockinput.h", "atimer.h", "systime.h", "coding.h",
           "fontset.h", "ccl.h", "ftfont.h", "globals.h"]
end
make_target "gnutls.o" do
  depends ["gnutls.c", "gnutls.h", "process.h", "../lib/unistd.h",
           "lisp.h", "globals.h", config_h]
end
make_target "gtkutil.o" do
  depends ["gtkutil.c", "gtkutil.h", "xterm.h", "lisp.h", "frame.h", "lisp.h", config_h,
           "blockinput.h", "window.h", "atimer.h", "systime.h", "termhooks.h", "keyboard.h", "charset.h",
           "coding.h", "syssignal.h", "dispextern.h", "composite.h", "globals.h", "xsettings.h"]
end
make_target "image.o" do
  depends ["image.c", "frame.h", "window.h", "dispextern.h", "blockinput.h", "atimer.h",
           "systime.h", "xterm.h", "w32term.h", "w32gui.h", "font.h", "epaths.h", "character.h", "coding.h",
           "nsterm.h", "nsgui.h", "../lib/unistd.h", "lisp.h", "globals.h", config_h, "composite.h", "termhooks.h", "ccl.h"]
end
make_target "indent.o" do
  depends ["indent.c", "frame.h", "window.h", "indent.h", "buffer.h", "lisp.h", config_h,
           "termchar.h", "termopts.h", "disptab.h", "region-cache.h", "character.h", "category.h",
           "keyboard.h", "systime.h", "coding.h", "INTERVALS_H globals.h"]
end
make_target "inotify.o" do
  depends ["inotify.c", "lisp.h", "coding.h", "process.h", "keyboard.h", "frame.h", "termhooks.h"]
end
make_target "insdel.o" do
  depends ["insdel.c", "window.h", "buffer.h", "INTERVALS_H blockinput.h", "character.h",
           "atimer.h", "systime.h", "region-cache.h", "lisp.h", "globals.h", config_h]
end
make_target "keyboard.o" do
  depends ["keyboard.c", "termchar.h", "termhooks.h", "termopts.h", "buffer.h", "character.h",
           "commands.h", "frame.h", "window.h", "macros.h", "disptab.h", "keyboard.h", "syssignal.h",
           "systime.h", "syntax.h", "INTERVALS_H blockinput.h", "atimer.h", "composite.h",
           "xterm.h", "puresize.h", "msdos.h", "keymap.h", "w32term.h", "nsterm.h", "nsgui.h", "coding.h",
           "process.h", "../lib/unistd.h", "gnutls.h", "lisp.h", "globals.h", config_h]
end
make_target "keymap.o" do
  depends ["keymap.c", "buffer.h", "commands.h", "keyboard.h", "termhooks.h", "blockinput.h",
           "atimer.h", "systime.h", "puresize.h", "character.h", "charset.h", INTERVALS_H,
           "keymap.h", "window.h", "coding.h", "frame.h", "lisp.h", "globals.h", config_h]
end
make_target "lastfile.o" do
  depends ["lastfile.c", config_h]
end
make_target "macros.o" do
  depends ["macros.c", "window.h", "buffer.h", "commands.h", "macros.h", "keyboard.h", "msdos.h",
           "dispextern.h", "lisp.h", "globals.h", config_h, "systime.h", "coding.h", "composite.h"]
end
make_target "gmalloc.o" do
  executes ["#{CC} #{ALL_CFLAGS} -c #{name} #{name.sub(".o", ".c")}"]
  depends ["gmalloc.c", config_h]
end
make_target "ralloc.o" do
  depends ["ralloc.c", "lisp.h", config_h]
end
make_target "vm-limit.o" do
  depends ["vm-limit.c", "lisp.h", "globals.h", config_h]
end
make_target "marker.o" do
  depends ["marker.c", "buffer.h", "character.h", "lisp.h", "globals.h", config_h]
end
make_target "minibuf.o" do
  depends ["minibuf.c", "syntax.h", "frame.h", "window.h", "keyboard.h", "systime.h",
           "buffer.h", "commands.h", "character.h", "msdos.h", "INTERVALS_H keymap.h",
           "termhooks.h", "lisp.h", "globals.h", config_h, "coding.h"]
end
make_target "msdos.o" do
  depends ["msdos.c", "msdos.h", "dosfns.h", "systime.h", "termhooks.h", "dispextern.h", "frame.h",
           "termopts.h", "termchar.h", "character.h", "coding.h", "ccl.h", "disptab.h", "window.h",
           "keyboard.h", INTERVALS_H, "buffer.h", "commands.h", "blockinput.h", "atimer.h",
           "lisp.h", "sysselect.h", config_h]
end
make_target "nsfns.o" do
  depends ["nsfns.m charset.h", "nsterm.h", "nsgui.h", "frame.h", "window.h", "buffer.h",
           "dispextern.h", "fontset.h", INTERVALS_H, "keyboard.h", "blockinput.h",
           "atimer.h", "systime.h", "epaths.h", "termhooks.h", "coding.h", "systime.h", "lisp.h", config_h]
end
make_target "nsfont.o" do
  depends ["nsterm.h", "dispextern.h", "frame.h", "lisp.h", "lisp.h", config_h]
end
make_target "nsimage.o" do
  depends ["nsimage.m nsterm.h", "lisp.h", config_h]
end
make_target "nsmenu.o" do
  depends ["nsmenu.m termhooks.h", "frame.h", "window.h", "dispextern.h",
           "nsgui.h", "keyboard.h", "blockinput.h", "atimer.h", "systime.h", "buffer.h",
           "nsterm.h", "lisp.h", config_h]
end
make_target "nsterm.o" do
  depends ["nsterm.m blockinput.h", "atimer.h", "systime.h", "syssignal.h", "nsterm.h",
           "nsgui.h", "frame.h", "charset.h", "ccl.h", "dispextern.h", "fontset.h", "termhooks.h",
           "termopts.h", "termchar.h", "disptab.h", "buffer.h", "window.h", "keyboard.h",
           INTERVALS_H, "process.h", "coding.h", "lisp.h", config_h]
end
make_target "nsselect.o" do
  depends ["nsselect.m blockinput.h", "nsterm.h", "nsgui.h", "frame.h", "lisp.h", config_h]
end
make_target "process.o" do
  depends ["process.c", "process.h", "buffer.h", "window.h", "termhooks.h", "termopts.h",
           "commands.h", "syssignal.h", "systime.h", "systty.h", "syswait.h", "frame.h", "dispextern.h",
           "blockinput.h", "atimer.h", "coding.h", "msdos.h", "nsterm.h", "composite.h",
           "keyboard.h", "lisp.h", "globals.h", config_h, "character.h", "xgselect.h", "sysselect.h",
           "../lib/unistd.h", "gnutls.h"]
end
make_target "regex.o" do
  depends ["regex.c", "syntax.h", "buffer.h", "lisp.h", "globals.h", config_h, "regex.h",
           "category.h", "character.h"]
end
make_target "region-cache.o" do
  depends ["region-cache.c", "buffer.h", "region-cache.h",
           "lisp.h", "globals.h", config_h]
end
make_target "scroll.o" do
  depends ["scroll.c", "termchar.h", "dispextern.h", "frame.h", "msdos.h", "keyboard.h",
           "termhooks.h", "lisp.h", "globals.h", config_h, "systime.h", "coding.h", "composite.h",
           "window.h"]
end
make_target "search.o" do
  depends ["search.c", "regex.h", "commands.h", "buffer.h", "region-cache.h", "syntax.h",
           "blockinput.h", "atimer.h", "systime.h", "category.h", "character.h", "charset.h",
           INTERVALS_H, "lisp.h", "globals.h", config_h]
end
make_target "sound.o" do
  depends ["sound.c", "dispextern.h", "syssignal.h", "lisp.h", "globals.h", config_h, "atimer.h", "systime.h", "../lib/unistd.h", "msdos.h"]
end
make_target "syntax.o" do
  depends ["syntax.c", "syntax.h", "buffer.h", "commands.h", "category.h", "character.h",
           "keymap.h", "regex.h", INTERVALS_H, "lisp.h", "globals.h", config_h]
end
make_target "sysdep.o" do
  depends ["sysdep.c", "syssignal.h", "systty.h", "systime.h", "syswait.h", "blockinput.h",
           "process.h", "dispextern.h", "termhooks.h", "termchar.h", "termopts.h", "coding.h",
           "frame.h", "atimer.h", "window.h", "msdos.h", "dosfns.h", "keyboard.h", "cm.h", "lisp.h",
           "globals.h", config_h, "composite.h", "sysselect.h", "gnutls.h",
           "../lib/allocator.h", "../lib/careadlinkat.h",
           "../lib/unistd.h"]
end
make_target "term.o" do
  depends ["term.c", "termchar.h", "termhooks.h", "termopts.h", "lisp.h", "globals.h", config_h,
           "cm.h", "frame.h", "disptab.h", "keyboard.h", "character.h", "charset.h", "coding.h", "ccl.h",
           "xterm.h", "msdos.h", "window.h", "keymap.h", "blockinput.h", "atimer.h", "systime.h",
           "systty.h", "syssignal.h", "tparam.h", INTERVALS_H, "buffer.h", "../lib/unistd.h"]
end
make_target "termcap.o" do
  depends ["termcap.c", "lisp.h", "tparam.h", "msdos.h", config_h]
end
make_target "terminal.o" do
  depends ["terminal.c", "frame.h", "termchar.h", "termhooks.h", "charset.h", "coding.h",
           "keyboard.h", "lisp.h", "globals.h", config_h, "dispextern.h", "composite.h", "systime.h",
           "msdos.h"]
end
make_target "terminfo.o" do
  depends ["terminfo.c", "tparam.h", "lisp.h", "globals.h", config_h]
end
make_target "tparam.o" do
  depends ["tparam.c", "tparam.h", "lisp.h", config_h]
end
make_target "undo.o" do
  depends ["undo.c", "buffer.h", "commands.h", "window.h", "dispextern.h", "msdos.h",
           "lisp.h", "globals.h", config_h]
end
make_target "unexaix.o" do
  depends ["unexaix.c", "lisp.h", "unexec.h", config_h]
end
make_target "unexcw.o" do
  depends ["unexcw.c", "lisp.h", "unexec.h", config_h]
end
make_target "unexcoff.o" do
  depends ["unexcoff.c", "lisp.h", "unexec.h", config_h]
end
make_target "unexelf.o" do
  depends ["unexelf.c", "unexec.h", "../lib/unistd.h", config_h]
end
make_target "unexhp9k800.o" do
  depends ["unexhp9k800.c", "unexec.h", config_h]
end
make_target "unexmacosx.o" do
  depends ["unexmacosx.c", "unexec.h", config_h]
end
make_target "unexsol.o" do
  depends ["unexsol.c", "lisp.h", "unexec.h", config_h]
end
make_target "unexw32.o" do
  depends ["unexw32.c", "unexec.h", config_h]
end
make_target "w16select.o" do
  depends ["w16select.c", "dispextern.h", "frame.h", "blockinput.h", "atimer.h", "systime.h",
           "msdos.h", "buffer.h", "charset.h", "coding.h", "composite.h", "lisp.h", config_h]
end
make_target "widget.o" do
  depends ["widget.c", "xterm.h", "frame.h", "dispextern.h", "widgetprv.h",
           "$(srcdir)/../lwlib/lwlib.h", "lisp.h", config_h]
end
make_target "window.o" do
  depends ["window.c", "indent.h", "commands.h", "frame.h", "window.h", "buffer.h", "termchar.h",
           "disptab.h", "keyboard.h", "msdos.h", "coding.h", "termhooks.h",
           "keymap.h", "blockinput.h", "atimer.h", "systime.h", INTERVALS_H,
           "xterm.h", "w32term.h", "nsterm.h", "nsgui.h", "lisp.h", "globals.h", config_h]
end
make_target "xdisp.o" do
  depends ["xdisp.c", "macros.h", "commands.h", "process.h", "indent.h", "buffer.h",
           "coding.h", "termchar.h", "frame.h", "window.h", "disptab.h", "termhooks.h", "character.h",
           "charset.h", "lisp.h", config_h, "keyboard.h", INTERVALS_H, "region-cache.h",
           "xterm.h", "w32term.h", "nsterm.h", "nsgui.h", "msdos.h", "composite.h", "fontset.h", "ccl.h",
           "blockinput.h", "atimer.h", "systime.h", "keymap.h", "font.h", "globals.h", "termopts.h",
           "../lib/unistd.h", "gnutls.h", "gtkutil.h"]
end
make_target "xfaces.o" do
  depends ["xfaces.c", "frame.h", "xterm.h", "buffer.h", "blockinput.h",
           "window.h", "character.h", "charset.h", "msdos.h", "dosfns.h", "composite.h", "atimer.h",
           "systime.h", "keyboard.h", "fontset.h", "w32term.h", "nsterm.h", "coding.h", "ccl.h",
           INTERVALS_H, "nsgui.h", "termchar.h", "termhooks.h", "font.h",
           "lisp.h", "globals.h", config_h]
end
make_target "xfns.o" do
  depends ["xfns.c", "buffer.h", "frame.h", "window.h", "keyboard.h", "xterm.h",
           "$(srcdir)/../lwlib/lwlib.h", "blockinput.h", "atimer.h", "systime.h", "epaths.h",
           "character.h", "charset.h", "coding.h", "gtkutil.h", "lisp.h", config_h, "termhooks.h",
           "fontset.h", "termchar.h", "font.h", "xsettings.h", INTERVALS_H, "ccl.h", "globals.h",
           "../lib/unistd.h"]
end
make_target "xfont.o" do
  depends ["dispextern.h", "xterm.h", "frame.h", "blockinput.h", "character.h", "charset.h",
           "font.h", "lisp.h", "globals.h", config_h, "atimer.h", "systime.h", "fontset.h", "ccl.h"]
end
make_target "xftfont.o" do
  depends ["xftfont.c", "dispextern.h", "xterm.h", "frame.h", "blockinput.h", "character.h",
           "charset.h", "font.h", "lisp.h", "globals.h", config_h, "atimer.h", "systime.h",
           "fontset.h", "ccl.h", "ftfont.h", "composite.h"]
end
make_target "ftxfont.o" do
  depends ["ftxfont.c", "dispextern.h", "xterm.h", "frame.h", "blockinput.h", "character.h",
           "charset.h", "font.h", "lisp.h", "globals.h", config_h, "atimer.h", "systime.h",
           "fontset.h", "ccl.h"]
end
make_target "menu.o" do
  depends ["menu.c", "lisp.h", "keyboard.h", "keymap.h", "frame.h", "termhooks.h", "blockinput.h",
           "dispextern.h", "$(srcdir)/../lwlib/lwlib.h", "xterm.h", "gtkutil.h", "menu.h",
           "lisp.h", "globals.h", config_h, "systime.h", "coding.h", "composite.h", "window.h",
           "atimer.h", "nsterm.h", "w32term.h", "msdos.h"]
end
make_target "xmenu.o" do
  depends ["xmenu.c", "xterm.h", "termhooks.h", "window.h", "dispextern.h", "frame.h", "buffer.h",
           "charset.h", "keyboard.h", "$(srcdir)/../lwlib/lwlib.h", "blockinput.h", "atimer.h",
           "systime.h", "gtkutil.h", "msdos.h", "coding.h", "menu.h", "lisp.h", "globals.h", config_h,
           "composite.h", "keymap.h", "sysselect.h"]
end
make_target "xml.o" do
  depends ["xml.c", "buffer.h", "lisp.h", "globals.h", config_h]
end
make_target "xterm.o" do
  depends ["xterm.c", "xterm.h", "termhooks.h", "termopts.h", "termchar.h", "window.h", "buffer.h",
           "dispextern.h", "frame.h", "disptab.h", "blockinput.h", "atimer.h", "systime.h", "syssignal.h",
           "keyboard.h", "emacs-icon.h", "character.h", "charset.h", "ccl.h", "fontset.h", "composite.h",
           "coding.h", "process.h", "gtkutil.h", "font.h", "fontset.h", "lisp.h", "globals.h", config_h,
           "xsettings.h", "intervals.h", "keymap.h", "xgselect.h", "sysselect.h", "../lib/unistd.h",
           "gnutls.h"]
end
make_target "xselect.o" do
  depends ["xselect.c", "process.h", "dispextern.h", "frame.h", "xterm.h", "blockinput.h",
           "buffer.h", "atimer.h", "systime.h", "termhooks.h", "lisp.h", config_h, "keyboard.h",
           "coding.h", "composite.h", "../lib/unistd.h", "globals.h", "gnutls.h"]
end
make_target "xgselect.o" do
  depends ["xgselect.h", "systime.h", "sysselect.h", "lisp.h", "globals.h", config_h]
end
make_target "xrdb.o" do
  depends ["xrdb.c", "lisp.h", "globals.h", config_h, "epaths.h", "../lib/unistd.h"]
end
make_target "xsmfns.o" do
  depends ["xsmfns.c", "lisp.h", config_h, "systime.h", "sysselect.h", "termhooks.h",
           "xterm.h", "lisp.h", "termopts.h", "frame.h", "dispextern.h", "../lib/unistd.h", "globals.h",
           "gnutls.h", "keyboard.h", "coding.h", "composite.h"]
end
make_target "xsettings.o" do
  depends ["xterm.h", "xsettings.h", "lisp.h", "frame.h", "termhooks.h", config_h,
           "dispextern.h", "keyboard.h", "systime.h", "coding.h", "composite.h", "blockinput.h",
           "atimer.h", "termopts.h", "globals.h"]
end
## The files of Lisp proper.
make_target "alloc.o" do
  depends ["alloc.c", "process.h", "frame.h", "window.h", "buffer.h", " puresize.h", "syssignal.h",
           "keyboard.h", "blockinput.h", "atimer.h", "systime.h", "character.h", "lisp.h", config_h,
           INTERVALS_H, "termhooks.h", "gnutls.h", "coding.h", "../lib/unistd.h", "globals.h"]
end
make_target "bytecode.o" do
  depends ["bytecode.c", "buffer.h", "syntax.h", "character.h", "window.h", "dispextern.h",
           "lisp.h", "globals.h", config_h, "msdos.h"]
end
make_target "data.o" do
  depends ["data.c", "buffer.h", "puresize.h", "character.h", "syssignal.h", "keyboard.h", "frame.h",
           "termhooks.h", "systime.h", "coding.h", "composite.h", "dispextern.h", "font.h", "ccl.h",
           "lisp.h", "globals.h", config_h, "msdos.h"]
end
make_target "eval.o" do
  depends ["eval.c", "commands.h", "keyboard.h", "blockinput.h", "atimer.h", "systime.h", "frame.h",
           "dispextern.h", "lisp.h", "globals.h", config_h, "coding.h", "composite.h", "xterm.h",
           "msdos.h"]
end
make_target "floatfns.o" do
  depends ["floatfns.c", "syssignal.h", "lisp.h", "globals.h", config_h]
end
make_target "fns.o" do
  depends ["fns.c", "commands.h", "lisp.h", config_h, "frame.h", "buffer.h", "character.h",
           "keyboard.h", "keymap.h", "window.h", INTERVALS_H, "coding.h", "../lib/md5.h",
           "../lib/sha1.h", "../lib/sha256.h", "../lib/sha512.h", "blockinput.h", "atimer.h",
           "systime.h", "xterm.h", "../lib/unistd.h", "globals.h"]
end
make_target "print.o" do
  depends ["print.c", "process.h", "frame.h", "window.h", "buffer.h", "keyboard.h", "character.h",
           "lisp.h", "globals.h", config_h, "termchar.h", INTERVALS_H, "msdos.h", "termhooks.h",
           "blockinput.h", "atimer.h", "systime.h", "font.h", "charset.h", "coding.h", "ccl.h",
           "gnutls.h", "../lib/unistd.h", "../lib/ftoastr.h", "../lib/intprops.h"]
end
make_target "lread.o" do
  depends ["lread.c", "commands.h", "keyboard.h", "buffer.h", "epaths.h", "character.h",
           "charset.h", "lisp.h", "globals.h", config_h, INTERVALS_H, "termhooks.h",
           "coding.h", "msdos.h", "systime.h", "frame.h", "blockinput.h", "atimer.h", "../lib/unistd.h"]
end
## Text properties support.
make_target "composite.o" do
  depends ["composite.c", "composite.h", "buffer.h", "character.h", "coding.h", "font.h",
           "ccl.h", "frame.h", "termhooks.h", INTERVALS_H, "window.h",
           "lisp.h", "globals.h", config_h]
end
make_target "intervals.o" do
  depends ["intervals.c", "buffer.h", INTERVALS_H, "keyboard.h", "puresize.h",
           "keymap.h", "lisp.h", "globals.h", config_h, "systime.h", "coding.h"]
end
make_target "textprop.o" do
  executes ["#{CC} #{ALL_CFLAGS} -c #{name} #{name.sub(".o", ".c")}"]
  depends ["textprop.c", "buffer.h", "window.h", INTERVALS_H,
           "lisp.h", "globals.h", config_h]
end

make_target :all do
  global
  depends ["emacs" + EXEEXT]
end

puts ALLOBJS
