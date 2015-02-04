#!/usr/bin/env python
"""script to automate installation and
maintenance of Vim installation

CAUTION: unsafe use of relative pathes.
      Script MUST ONLY be run within
      $HOME/.vim

TODO: make path values absolute so that no
      accidental removal "like Steam" happens
"""


import argparse
import os
import sys
import stat


PACKFILE="submodules.txt"           # file to contain urls to submodules
INSTPATH="bundle"                   # pathogen path within .vimfiles
DEACTPATH=INSTPATH + "_deactivated" # path to deactivated modules


def _check_dir(dirname, create=True):
    """checks if given directory exists

    create:     should dir be created if non-existent?
    """
    if not os.path.isdir(dirname):
        if create:
            # directory non-existent BUT
            # should be created
            try:
                print "Creating subdir %s" % dirname
                os.mkdir(dirname)
                return True
            except OSError:
                print "Error creating: %s" % dirname
                return False
        else:
            # directory non-existent and
            # should not be created
            return False


def _knownpacks():
    """returns list of packs from PACKFILE
    """
    with open(PACKFILE, "r") as f:
        packs = f.readlines()
    for i in range(len(packs)):
        packs[i] = packs[i].strip()
    return packs


def _saveurl(url):
    """saves url into PACKFILE
    """
    if not url in _knownpacks():
        print "new pack %s, storing it in %s" % (url, PACKFILE)
        with open(PACKFILE, "a") as f:
            f.write(url + "\n")


def _download(url):
    """downloads url by fetching or by git clone
    """
    targetdir = INSTPATH + "/" + os.path.basename(url)
    if os.path.exists(targetdir):
        print "%s already exists, skipping." % targetdir
    else:
        if "git" in url:
            os.popen("git submodule add %s %s" % (url, targetdir))
        else:
            # TODO: use "fetch" to download into bundle/[pack] subdir
            pass


def _swap_dirs(olddir, newdir):
    """moves one file/dir to another location
    """
    if not os.path.exists(olddir):
        print "Error: submodule %s not found in %s." % (os.path.basename(olddir), os.path.abspath(olddir))
        sys.exit(1)
    if os.path.exists(newdir):
        print "Error: %s already exists" % os.path.abspath(newdir)
        sys.exit(1)
    else:
        #print "mv %s %s" % (olddir, newdir)
        os.popen("mv -i %s %s" % (olddir, newdir))


def _preflight():
    """pre-flight checks for this script"""
    if not _check_dir(".git", create=False):
        os.popen("git init")
    os.popen("git submodule init")
    _check_dir(INSTPATH)
    _check_dir(DEACTPATH)




# -- main functions here --
def install(url):
    """installs module"""
    if url=="all":
        with open(PACKFILE, 'r') as f:
            urls = f.readlines()
            for url in urls:
                url = url.strip()
                _download(url)
    else:
        _saveurl(url)
        _download(url)
    sys.exit(0)


def update():
    """updates all git submodules
    """
    os.popen("git submodule init")
    actives, inactives = listbundles()
    for bundle in actives:
        print "Updating submodule %s" % bundle
        bundle = INSTPATH + "/" + bundle
        os.popen("git submodule update %s" % bundle)
    sys.exit(0)


def activate(name):
    """moves package subdir back into "bundle" dir

    name:       subdir/package name
    """
    print "Re-activating %s" % name
    olddir = DEACTPATH + "/" + name
    newdir = INSTPATH + "/" + name
    _swap_dirs(olddir, newdir)


def deactivate(name):
    """moves package subdir into "bundle_deactivated" dir

    name:       subdir/package name
    """
    print "Deactivating %s" % name
    olddir = INSTPATH + "/" + name
    newdir = DEACTPATH + "/" + name
    _swap_dirs(olddir, newdir)


def listbundles(show=False):
    """list packages from active bundle-dir
    """
    bundles = os.listdir(os.path.abspath(INSTPATH))
    inactives = os.listdir(os.path.abspath(DEACTPATH))
    if show:
        print "----- active -----"
        for bundle in bundles:
            print bundle
        print "----- inactive -----"
        for bundle in inactives:
            print bundle
    return bundles, inactives


def remove(bundle):
    """remove bundle from active and inactive directory"""
    activedir = INSTPATH + "/" + bundle
    inactivedir = DEACTPATH + "/" + bundle
    found = False
    # remove it
    if os.path.exists(inactivedir):
        print "Removing inactive bundle:\t%s" % inactivedir
        if os.path.exists(activedir):
            os.popen("rm -R %s" % activedir)
        _swap_dirs(inactivedir, activedir)
    if os.path.exists(activedir):
        # remove from git submodule list
        os.popen("git submodule deinit -f  %s" % activedir)
        os.popen("git rm --cached %s" % activedir)
        os.popen("git rm %s" % activedir)
        os.popen("rm -Rf .git/modules/%s" % activedir)
        # remove the subdirectory
        if _check_dir(activedir, create=False):
            os.popen("rm -R %s" % activedir)
        print "-- Attention --"
        print "Remove/Deactivate entry for %s from %s" % (bundle, PACKFILE)
        print "Or it will be re-installed with the next call to '-i all'."
    else:
        print "module %s not found." % bundle


def cleanup():
    """remove all git-dirs and submodules from here"""
    os.popen("rm -Rf .git")
    os.popen("rm -Rf %s" % INSTPATH)
    os.popen("rm -Rf %s" % DEACTPATH)



# -- main routine here --
if __name__ == "__main__":
    # do some basic checks
    _preflight()
    # parse commandline arguments
    parser = argparse.ArgumentParser(description="Automate Vim setup/maintenance")
    parser.add_argument("-i", "--install", type=str, metavar="url", nargs="?",
                        help="install modules from url or use 'all' to install \
                        via urls from modules.txt")
    parser.add_argument("-u", "--update", action="store_true", help="update installed modules")
    parser.add_argument("-a", "--activate", type=str, metavar="module", nargs="?",
                        help="move given module into bundle subdirectory")
    parser.add_argument("-d", "--deactivate", type=str, metavar="module", nargs="?",
                        help="move given module into bundle_deactivated subdirectory")
    parser.add_argument("-r", "--remove", type=str, metavar="module", nargs="?",
                        help="remove given module from bundle AND bundle_deactivated subdirectory")
    parser.add_argument("-l", "--list", action="store_true", help="list installed+active modules")
    parser.add_argument("-c", "--cleanup", action="store_true", help="CAUTION: start git from scratch")
    args = parser.parse_args()

    #print "debug: %s" % args

    # process arguments
    if args.install:
        install(args.install)
    elif args.update:
        update()
    elif args.list:
        listbundles(show=True)
    elif args.activate:
        activate(args.activate)
    elif args.deactivate:
        deactivate(args.deactivate)
    elif args.remove:
        remove(args.remove)
    elif args.cleanup:
        cleanup()
