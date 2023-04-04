nix-env -iA nixpkgs.wget
mkdir build
cd build
wget https://github.com/Erebus20/wordpress-zh_TW-on-replit/raw/main/php.zip
nix-env -iA nixpkgs.unzip
unzip php.zip
cd ..
wget -O install.sh https://github.com/Erebus20/wordpress-zh_TW-on-replit/raw/main/install.sh
cp -r build/.replit . && cp -r build/replit.nix .
cp -r build/.cache .cache
rm -rf build/
nix-env -iA nixpkgs.less
rm -rf README.md
nix-env -iA nixpkgs.wp-cli
bash install.sh
