import os
cwd = os.path.dirname(os.path.abspath(__file__))
exec(open('{0}/install_base.py'.format(cwd)).read())

class Tap(InstallBase):
    _install_arg = ''
    _directive = 'tap'
    _cli_call = 'brew tap'
    _sudo_used = False
    _group_used = False

    def _check_if_installed(self, package):
        return False