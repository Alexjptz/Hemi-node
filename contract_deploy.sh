#!/bin/bash

show_orange() {
    echo -e "\e[33m$1\e[0m"
}

show_blue() {
    echo -e "\e[34m$1\e[0m"
}

show_green() {
    echo -e "\e[32m$1\e[0m"
}

show_red() {
    echo -e "\e[31m$1\e[0m"
}

# Download  nvm и Node.js
if ! command -v npm &> /dev/null; then
    show_orange "Устанавливаем (Installing) nvm..."
    if curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash; then
        source ~/.bashrc
        show_green "Успешно (Success)"
        echo ""
    else
        show_red "Ошибка (Fail)"
        echo ""

    show_orange "Устанавливаем (Installing) Node.js 22..."
    if nvm install 22; then
        show_green "Успешно (Success)"
        echo ""
    else
        show_red "Ошибка (Fail)"
        echo ""

    show_orange "Проверка версий (Cheking versions) Node.js и npm..."
    if node -v && npm -v; then
        show_green "Успешно (Success)"
        echo ""
    else
        show_red "Ошибка (Fail)"
        echo ""

    # Check npm version
    REQUIRED_NPM_VERSION="10.8.3"
    CURRENT_NPM_VERSION=$(npm -v)

    if [ "$(printf '%s\n' "$REQUIRED_NPM_VERSION" "$CURRENT_NPM_VERSION" | sort -V | head -n1)" != "$REQUIRED_NPM_VERSION" ]; then
        show_orange "NPM. Версия устарела. Обновляем. (Out of date. Updating)..."
        if npm install -g npm@$REQUIRED_NPM_VERSION
        then
            show_green "Успешно (Success)"
            echo ""
        else
            show_red "Ошибка (Fail)"
            echo ""
    else
        show_green "Версия (Version) npm $CURRENT_NPM_VERSION - OK."
    fi
fi

# Step 1: Move to Hemi-Node folder
show_orange "Переход (Move to) в Hemi-Node..."
cd ~/Hemi-Node || exit

# Step 2: Checking JSON
eval $(jq -r '. | "ETHEREUM_ADDRESS=\(.ethereum_address)\nNETWORK=\(.network)\nPRIVATE_KEY=\(.private_key)\nPUBLIC_KEY=\(.public_key)\nPUBKEY_HASH=\(.pubkey_hash)"' $HOME/popm-address.json)

show_orange "Вывод данных (Output data)..."
echo "Ethereum Address: $ETHEREUM_ADDRESS"
echo "Network: $NETWORK"
echo "Private Key: $PRIVATE_KEY"
echo "Public Key: $PUBLIC_KEY"
echo "Public Key Hash: $PUBKEY_HASH"

# Step 3: Creating project folder
show_orange "Создание папки (creating folder) ERC-20..."
if mkdir TestToken && cd TestToken; then
    show_green "Успешно (Success)"
    echo ""
else
    show_red "Ошибка (Fail)"
    echo ""

# Step 4: init npm
show_orange "Инициализация npm проекта и установка зависимостей..."
if npm init -y && npm install --save-dev hardhat @nomiclabs/hardhat-ethers ethers @openzeppelin/contracts;
    show_green "Успешно (Success)"
    echo ""
else
    show_red "Ошибка (Fail)"
    echo ""

# Step 5: Init Hardhat
show_orange "Инициализация (Init) Hardhat..."
if npx hardhat init; then
    show_green "Успешно (Success)"
    echo ""
else
    show_red "Ошибка (Fail)"
    echo ""

# Step 6: Creating hardhat.config.js
show_orange "Создание файла (Creating) hardhat.config.js..."
cat <<EOL > hardhat.config.js
/** @type import('hardhat/config').HardhatUserConfig */
require('dotenv').config();
require("@nomiclabs/hardhat-ethers");

module.exports = {
  solidity: "0.8.20",
  networks: {
    hemi: {
      url: "https://testnet.rpc.hemi.network/rpc",
      chainId: 743111,
      accounts: [\`0x$PRIVATE_KEY\`],
    },
  }
};
EOL
show_green "Успешно (Success)"

# Step 7: Creating contracts и scripts
show_orange "Создание папок (creating folders) contracts и scripts..."
if mkdir contracts scripts; then
    show_green "Успешно (Success)"
    echo ""
else
    show_red "Ошибка (Fail)"
    echo ""

# Step 8: Creating contracts MyToken.sol
show_orange "Создание контракта (creating contract) MyToken.sol..."
cat <<EOL > contracts/MyToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("MyToken", "MTK") {
        _mint(msg.sender, initialSupply);
    }
}
EOL
show_green "Успешно (Success)"

# Step 9: Building contract
show "Компиляция контракта (Contract compilation)..."
if npx hardhat compile; then
    show_green "Успешно (Success)"
    echo ""
else
    show_red "Ошибка (Fail)"
    echo ""

# Step 10: dotenv installation
show "Установка (Installing) dotenv..."
if npm install dotenv; then
    show_green "Успешно (Success)"
    echo ""
else
    show_red "Ошибка (Fail)"
    echo ""

# Step 11: Создание deploy.js для деплоя токена
show "Создание скрипта (creating script) deploy.js..."
cat <<EOL > scripts/deploy.js
const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    const initialSupply = ethers.utils.parseUnits("1000", "ether");

    const Token = await ethers.getContractFactory("MyToken");
    const token = await Token.deploy(initialSupply);

    console.log("Token deployed to:", token.address);
}

main().catch((error) => {
    console.error(error);
    process.exit(1);
});
EOL
show_green "Успешно (Success)"

# Step 12: Deploy to Hemi
show_orange "Деплой контракта в сеть (Deploy to) Hemi..."
if npx hardhat run scripts/deploy.js --network hemi; then
    show_green "Успешно (Success)"
    echo ""
else
    show_red "Ошибка (Fail)"
    echo ""

show_green "КОНТРАКТ УСТАНОВЛЕН - CONTRACT DEPLOYED"
