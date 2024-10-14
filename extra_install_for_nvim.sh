wget https://www.lua.org/ftp/lua-5.1.5.tar.gz
tar xzf lua-5.1.5.tar.gz
cd lua-5.1.5
make macosx
mkdir ~/opt
make INSTALL_TOP=$HOME/opt/lua@5.1 install
mkdir -p ~/.local/bin
ln -s ~/opt/lua@5.1/bin/lua ~/.local/bin/lua5.1
export PATH=~/.local/bin/:$PATH # put ~/.local/bin in the path in your .basrc or .zshrc

