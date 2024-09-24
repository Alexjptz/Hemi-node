#!/bin/bash

tput reset
tput civis

# Put your logo here if nessesary
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

show_orange '----------_____--------------------_____----------------_____----------'
show_orange '---------/\----\------------------/\----\--------------/\----\---------'
show_orange '--------/::\____\----------------/::\----\------------/::\----\--------'
show_orange '-------/:::/----/---------------/::::\----\-----------\:::\----\-------'
show_orange '------/:::/----/---------------/::::::\----\-----------\:::\----\------'
show_orange '-----/:::/----/---------------/:::/\:::\----\-----------\:::\----\-----'
show_orange '----/:::/____/---------------/:::/__\:::\----\-----------\:::\----\----'
show_orange '----|::|----|---------------/::::\---\:::\----\----------/::::\----\---'
show_orange '----|::|----|-----_____----/::::::\---\:::\----\--------/::::::\----\--'
show_orange '----|::|----|----/\----\--/:::/\:::\---\:::\----\------/:::/\:::\----\-'
show_orange '----|::|----|---/::\____\/:::/--\:::\---\:::\____\----/:::/--\:::\____\'
show_orange '----|::|----|--/:::/----/\::/----\:::\--/:::/----/---/:::/----\::/----/'
show_orange '----|::|----|-/:::/----/--\/____/-\:::\/:::/----/---/:::/----/-\/____/-'
show_orange '----|::|____|/:::/----/------------\::::::/----/---/:::/----/----------'
show_orange '----|:::::::::::/----/--------------\::::/----/---/:::/----/-----------'
show_orange '----\::::::::::/____/---------------/:::/----/----\::/----/------------'
show_orange '-----~~~~~~~~~~--------------------/:::/----/------\/____/-------------'
show_orange '----------------------------------/:::/----/---------------------------'
show_orange '---------------------------------/:::/----/----------------------------'
show_orange '---------------------------------\::/----/-----------------------------'
show_orange '----------------------------------\/____/------------------------------'
show_orange '-----------------------------------------------------------------------'

echo -e "\n \e[33mПодпишись на мой канал\e[0m Beloglazov invest, \n чтобы быть в курсе самых актуальных нод и активностей \n \e[33mhttps://t.me/beloglazovinvest \e[0m \n"

sleep 2

while true; do
    echo "1. Подготовка к установке Hemi (Preparation)"
    echo "2. Установка Hemi (Installation)"
    echo "3. Запуск или перезапуск (Start or restart)"
    echo "4. О ноде (About node)"
    echo "5. Удалить ноду (Delete node)"
    echo "6. Восстановление (Restore)"
    echo "7. Выход (Exit)"
    echo ""
    read -p "Выберите опцию (Select option): " option

    case $option in
        1)
            show_orange "Начинаем подготовку (Starting preparation)..."
            sleep 1
            # Update and install packages
            cd $HOME
            show_orange "Обновляем и устанавливаем пакеты (Updating and installing packages)..."
            if sudo apt update && sudo apt upgrade -y && sudo apt install -y curl sed git jq lz4 build-essential screen nano unzip mc; then
                sleep 1
                echo ""
                show_green "Успешно (Success)"
                echo ""
            else
                sleep 1
                echo ""
                show_red "Ошибка (Fail)"
                echo ""
            fi
            ;;
        2)
            # install node
            show_orange "Начинаем установку (Starting installation)..."
            echo ""
            sleep 2

            show_orange "Создание папки (Creating folder)..."
            sleep 1
            echo ""
            if mkdir Hemi-Node && cd Hemi-Node; then
                sleep 1
                echo ""
                show_green "Успешно (Success)"
                echo ""
            else
                sleep 1
                echo ""
                show_red "Ошибка (Fail)"
                echo ""
            fi

            show_orange "Скачивание архива (Downloading archive)..."
            sleep 1
            if wget https://github.com/hemilabs/heminetwork/releases/download/v0.4.3/heminetwork_v0.4.3_linux_amd64.tar.gz; then
                sleep 1
                echo ""
                show_green "Успешно (Success)"
                echo ""
            else
                sleep 1
                echo ""
                show_red "Ошибка (Fail)"
                echo ""
            fi

            show_orange "Распаковка архива (Extracting archive)..."
            sleep 1
            if tar -zxvf heminetwork_v0.4.3_linux_amd64.tar.gz; then
                sleep 1
                echo ""
                show_green "Успешно (Success)"
                echo ""
            else
                sleep 1
                echo ""
                show_red "Ошибка (Fail)"
                echo ""
            fi

            show_orange "Удаление архива (Deleting archive)..."
            sleep 1
            if rm heminetwork_v0.4.3_linux_amd64.tar.gz; then
                sleep 1
                echo ""
                show_green "Успешно (Success)"
                echo ""
            else
                sleep 1
                echo ""
                show_red "Ошибка (Fail)"
                echo ""
            fi

            show_orange "Проверяем popmd (Checking)..."
            sleep 1
            cd heminetwork_v0.4.3_linux_amd64/ && chmod +x popmd
            if ./popmd --help; then
                sleep 1
                echo ""
                show_green "Успешно (Success)"
                echo ""
            else
                sleep 1
                echo ""
                show_red "Ошибка (Fail)"
                echo ""
            fi

            show_orange "Генерация ключей (Generating keys)..."
            sleep 1
            if ./keygen -secp256k1 -json -net="testnet" > $HOME/popm-address.json; then
                sleep 1
                echo ""
                show_green "Успешно (Success)"
                echo ""
            else
                sleep 1
                echo ""
                show_red "Ошибка (Fail)"
                echo ""
            fi

            show_orange "Ищем данные (Looking for data) ..."
            sleep 1
            if eval $(jq -r '. | "ETHEREUM_ADDRESS=\(.ethereum_address)\nNETWORK=\(.network)\nPRIVATE_KEY=\(.private_key)\nPUBLIC_KEY=\(.public_key)\nPUBKEY_HASH=\(.pubkey_hash)"' ~/popm-address.json); then
                sleep 1
                echo ""
                show_green "Успешно (Success)"
                echo ""
            else
                sleep 1
                echo ""
                show_red "Ошибка (Fail)"
                echo ""
            fi

            show_orange "Вывод данных (Output data)..."
            echo ""
            echo "Ethereum Address: $ETHEREUM_ADDRESS"
            echo "Network: $NETWORK"
            echo "Private Key: $PRIVATE_KEY"
            echo "Public Key: $PUBLIC_KEY"
            echo "Public Key Hash: $PUBKEY_HASH"

            show_blue "-------------------------------------"
            show_orange "СОХРАНИТЕ ДАННЫЕ В НАДЕЖНОМ МЕСТЕ"
            echo ""
            show_orange "SAVE YOUR DATA IN A SECURE PLACE"
            show_blue "-------------------------------------"
            echo ""
            echo ""
            show_green "----- НОДА УСТАНОВЛЕНА. HEMI NODE INSTALLED! ------"
            echo ""
            ;;
        3)
            #Start or restart node
            show_orange "Закрываем screen сессию (Closing screen session)..."
            sleep 1
            if screen -r hemi -X quit; then
                ssleep 1
                echo ""
                show_green "Успешно (Success)"
                echo ""
            else
                sleep 1
                echo ""
                show_blue "Не найдена (Didn't find)"
                echo ""
            fi

            # get privat key from json
            show_orange "Ищем данные (Looking for data) ..."
            sleep 2
            eval $(jq -r '. | "PRIVATE_KEY=\(.private_key)"' ~/popm-address.json)

            # get data from user
            read -p "Введите комиссию (Enter FEE) [press enter for default 100]: " POPM_STATIC_FEE
            POPM_STATIC_FEE=${POPM_STATIC_FEE:-100}

            read -p "Укажите RPC (Enter RPC) [press enter for default]: " POPM_BFG_URL
            POPM_BFG_URL=${POPM_BFG_URL:-wss://testnet.rpc.hemi.network/v1/ws/public}

            # check and export data
            show_orange "Проверяем .bashrc (Cheking bashrc)..."
            sleep 1
            if FILE=$HOME/.bashrc; then
                echo ""
                show_green "Cуществует (Exist)..."
                sleep 2
                echo ""
            else
                echo ""
                show_blue "Создаем (Creating)..."
                sleep 2
                touch "$FILE"
                echo ""
            fi

            update_or_add() {
                local key="$1"
                local value="$2"

                if grep -q "^export $key=" "$FILE"; then
                    sed -i "s|^export $key=.*|export $key=$value|" "$FILE"
                else
                    echo "export $key=$value" >> "$FILE"
                fi
            }

            # If string exist, change it, else add
            update_or_add "POPM_BTC_PRIVKEY" "$PRIVATE_KEY"
            update_or_add "POPM_STATIC_FEE" "$POPM_STATIC_FEE"
            update_or_add "POPM_BFG_URL" "$POPM_BFG_URL"

            # session and start the node
            show_orange "Создаем и запускаем  (Creating and starting)..."
            sleep 1
            if screen -dmS hemi bash -c "./popmd; echo -ne '\r'"; then
                sleep 1
                show_green "НОДА ЗАПУЩЕНА И РАБОТАЕТ (NODE STARTED AND RUNNING)!!!"
                echo ""
                sleep 1
            else
                show_red "НЕ УДАЛОСЬ ЗАПУСТИТЬ НОДУ (FAILED TO START THE NODE)!!!!"
                echo ""
            fi

            ;;
        4)
            #about node
            echo ""
            show_orange "---------- ДАННЫЕ НОДЫ (NODE DATA) ----------"
            cat $HOME/popm-address.json
            show_orange "---------------------------------------------"
            echo ""
            ;;
        5)
            # deletting node
            show_orange "Удаляем ноду (Deletting node)..."
                sleep 2
                if screen -r hemi -X quit; then
                    ssleep 1
                    echo ""
                    show_green "Успешно (Success)"
                    echo ""
                else
                    sleep 1
                    echo ""
                    show_blue "Не найдена (Didn't find)"
                    echo ""
                fi

                if rm -rvf Hemi-node; then
                    sleep 1
                    echo ""
                    show_green "Успешно (Success)"
                    echo ""
                else
                    sleep 1
                    echo ""
                    show_red "Ошибка (Fail)"
                    echo ""
                fi

                echo ""
                show_green "----- HEMI НОДА УДАЛЕНА. HEMI NODE DELETED! ------"
                echo ""
            ;;
        6)
            # JSON Recovery
            show_orange "Начинаем восстановление. Starting data recovery"
            echo ""
            sleep 2

            show_orange "Ищем JSON фаил (Looking for JSON File)... "
            sleep 2
            if FILE="$HOME/popm-address.json"; then
                sleep 1
                echo ""
                show_green "Успешно (Success)"
                echo ""
            else
                sleep 1
                echo ""
                show_red "Не найден (Didn't find)"
                echo ""
                exit 1
            fi

            read -p "Введите новый Ethereum Address: " ethereum_address
            read -p "Введите новую сеть (network): " network
            read -p "Введите новый private key: " private_key
            read -p "Введите новый public key: " public_key
            read -p "Введите новый pubkey hash: " pubkey_hash

            jq --arg ethereum_address "$ethereum_address" \
            --arg network "$network" \
            --arg private_key "$private_key" \
            --arg public_key "$public_key" \
            --arg pubkey_hash "$pubkey_hash" \
            '.ethereum_address = $ethereum_address |
                .network = $network |
                .private_key = $private_key |
                .public_key = $public_key |
                .pubkey_hash = $pubkey_hash' "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"

            echo ""
            show_green "------ ФАИЛ ОБНОВЛЕН. FILE UPDATED ------"
            echo ""
            ;;
        7)
            # Stop script and exit
            echo -e "\e[31mСкрипт остановлен (Script stopped)\e[0m"
            echo ""
            exit 0
            ;;
        *)
            # incorrect options handling
            echo ""
            echo -e "\e[31mНеверная опция\e[0m. Пожалуйста, выберите из тех, что есть."
            echo ""
            echo -e "\e[31mInvalid option.\e[0m Please choose from the available options."
            echo ""
            ;;
    esac
done
