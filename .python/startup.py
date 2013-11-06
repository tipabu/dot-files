#Code  UUID = '9301d536-860d-11de-81c8-0023dfaa9e40'
import sys
try:
        import readline
except ImportError:
        try:
                import pyreadline as readline
        # throw open a browser if we fail both readline and pyreadline
        except ImportError:
                import webbrowser
                webbrowser.open("http://ipython.scipy.org/moin/PyReadline/Intro#line-36")
                # throw open a browser
        #pass
else:
        import rlcompleter
        class TabCompleter(rlcompleter.Completer):
                uses_editline = any(s in readline.__doc__ for s in ['libedit', 'editline'])
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

        if TabCompleter.uses_editline: # Different binding syntax
                readline.parse_and_bind("bind ^I rl_complete")
        else:
                readline.parse_and_bind("tab: complete")
