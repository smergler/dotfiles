import os
cwd = os.path.dirname(os.path.abspath(__file__))
exec(open('{0}/install_base.py'.format(cwd)).read())

class Apt(InstallBase):
    _directive = 'apt'
    _cli_call = 'apt'
    _sudo_used = True
    _group_used = False

    def _check_if_installed(self, package):
        cmd = "dpkg -l %s |grep '%s '; |awk '{print $3}'" % (package.name, package.name)
        return self._run_cmd(cmd, package.options) == 0