import hashlib
import json  # noqa
import os  # noqa
import pprint
import sys

readline = None
try:
    import readline
except ImportError:
    try:
        import pyreadline as readline
    # throw open a browser if we fail both readline and pyreadline
    except ImportError:
        import webbrowser
        webbrowser.open("http://ipython.scipy.org"
                        "/moin/PyReadline/Intro#line-36")

if readline:
    import rlcompleter

    class TabCompleter(rlcompleter.Completer):
        uses_editline = any(s in readline.__doc__
                            for s in ['libedit', 'editline'])

        def complete(self, text, state):
            if not text:
                readline.insert_text('    ')
                if TabCompleter.uses_editline:
                    # It won't move the cursor for us, apparently
                    sys.stdout.write('\x1b[4C')
                readline.redisplay()
                sys.stdout.flush()
                return None
            else:
                return rlcompleter.Completer.complete(self, text, state)
    readline.set_completer(TabCompleter().complete)

    if TabCompleter.uses_editline:  # Different binding syntax
        readline.parse_and_bind("bind ^I rl_complete")
    else:
        readline.parse_and_bind("tab: complete")

def displayhook(value):
    """Tim's custom display hook"""
    if value is not None:
        pprint.pprint(value)

sys.displayhook = displayhook


def md5(s):
    return hashlib.md5(s).hexdigest()

def sha256(s):
    return hashlib.sha256(s).hexdigest()
