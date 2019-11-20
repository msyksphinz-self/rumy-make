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
FONT_OBJ      = ["xfont.o", "ftfont.o", "xftfont.o", "ftxfont.o"]
WINDOW_SYSTEM_OBJ=["fontset.o", "fringe.o", "image.o"]
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
LIBGNUTLS_LIBS    = "-lgnutls"
LIBSYSTEMD_LIBS   = ""
INTERVALS_H       = ["dispextern.h", "intervals.h", "composite.h"]
GETLOADAVG_LIBS   = ""
NOTIFY_LIBS       = ""
# Whether builds should contain details. '--no-build-details' or empty.
CANNOT_DUMP       = false
## -ltermcap, or -lncurses, or -lcurses, or "".
LIBS_TERMCAP      = "-ltinfo"
## terminfo.o if TERMINFO, else (on MS-DOS only: termcap.o +) tparam.o.
LIBXMU            = ""
LIBXSM            = ["-lSM", "-lICE"]
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
	    "thread.o", "systhread.o",
            FONT_OBJ, WINDOW_SYSTEM_OBJ
           ] + if HYBRID_MALLOC then ["sheap.o"] else [] end

GLOBAL_SOURCES = base_obj.flatten.map{|obj| obj.sub(".o", ".c") }

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
EMACSRES = []

LIBS     = ""
W32_LIBS = ""

## Used only for GNUstep.
LD_SWITCH_X_SITE= []
LIBS_GNUSTEP = ""

XCB_LIBS   = []
XFT_LIBS   = ["-lXrender", "-lXft"]
LIBX_EXTRA = ["-lX11", XCB_LIBS, XFT_LIBS]
LIBXT_OTHER = LIBXSM
TOOLKIT_LIBW = []
## Only used if HAVE_X11, in LIBX_OTHER.
LIBXT = [TOOLKIT_LIBW, LIBXT_OTHER]
## If HAVE_X11, $(LIBXT) $(LIBX_EXTRA), else empty.
LIBX_OTHER = [LIBXT, LIBX_EXTRA]
LIBX_BASE  = [LIBXMENU, LD_SWITCH_X_SITE]

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
lisp = shortlisp.map{|t| lispsource + "/" + t}

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
  executes ["#{CC} #{ALL_CFLAGS} #{TEMACS_LDFLAGS} #{LDFLAGS} -o temacs #{ALLOBJS.flatten.join(' ').to_s} #{LIBEGNU_ARCHIVE} #{W32_RES_LINK} #{libes.join(' ').to_s}"]
  executes ["mkdir -p #{etc}"]
end

external_make charsets, "../admin/charsets"

make_target charscript do
  target_name = File.basename(name)
  executes ["make -C ../admin/unidata #{target_name}"]
end

SOME_MACHINE_OBJECTS = ["dosfns.o", "msdos.o",
                        "xterm.o", "xfns.o", "xmenu.o", "xselect.o", "xrdb.o", "xsmfns.o", "fringe.o", "image.o",
                        "fontset.o", "dbusbind.o", "cygw32.o",
                        "nsterm.o", "nsfns.o", "nsmenu.o", "nsselect.o", "nsimage.o", "nsfont.o", "macfont.o",
                        "w32.o", "w32console.o", "w32fns.o", "w32heap.o", "w32inevt.o", "w32notify.o",
                        "w32menu.o", "w32proc.o", "w32reg.o", "w32select.o", "w32term.o", "w32xfns.o",
                        "w16select.o", "widget.o", "xfont.o", "ftfont.o", "xftfont.o", "ftxfont.o", "gtkutil.o",
                        "xsettings.o", "xgselect.o", "termcap.o"]

make_target :etc_doc do
  depends ["lisp.mk", "#{libsrc}/make-docfile${EXEEXT}", obj, lisp]
  executes ["$(MKDIR_P) #{etc}"]
  executes ["rm -f #{etc}/DOC"]
  executes ["#{libsrc}/make-docfile -d #{srcdir} \
             #{SOME_MACHINE_OBJECTS.join(' ').to_s} #{obj.join(' ').to_s} > #{etc}/DOC"]
  executes ["#{libsrc}/make-docfile -a #{etc}/DOC -d #{lispsource} #{shortlisp}"]
end

make_target "emacs" + EXEEXT do
  depends ["temacs" + EXEEXT, "lisp.mk", :etc_doc, lisp,
           "#{lispsource}/international/charprop.el", "#{charsets}"]
  executes ["unset EMACS_HEAP_EXEC; LC_ALL=C #{RUN_TEMACS} -batch #{BUILD_DETAILS} -l loadup dump"]
  executes ["ln -f #{name} bootstrap-emacs"]
end

config_h = ["config.h", srcdir + "/conf_post.h"]

make_target "globals.h" do
  depends ["gl-stamp"]
end

make_target "gl-stamp" do
  depends [libsrc + "/make-docfile" + EXEEXT, GLOBAL_SOURCES]
  executes ["#{libsrc}/make-docfile -d #{srcdir} -g #{obj.join(' ').to_s} > globals.tmp"]
  executes ["#{top_srcdir}/build-aux/move-if-change globals.tmp globals.h"]
  executes ["echo timestamp > #{name}"]
end

def make_cpp_target(target, depend_list)
  make_target target do
    executes ["#{CC} #{ALL_CFLAGS} -c #{name.sub(".o", ".c")}"]
    depends [depend_list, "globals.h"]
  end
end

make_cpp_target "atimer.o", ["atimer.c", "atimer.h", "syssignal.h", "systime.h", "lisp.h", "blockinput.h",
                             "globals.h", "../lib/unistd.h", "msdos.h", config_h]
make_cpp_target "bidi.o", ["bidi.c", "buffer.h", "character.h", "dispextern.h", "msdos.h", "lisp.h",
                           "globals.h", config_h]
make_cpp_target "buffer.o", ["buffer.c", "buffer.h", "region-cache.h", "commands.h", "window.h",
                             INTERVALS_H, "blockinput.h", "atimer.h", "systime.h", "character.h", "../lib/unistd.h",
                             "indent.h", "keyboard.h", "coding.h", "keymap.h", "frame.h", "lisp.h", "globals.h", config_h]
make_cpp_target "callint.o", ["callint.c", "window.h", "commands.h", "buffer.h", "keymap.h", "globals.h", "msdos.h",
                              "keyboard.h", "dispextern.h", "systime.h", "coding.h", "composite.h", "lisp.h",
                              "character.h", config_h]
make_cpp_target "callproc.o", ["callproc.c", "epaths.h", "buffer.h", "commands.h", "lisp.h", config_h,
                               "process.h", "systty.h", "syssignal.h", "character.h", "coding.h", "ccl.h", "msdos.h",
                               "composite.h", "w32.h", "blockinput.h", "atimer.h", "systime.h", "frame.h", "termhooks.h",
                               "buffer.h", "gnutls.h", "dispextern.h", "../lib/unistd.h", "globals.h"]
make_cpp_target "casefiddle.o", ["casefiddle.c", "syntax.h", "commands.h", "buffer.h", "character.h",
                                 "composite.h", "keymap.h", "lisp.h", "globals.h", config_h]
make_cpp_target "casetab.o", ["casetab.c", "buffer.h", "character.h", "lisp.h", "globals.h", config_h]
make_cpp_target "category.o", ["category.c", "category.h", "buffer.h", "charset.h", "keymap.h",
                               "character.h", "lisp.h", "globals.h", config_h]
make_cpp_target "ccl.o", ["ccl.c", "ccl.h", "charset.h", "character.h", "coding.h", "composite.h", "lisp.h",
                          "globals.h", config_h]
make_cpp_target "character.o", ["character.c", "character.h", "buffer.h", "charset.h", "composite.h", "disptab.h",
                                "lisp.h", "globals.h", config_h]
make_cpp_target "charset.o", ["charset.c", "charset.h", "character.h", "buffer.h", "coding.h", "composite.h",
                              "disptab.h", "lisp.h", "globals.h", "../lib/unistd.h", config_h]
make_cpp_target "chartab.o", ["charset.h", "character.h", "ccl.h", "lisp.h", "globals.h", config_h]
make_cpp_target "coding.o", ["coding.c", "coding.h", "ccl.h", "buffer.h", "character.h", "charset.h", "composite.h",
                             "window.h", "dispextern.h", "msdos.h", "frame.h", "termhooks.h",
                             "lisp.h", "globals.h", config_h]
make_cpp_target "cm.o", ["cm.c", "frame.h", "cm.h", "termhooks.h", "termchar.h", "dispextern.h", "msdos.h",
                         "tparam.h", "lisp.h", "globals.h", config_h]
make_cpp_target "cmds.o", ["cmds.c", "syntax.h", "buffer.h", "character.h", "commands.h", "window.h", "lisp.h",
                           "globals.h", config_h, "msdos.h", "dispextern.h", "keyboard.h", "keymap.h", "systime.h",
                           "coding.h", "frame.h", "composite.h"]
make_cpp_target "pre-crt0.o", ["pre-crt0.c"]
make_cpp_target "dbusbind.o", ["dbusbind.c", "termhooks.h", "frame.h", "keyboard.h", "lisp.h", config_h]
make_cpp_target "dired.o", ["dired.c", "commands.h", "buffer.h", "lisp.h", config_h, "character.h", "charset.h",
                            "coding.h", "regex.h", "systime.h", "blockinput.h", "atimer.h", "composite.h",
                            "../lib/filemode.h", "../lib/unistd.h", "globals.h"]
make_cpp_target "dispnew.o", ["dispnew.c", "systime.h", "commands.h", "process.h", "frame.h", "coding.h",
                              "window.h", "buffer.h", "termchar.h", "termopts.h", "termhooks.h", "cm.h",
                              "disptab.h", "indent.h", INTERVALS_H, "nsgui.h", "../lib/unistd.h",
                              "xterm.h", "blockinput.h", "atimer.h", "character.h", "msdos.h", "keyboard.h",
                              "syssignal.h", "gnutls.h", "lisp.h", "globals.h", config_h]
# doc.o's dependency on buildobj.h", "is in src/Makefile.in.
make_cpp_target "doc.o", ["buildobj.h", "doc.c", "lisp.h", config_h, "buffer.h", "keyboard.h", "keymap.h",
                          "character.h", "systime.h", "coding.h", "composite.h", "../lib/unistd.h", "globals.h"]
make_target "buildobj.h" do
  depends ["build.rb"]
  executes ["for i in #{ALLOBJS}; do \
            echo $i | sed 's,.*/,,; s/\.obj$/\.o/; s/^/\"/; s/$/\",/' \
	    || exit; \
	done > #{name}.tmp"]
  executes ["mv #{name}.tmp #{name}"]
end
make_cpp_target "doprnt.o", ["doprnt.c", "character.h", "lisp.h", "globals.h", "../lib/unistd.h", config_h]
make_cpp_target "dosfns.o", ["buffer.h", "termchar.h", "termhooks.h", "frame.h", "blockinput.h", "window.h",
                             "msdos.h", "dosfns.h", "dispextern.h", "charset.h", "coding.h", "atimer.h", "systime.h",
                             "lisp.h", config_h]
make_cpp_target "editfns.o", ["editfns.c", "window.h", "buffer.h", "systime.h", INTERVALS_H, "character.h",
                              "coding.h", "frame.h", "blockinput.h", "atimer.h",
                              "../lib/intprops.h", "../lib/strftime.h", "../lib/unistd.h",
                              "lisp.h", "globals.h", config_h]
make_cpp_target "emacs.o", ["emacs.c", "commands.h", "systty.h", "syssignal.h", "blockinput.h", "process.h",
                            "termhooks.h", "buffer.h", "atimer.h", "systime.h", INTERVALS_H, "lisp.h", config_h,
                            "globals.h", "../lib/unistd.h", "window.h", "dispextern.h", "keyboard.h", "keymap.h",
                            "frame.h", "coding.h", "gnutls.h", "msdos.h", "dosfns.h", "unexec.h"]
make_cpp_target "fileio.o", ["fileio.c", "window.h", "buffer.h", "systime.h", INTERVALS_H, "character.h",
                             "coding.h", "msdos.h", "blockinput.h", "atimer.h", "lisp.h", config_h, "frame.h",
                             "commands.h", "globals.h", "../lib/unistd.h"]
make_cpp_target "filelock.o", ["filelock.c", "buffer.h", "character.h", "coding.h", "systime.h", "composite.h",
                               "../lib/unistd.h", "lisp.h", "globals.h", config_h]
make_cpp_target "font.o", ["font.c", "dispextern.h", "frame.h", "window.h", "ccl.h", "character.h", "charset.h",
                           "font.h", "lisp.h", "globals.h", config_h, "buffer.h", "composite.h", "fontset.h",
                           "xterm.h", "nsgui.h", "msdos.h"]
make_cpp_target "fontset.o", ["fontset.c", "fontset.h", "ccl.h", "buffer.h", "character.h",
                              "charset.h", "frame.h", "keyboard.h", "termhooks.h", "font.h", "lisp.h", config_h,
                              "blockinput.h", "atimer.h", "systime.h", "coding.h", INTERVALS_H, "nsgui.h",
                              "window.h", "xterm.h", "globals.h"]
make_cpp_target "frame.o", ["frame.c", "xterm.h", "window.h", "frame.h", "termhooks.h", "commands.h", "keyboard.h",
                            "blockinput.h", "atimer.h", "systime.h", "buffer.h", "character.h", "fontset.h", "font.h",
                            "msdos.h", "dosfns.h", "dispextern.h", "w32term.h", "nsgui.h", "termchar.h", "coding.h",
                            "composite.h", "lisp.h", "globals.h", config_h, "termhooks.h", "ccl.h"]
make_cpp_target "fringe.o", ["fringe.c", "dispextern.h", "nsgui.h", "frame.h", "window.h", "buffer.h", "termhooks.h",
                             "blockinput.h", "atimer.h", "systime.h", "lisp.h", "globals.h", config_h]
make_cpp_target "ftfont.o", ["ftfont.c", "dispextern.h", "frame.h", "character.h", "charset.h", "composite.h",
                             "font.h", "lisp.h", config_h, "blockinput.h", "atimer.h", "systime.h", "coding.h",
                             "fontset.h", "ccl.h", "ftfont.h", "globals.h"]
make_cpp_target "gnutls.o", ["gnutls.c", "gnutls.h", "process.h", "../lib/unistd.h",
                             "lisp.h", "globals.h", config_h]
make_cpp_target "gtkutil.o", ["gtkutil.c", "gtkutil.h", "xterm.h", "lisp.h", "frame.h", "lisp.h", config_h,
                              "blockinput.h", "window.h", "atimer.h", "systime.h", "termhooks.h", "keyboard.h", "charset.h",
                              "coding.h", "syssignal.h", "dispextern.h", "composite.h", "globals.h", "xsettings.h"]
make_cpp_target "image.o", ["image.c", "frame.h", "window.h", "dispextern.h", "blockinput.h", "atimer.h",
                            "systime.h", "xterm.h", "w32term.h", "w32gui.h", "font.h", "epaths.h", "character.h", "coding.h",
                            "nsterm.h", "nsgui.h", "../lib/unistd.h", "lisp.h", "globals.h", config_h, "composite.h", "termhooks.h", "ccl.h"]
make_cpp_target "indent.o", ["indent.c", "frame.h", "window.h", "indent.h", "buffer.h", "lisp.h", config_h,
                             "termchar.h", "termopts.h", "disptab.h", "region-cache.h", "character.h", "category.h",
                             "keyboard.h", "systime.h", "coding.h", INTERVALS_H, "globals.h"]
make_cpp_target "inotify.o", ["inotify.c", "lisp.h", "coding.h", "process.h", "keyboard.h", "frame.h", "termhooks.h"]
make_cpp_target "insdel.o", ["insdel.c", "window.h", "buffer.h", INTERVALS_H, "blockinput.h", "character.h",
                             "atimer.h", "systime.h", "region-cache.h", "lisp.h", "globals.h", config_h]
make_cpp_target "keyboard.o", ["keyboard.c", "termchar.h", "termhooks.h", "termopts.h", "buffer.h", "character.h",
                               "commands.h", "frame.h", "window.h", "macros.h", "disptab.h", "keyboard.h", "syssignal.h",
                               "systime.h", "syntax.h", INTERVALS_H, "blockinput.h", "atimer.h", "composite.h",
                               "xterm.h", "puresize.h", "msdos.h", "keymap.h", "w32term.h", "nsterm.h", "nsgui.h", "coding.h",
                               "process.h", "../lib/unistd.h", "gnutls.h", "lisp.h", "globals.h", config_h]
make_cpp_target "keymap.o", ["keymap.c", "buffer.h", "commands.h", "keyboard.h", "termhooks.h", "blockinput.h",
                             "atimer.h", "systime.h", "puresize.h", "character.h", "charset.h", INTERVALS_H,
                             "keymap.h", "window.h", "coding.h", "frame.h", "lisp.h", "globals.h", config_h]
make_cpp_target "lastfile.o", ["lastfile.c", config_h]
make_cpp_target "macros.o", ["macros.c", "window.h", "buffer.h", "commands.h", "macros.h", "keyboard.h", "msdos.h",
                             "dispextern.h", "lisp.h", "globals.h", config_h, "systime.h", "coding.h", "composite.h"]
make_cpp_target "gmalloc.o", ["gmalloc.c", config_h]
make_cpp_target "ralloc.o", ["ralloc.c", "lisp.h", config_h]
make_cpp_target "vm-limit.o", ["vm-limit.c", "lisp.h", "globals.h", config_h]
make_cpp_target "marker.o", ["marker.c", "buffer.h", "character.h", "lisp.h", "globals.h", config_h]
make_cpp_target "minibuf.o", ["minibuf.c", "syntax.h", "frame.h", "window.h", "keyboard.h", "systime.h",
                              "buffer.h", "commands.h", "character.h", "msdos.h", INTERVALS_H, "keymap.h",
                              "termhooks.h", "lisp.h", "globals.h", config_h, "coding.h"]
make_cpp_target "msdos.o", ["msdos.c", "msdos.h", "dosfns.h", "systime.h", "termhooks.h", "dispextern.h", "frame.h",
                            "termopts.h", "termchar.h", "character.h", "coding.h", "ccl.h", "disptab.h", "window.h",
                            "keyboard.h", INTERVALS_H, "buffer.h", "commands.h", "blockinput.h", "atimer.h",
                            "lisp.h", "sysselect.h", config_h]
make_cpp_target "nsfns.o", ["nsfns.m charset.h", "nsterm.h", "nsgui.h", "frame.h", "window.h", "buffer.h",
                            "dispextern.h", "fontset.h", INTERVALS_H, "keyboard.h", "blockinput.h",
                            "atimer.h", "systime.h", "epaths.h", "termhooks.h", "coding.h", "systime.h", "lisp.h", config_h]
make_cpp_target "nsfont.o", ["nsterm.h", "dispextern.h", "frame.h", "lisp.h", "lisp.h", config_h]
make_cpp_target "nsimage.o", ["nsimage.m nsterm.h", "lisp.h", config_h]
make_cpp_target "nsmenu.o", ["nsmenu.m termhooks.h", "frame.h", "window.h", "dispextern.h",
                             "nsgui.h", "keyboard.h", "blockinput.h", "atimer.h", "systime.h", "buffer.h",
                             "nsterm.h", "lisp.h", config_h]
make_cpp_target "nsterm.o", ["nsterm.m blockinput.h", "atimer.h", "systime.h", "syssignal.h", "nsterm.h",
                             "nsgui.h", "frame.h", "charset.h", "ccl.h", "dispextern.h", "fontset.h", "termhooks.h",
                             "termopts.h", "termchar.h", "disptab.h", "buffer.h", "window.h", "keyboard.h",
                             INTERVALS_H, "process.h", "coding.h", "lisp.h", config_h]
make_cpp_target "nsselect.o", ["nsselect.m blockinput.h", "nsterm.h", "nsgui.h", "frame.h", "lisp.h", config_h]
make_cpp_target "process.o", ["process.c", "process.h", "buffer.h", "window.h", "termhooks.h", "termopts.h",
                              "commands.h", "syssignal.h", "systime.h", "systty.h", "syswait.h", "frame.h", "dispextern.h",
                              "blockinput.h", "atimer.h", "coding.h", "msdos.h", "nsterm.h", "composite.h",
                              "keyboard.h", "lisp.h", "globals.h", config_h, "character.h", "xgselect.h", "sysselect.h",
                              "../lib/unistd.h", "gnutls.h"]
make_cpp_target "regex.o", ["regex.c", "syntax.h", "buffer.h", "lisp.h", "globals.h", config_h, "regex.h",
                            "category.h", "character.h"]
make_cpp_target "region-cache.o", ["region-cache.c", "buffer.h", "region-cache.h",
                                   "lisp.h", "globals.h", config_h]
make_cpp_target "scroll.o", ["scroll.c", "termchar.h", "dispextern.h", "frame.h", "msdos.h", "keyboard.h",
                             "termhooks.h", "lisp.h", "globals.h", config_h, "systime.h", "coding.h", "composite.h",
                             "window.h"]
make_cpp_target "search.o", ["search.c", "regex.h", "commands.h", "buffer.h", "region-cache.h", "syntax.h",
                             "blockinput.h", "atimer.h", "systime.h", "category.h", "character.h", "charset.h",
                             INTERVALS_H, "lisp.h", "globals.h", config_h]
make_cpp_target "sound.o", ["sound.c", "dispextern.h", "syssignal.h", "lisp.h", "globals.h", config_h, "atimer.h", "systime.h", "../lib/unistd.h", "msdos.h"]
make_cpp_target "syntax.o", ["syntax.c", "syntax.h", "buffer.h", "commands.h", "category.h", "character.h",
                             "keymap.h", "regex.h", INTERVALS_H, "lisp.h", "globals.h", config_h]
make_cpp_target "sysdep.o", ["sysdep.c", "syssignal.h", "systty.h", "systime.h", "syswait.h", "blockinput.h",
                             "process.h", "dispextern.h", "termhooks.h", "termchar.h", "termopts.h", "coding.h",
                             "frame.h", "atimer.h", "window.h", "msdos.h", "dosfns.h", "keyboard.h", "cm.h", "lisp.h",
                             "globals.h", config_h, "composite.h", "sysselect.h", "gnutls.h",
                             "../lib/allocator.h", "../lib/careadlinkat.h",
                             "../lib/unistd.h"]
make_cpp_target "term.o", ["term.c", "termchar.h", "termhooks.h", "termopts.h", "lisp.h", "globals.h", config_h,
                           "cm.h", "frame.h", "disptab.h", "keyboard.h", "character.h", "charset.h", "coding.h", "ccl.h",
                           "xterm.h", "msdos.h", "window.h", "keymap.h", "blockinput.h", "atimer.h", "systime.h",
                           "systty.h", "syssignal.h", "tparam.h", INTERVALS_H, "buffer.h", "../lib/unistd.h"]
make_cpp_target "termcap.o", ["termcap.c", "lisp.h", "tparam.h", "msdos.h", config_h]
make_cpp_target "terminal.o", ["terminal.c", "frame.h", "termchar.h", "termhooks.h", "charset.h", "coding.h",
                               "keyboard.h", "lisp.h", "globals.h", config_h, "dispextern.h", "composite.h", "systime.h",
                               "msdos.h"]
make_cpp_target "terminfo.o", ["terminfo.c", "tparam.h", "lisp.h", "globals.h", config_h]
make_cpp_target "tparam.o", ["tparam.c", "tparam.h", "lisp.h", config_h]
make_cpp_target "undo.o", ["undo.c", "buffer.h", "commands.h", "window.h", "dispextern.h", "msdos.h",
                           "lisp.h", "globals.h", config_h]
make_cpp_target "unexaix.o", ["unexaix.c", "lisp.h", "unexec.h", config_h]
make_cpp_target "unexcw.o", ["unexcw.c", "lisp.h", "unexec.h", config_h]
make_cpp_target "unexcoff.o", ["unexcoff.c", "lisp.h", "unexec.h", config_h]
make_cpp_target "unexelf.o", ["unexelf.c", "unexec.h", "../lib/unistd.h", config_h]
make_cpp_target "unexhp9k800.o", ["unexhp9k800.c", "unexec.h", config_h]
make_cpp_target "unexmacosx.o", ["unexmacosx.c", "unexec.h", config_h]
make_cpp_target "unexsol.o", ["unexsol.c", "lisp.h", "unexec.h", config_h]
make_cpp_target "unexw32.o", ["unexw32.c", "unexec.h", config_h]
make_cpp_target "w16select.o", ["w16select.c", "dispextern.h", "frame.h", "blockinput.h", "atimer.h", "systime.h",
                                "msdos.h", "buffer.h", "charset.h", "coding.h", "composite.h", "lisp.h", config_h]
make_cpp_target "widget.o", ["widget.c", "xterm.h", "frame.h", "dispextern.h", "widgetprv.h",
                             "#{srcdir}/../lwlib/lwlib.h", "lisp.h", config_h]
make_cpp_target "window.o", ["window.c", "indent.h", "commands.h", "frame.h", "window.h", "buffer.h", "termchar.h",
                             "disptab.h", "keyboard.h", "msdos.h", "coding.h", "termhooks.h",
                             "keymap.h", "blockinput.h", "atimer.h", "systime.h", INTERVALS_H,
                             "xterm.h", "w32term.h", "nsterm.h", "nsgui.h", "lisp.h", "globals.h", config_h]
make_cpp_target "xdisp.o", ["xdisp.c", "macros.h", "commands.h", "process.h", "indent.h", "buffer.h",
                            "coding.h", "termchar.h", "frame.h", "window.h", "disptab.h", "termhooks.h", "character.h",
                            "charset.h", "lisp.h", config_h, "keyboard.h", INTERVALS_H, "region-cache.h",
                            "xterm.h", "w32term.h", "nsterm.h", "nsgui.h", "msdos.h", "composite.h", "fontset.h", "ccl.h",
                            "blockinput.h", "atimer.h", "systime.h", "keymap.h", "font.h", "globals.h", "termopts.h",
                            "../lib/unistd.h", "gnutls.h", "gtkutil.h"]
make_cpp_target "xfaces.o", ["xfaces.c", "frame.h", "xterm.h", "buffer.h", "blockinput.h",
                             "window.h", "character.h", "charset.h", "msdos.h", "dosfns.h", "composite.h", "atimer.h",
                             "systime.h", "keyboard.h", "fontset.h", "w32term.h", "nsterm.h", "coding.h", "ccl.h",
                             INTERVALS_H, "nsgui.h", "termchar.h", "termhooks.h", "font.h",
                             "lisp.h", "globals.h", config_h]
make_cpp_target "xfns.o", ["xfns.c", "buffer.h", "frame.h", "window.h", "keyboard.h", "xterm.h",
                           "#{srcdir}/../lwlib/lwlib.h", "blockinput.h", "atimer.h", "systime.h", "epaths.h",
                           "character.h", "charset.h", "coding.h", "gtkutil.h", "lisp.h", config_h, "termhooks.h",
                           "fontset.h", "termchar.h", "font.h", "xsettings.h", INTERVALS_H, "ccl.h", "globals.h",
                           "../lib/unistd.h"]
make_cpp_target "xfont.o", ["dispextern.h", "xterm.h", "frame.h", "blockinput.h", "character.h", "charset.h",
                            "font.h", "lisp.h", "globals.h", config_h, "atimer.h", "systime.h", "fontset.h", "ccl.h"]
make_cpp_target "xftfont.o", ["xftfont.c", "dispextern.h", "xterm.h", "frame.h", "blockinput.h", "character.h",
                              "charset.h", "font.h", "lisp.h", "globals.h", config_h, "atimer.h", "systime.h",
                              "fontset.h", "ccl.h", "ftfont.h", "composite.h"]
make_cpp_target "ftxfont.o", ["ftxfont.c", "dispextern.h", "xterm.h", "frame.h", "blockinput.h", "character.h",
                              "charset.h", "font.h", "lisp.h", "globals.h", config_h, "atimer.h", "systime.h",
                              "fontset.h", "ccl.h"]
make_cpp_target "menu.o", ["menu.c", "lisp.h", "keyboard.h", "keymap.h", "frame.h", "termhooks.h", "blockinput.h",
                           "dispextern.h", "#{srcdir}/../lwlib/lwlib.h", "xterm.h", "gtkutil.h", "menu.h",
                           "lisp.h", "globals.h", config_h, "systime.h", "coding.h", "composite.h", "window.h",
                           "atimer.h", "nsterm.h", "w32term.h", "msdos.h"]
make_cpp_target "xmenu.o", ["xmenu.c", "xterm.h", "termhooks.h", "window.h", "dispextern.h", "frame.h", "buffer.h",
                            "charset.h", "keyboard.h", "#{srcdir}/../lwlib/lwlib.h", "blockinput.h", "atimer.h",
                            "systime.h", "gtkutil.h", "msdos.h", "coding.h", "menu.h", "lisp.h", "globals.h", config_h,
                            "composite.h", "keymap.h", "sysselect.h"]
make_cpp_target "xml.o", ["xml.c", "buffer.h", "lisp.h", "globals.h", config_h]
make_cpp_target "xterm.o", ["xterm.c", "xterm.h", "termhooks.h", "termopts.h", "termchar.h", "window.h", "buffer.h",
                            "dispextern.h", "frame.h", "disptab.h", "blockinput.h", "atimer.h", "systime.h", "syssignal.h",
                            "keyboard.h", "emacs-icon.h", "character.h", "charset.h", "ccl.h", "fontset.h", "composite.h",
                            "coding.h", "process.h", "gtkutil.h", "font.h", "fontset.h", "lisp.h", "globals.h", config_h,
                            "xsettings.h", "intervals.h", "keymap.h", "xgselect.h", "sysselect.h", "../lib/unistd.h",
                            "gnutls.h"]
make_cpp_target "xselect.o", ["xselect.c", "process.h", "dispextern.h", "frame.h", "xterm.h", "blockinput.h",
                              "buffer.h", "atimer.h", "systime.h", "termhooks.h", "lisp.h", config_h, "keyboard.h",
                              "coding.h", "composite.h", "../lib/unistd.h", "globals.h", "gnutls.h"]
make_cpp_target "xgselect.o", ["xgselect.h", "systime.h", "sysselect.h", "lisp.h", "globals.h", config_h]
make_cpp_target "xrdb.o", ["xrdb.c", "lisp.h", "globals.h", config_h, "epaths.h", "../lib/unistd.h"]
make_cpp_target "xsmfns.o", ["xsmfns.c", "lisp.h", config_h, "systime.h", "sysselect.h", "termhooks.h",
                             "xterm.h", "lisp.h", "termopts.h", "frame.h", "dispextern.h", "../lib/unistd.h", "globals.h",
                             "gnutls.h", "keyboard.h", "coding.h", "composite.h"]
make_cpp_target "xsettings.o", ["xterm.h", "xsettings.h", "lisp.h", "frame.h", "termhooks.h", config_h,
                                "dispextern.h", "keyboard.h", "systime.h", "coding.h", "composite.h", "blockinput.h",
                                "atimer.h", "termopts.h", "globals.h"]
## The files of Lisp proper.
make_cpp_target "alloc.o", ["alloc.c", "process.h", "frame.h", "window.h", "buffer.h", "puresize.h", "syssignal.h",
                            "keyboard.h", "blockinput.h", "atimer.h", "systime.h", "character.h", "lisp.h", config_h,
                            INTERVALS_H, "termhooks.h", "gnutls.h", "coding.h", "../lib/unistd.h", "globals.h"]
make_cpp_target "bytecode.o", ["bytecode.c", "buffer.h", "syntax.h", "character.h", "window.h", "dispextern.h",
                               "lisp.h", "globals.h", config_h, "msdos.h"]
make_cpp_target "data.o", ["data.c", "buffer.h", "puresize.h", "character.h", "syssignal.h", "keyboard.h", "frame.h",
                           "termhooks.h", "systime.h", "coding.h", "composite.h", "dispextern.h", "font.h", "ccl.h",
                           "lisp.h", "globals.h", config_h, "msdos.h"]
make_cpp_target "eval.o", ["eval.c", "commands.h", "keyboard.h", "blockinput.h", "atimer.h", "systime.h", "frame.h",
                           "dispextern.h", "lisp.h", "globals.h", config_h, "coding.h", "composite.h", "xterm.h",
                           "msdos.h"]
make_cpp_target "floatfns.o", ["floatfns.c", "syssignal.h", "lisp.h", "globals.h", config_h]
make_cpp_target "fns.o", ["fns.c", "commands.h", "lisp.h", config_h, "frame.h", "buffer.h", "character.h",
                          "keyboard.h", "keymap.h", "window.h", INTERVALS_H, "coding.h", "../lib/md5.h",
                          "../lib/sha1.h", "../lib/sha256.h", "../lib/sha512.h", "blockinput.h", "atimer.h",
                          "systime.h", "xterm.h", "../lib/unistd.h", "globals.h"]
make_cpp_target "print.o", ["print.c", "process.h", "frame.h", "window.h", "buffer.h", "keyboard.h", "character.h",
                            "lisp.h", "globals.h", config_h, "termchar.h", INTERVALS_H, "msdos.h", "termhooks.h",
                            "blockinput.h", "atimer.h", "systime.h", "font.h", "charset.h", "coding.h", "ccl.h",
                            "gnutls.h", "../lib/unistd.h", "../lib/ftoastr.h", "../lib/intprops.h"]
make_cpp_target "lread.o", ["lread.c", "commands.h", "keyboard.h", "buffer.h", "epaths.h", "character.h",
                            "charset.h", "lisp.h", "globals.h", config_h, INTERVALS_H, "termhooks.h",
                            "coding.h", "msdos.h", "systime.h", "frame.h", "blockinput.h", "atimer.h", "../lib/unistd.h"]
## Text properties support.
make_cpp_target "composite.o", ["composite.c", "composite.h", "buffer.h", "character.h", "coding.h", "font.h",
                                "ccl.h", "frame.h", "termhooks.h", INTERVALS_H, "window.h",
                                "lisp.h", "globals.h", config_h]
make_cpp_target "intervals.o", ["intervals.c", "buffer.h", INTERVALS_H, "keyboard.h", "puresize.h",
                                "keymap.h", "lisp.h", "globals.h", config_h, "systime.h", "coding.h"]

make_cpp_target "textprop.o", ["textprop.c", "buffer.h", "window.h", INTERVALS_H,
                               "lisp.h", "globals.h", config_h]

make_target :all do
  global
  depends ["emacs" + EXEEXT]
end
