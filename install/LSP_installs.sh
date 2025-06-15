#!/usr/bin/env bash

BINARY_HOME="${HOME}/.local/bin"
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

echo "Installing Language Servers for Helix Editor:"

# Work in a throwaway temporary directory so as not to pollute the file system.
temporaryDirectory="/tmp/helix-editor-language-server-installer"
mkdir -p "${temporaryDirectory}"
pushd "${temporaryDirectory}"

# Bash
echo "  • Bash (bash-language-server)"
npm i -g bash-language-server

# HTML, JSON, JSON schema
echo "  • HTML, JSON, and JSON schema (vscode-langservers-extracted)"
npm i -g vscode-langservers-extracted

# JavaScript (via TypeScript)
echo "  • JavaScript (typescript, typescript-language-server)"
npm install -g typescript typescript-language-server

# Markdown (via ltex-ls. Note: this has excellent features like
# spelling and grammar check but is a ~269MB download).
echo "  • Markdown (ltex-ls)"
ltexLsVersion=15.2.0
ltexLsBinaryPath="${BINARY_HOME}/ltex-ls"
ltexLsBaseFileName="ltex-ls-${ltexLsVersion}"
ltexLsFileNameWithPlatform="${ltexLsBaseFileName}-linux-x64"
ltexLsAppDirectory="${DATA_HOME}/${ltexLsBaseFileName}"
rm "${ltexLsBinaryPath}"
rm -rf "${ltexLsAppDirectory}"
wget "https://github.com/valentjn/ltex-ls/releases/download/${ltexLsVersion}/${ltexLsFileNameWithPlatform}.tar.gz"
gunzip "${ltexLsFileNameWithPlatform}.tar.gz"
tar xf "${ltexLsFileNameWithPlatform}.tar"
mv "${ltexLsBaseFileName}" "${DATA_HOME}"
ln -s "${ltexLsAppDirectory}/bin/ltex-ls" "${ltexLsBinaryPath}" 

# TOML
cargo install taplo-cli --locked --features lsp

# Clean up.
popd
rm -rf "${temporaryDirectory}"

echo "Done."
