import os, platform, subprocess, dotbot, json
from dataclasses import dataclass

@dataclass
class Package:
    name: str
    options: dict

class InstallBase(dotbot.Plugin):
    _install_arg = "install"
    _cli_call = "echo"
    _directive = "install-base"
    _sudo_used = True
    _group_used = False
    _already_installed = []
    _installed = []

    def can_handle(self, directive):
        return directive == self._directive

    def handle(self, directive, data):
        if directive != self._directive:
            raise ValueError('install_base cannot handle directive {0}'.format(directive))
        self._bootstrap()
        success = self._process_call(data)
        if success:
            self._log.info('All %s packages have been installed' % self._directive)
        else:
            self._log.error('Some %s packages were not installed' % self._directive)

        return success

    def _bootstrap(self):
        return True

    def _process_call(self, packages):
        package_list = []
        defaults = self._context.defaults().get(self._directive, {})
        package_list = []
        if isinstance(packages, str) or isinstance(packages, list):
            if isinstance(packages, str):
                packages = packages.split(' ')
            for pkg_str in packages:
                for pkg in pkg_str.split(' '):
                    package_list.append(Package(pkg, defaults))
        elif isinstance(packages, dict):
            # multiple packages in dict with possible options, one install per package
            for pkg_name, pkg_opts in packages.items():
                install_base_opts = {}
                if isinstance(pkg_opts, dict):
                    install_base_opts = self._merge_dicts(defaults, pkg_opts)
                elif pkg_opts:
                    install_base_opts = self._merge_dicts(defaults, {'options': pkg_opts})
                else:
                    install_base_opts = defaults
                package_list.append(Package(pkg_name, install_base_opts))
        else:
            self._log.error("Invalid package specification [{0}]".format(packages))
            return False
        return self._process_list(package_list)

    def _process_list(self, package_list):
        for package in package_list:
            if self._check_if_installed(package):
                continue
            if not self._install(package):
                self._log.error("There was an issue installing {0}".format(package.name))
                return False
        return True

    def _use_sudo(self, pkg_opts={}):
        if not self._sudo_used:
            return False
        is_sudo = pkg_opts.get('sudo', False)
        if os.geteuid() != 0 and is_sudo == False :
            msg = 'Need root permissions to install packages'
            self._log.error(msg)
            raise InstallBaseError(msg)

        return is_sudo

    def _check_if_installed(self, package):
        return False

    def _install_prefix(self, pkg_opts={}):
        return ''

    def _install(self, package):
        self._log.info("installing %s" % package.name)
        is_sudo = self._use_sudo(package.options)

        if 'options' not in package.options:
            package.options['options'] = ''

        sudo_str = 'sudo' if is_sudo else ''
        prefix_str = self._install_prefix()

        cmd = "{0} {1} {2}{3} {4}".format(sudo_str, self._cli_call, prefix_str, self._install_arg, package.name).strip()

        if self._run_cmd(cmd, package.options) != 0:
            self._log.error("Failed to{0}install [{1}] with args [{2}]".format(prefix_str, package, package.options["options"]))
            return False
        return True

    def _run_cmd(self, cmd, pkg_opts={}):
        # self._log.info("running %s" % cmd )
        with open(os.devnull, 'w') as devnull:
            stdin = stdout = stderr = devnull
            if pkg_opts.get('stdin', False) == True:
                stdin = None
            if pkg_opts.get('stdout', False) == True:
                stdout = None
            if pkg_opts.get('stderr', False) == True:
                stderr = None
            return subprocess.call(cmd, shell=True, stdin=stdin, stdout=stdout, stderr=stderr, cwd=cwd)

    def _merge_dicts(self, *dict_args):
        """
        Given any number of dicts, shallow copy and merge into a new dict,
        precedence goes to key value pairs in latter dicts.
        """
        result = {}
        for dictionary in dict_args:
            result.update(dictionary)
        return result

class InstallBaseError(Exception):
    pass



