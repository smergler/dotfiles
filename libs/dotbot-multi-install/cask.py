import os
cwd = os.path.dirname(os.path.abspath(__file__))
exec(open('{0}/install_base.py'.format(cwd)).read())

class Cask(InstallBase):
    _directive = 'cask'
    _cli_call = 'brew'
    _sudo_used = False
    _group_used = False

    def _check_if_installed(self, package):
        cmd = "brew ls --cask --versions %s" % package.name
        return self._run_cmd(cmd, package.options) == 0