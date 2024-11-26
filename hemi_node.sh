#!/bin/bash

tput reset
tput civis

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

exit_script() {
    show_red "Скрипт остановлен (Script stopped)"
        echo ""
        exit 0
}

incorrect_option () {
    echo ""
    show_red "Неверная опция. Пожалуйста, выберите из тех, что есть."
    echo ""
    show_red "Invalid option. Please choose from the available options."
    echo ""
}

process_notification() {
    local message="$1"
    show_orange "$message"
    sleep 1
}

run_commands() {
    local commands="$*"

    if eval "$commands"; then
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
}

run_commands_info() {
    local commands="$*"

    if eval "$commands"; then
        sleep 1
        echo ""
        show_green "Успешно (Success)"
        echo ""
    else
        sleep 1
        echo ""
        show_blue "Не найдена (Didn't find)"
        echo ""
    fi
}

show_orange "  __    __   _______ .___  ___.  __ " && sleep 0.2
show_orange " |  |  |  | |   ____||   \/   | |  | " && sleep 0.2
show_orange " |  |__|  | |  |__   |  \  /  | |  | " && sleep 0.2
show_orange " |   __   | |   __|  |  |\/|  | |  | " && sleep 0.2
show_orange " |  |  |  | |  |____ |  |  |  | |  | " && sleep 0.2
show_orange " |__|  |__| |_______||__|  |__| |__| " && sleep 0.2
echo ""
sleep 1

while true; do
    echo "1. Подготовка к установке Hemi (Preparation)"
    echo "2. Установка Hemi (Installation)"
    echo "3. Запуск/перезапуск/остановка (Start/Restart/Stop)"
    echo "4. О ноде (About node)"
    echo "5. Логи (Logs)"
    echo "6. Обновить (Update)"
    echo "7. Удалить ноду (Delete node)"
    echo "8. Восстановление (Restore)"
    echo "9. Деплой контракта (Contract deploy)"
    echo "10. Выход (Exit)"
    echo ""
    read -p "Выберите опцию (Select option): " option

    case $option in
        1)
            process_notification "Начинаем подготовку (Starting preparation)..."
            # Update and install packages
            cd $HOME
            process_notification "Обновляем и устанавливаем пакеты (Updating and installing packages)..."
            run_commands "sudo apt update && sudo apt upgrade -y && sudo apt install -y curl sed git jq lz4 build-essential screen nano unzip mc"
            ;;
        2)
            # install node
            process_notification "Начинаем установку (Starting installation)..."
            echo ""

            process_notification "Создание папки (Creating folder)..."
            run_commands "mkdir Hemi-Node && cd Hemi-Node"

            process_notification "Скачивание архива (Downloading archive)..."
            LATEST_VERSION=$(curl -s https://api.github.com/repos/hemilabs/heminetwork/releases/latest | grep "tag_name" | cut -d '"' -f 4)
            show_green "LATEST VERSION = $LATEST_VERSION"
            run_commands "wget https://github.com/hemilabs/heminetwork/releases/download/${LATEST_VERSION}/heminetwork_${LATEST_VERSION}_linux_amd64.tar.gz"

            process_notification "Распаковка архива (Extracting archive)..."
            run_commands "tar --strip-components=1 -xzvf heminetwork_${LATEST_VERSION}_linux_amd64.tar.gz && rm heminetwork_${LATEST_VERSION}_linux_amd64.tar.gz"

            process_notification "Проверяем popmd (Checking)..."
            # cd heminetwork_v0.4.3_linux_amd64/
            chmod +x ./popmd
            ./popmd --help
            echo ""

            process_notification "Генерация ключей (Generating keys)..."
            run_commands "./keygen -secp256k1 -json -net="testnet" > $HOME/popm-address.json"

            process_notification "Ищем данные (Looking for data) ..."
            if eval $(jq -r '. | "ETHEREUM_ADDRESS=\(.ethereum_address)\nNETWORK=\(.network)\nPRIVATE_KEY=\(.private_key)\nPUBLIC_KEY=\(.public_key)\nPUBKEY_HASH=\(.pubkey_hash)"' ~/popm-address.json); then
                sleep 1
                show_green "Успешно (Success)"
                echo ""
            else
                sleep 1
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

            show_blue "-----------------------------------"
            show_orange "СОХРАНИТЕ ДАННЫЕ В НАДЕЖНОМ МЕСТЕ"
            echo ""
            show_orange "SAVE YOUR DATA IN A SECURE PLACE"
            show_blue "-----------------------------------"
            echo ""
            show_green "----- НОДА УСТАНОВЛЕНА. HEMI NODE INSTALLED! ------"
            echo ""
            ;;
        3)
            #Start or restart node
            echo
            while true; do
                show_orange "Выберите (Choose):"
                echo "1. Запусить/перезапустить (Start/Restart)"
                echo "2. Остановить (Stop)"
                echo "3. Выход (Exit)"
                echo ""

                read -p "Введите номер опции (Enter option number): " option

                case $option in
                    1)
                        # Start or restart
                        process_notification "Закрываем screen сессию (Closing screen session)..."
                        run_commands_info "screen -r hemi -X quit"

                        # get privat key from json
                        show_orange "Ищем данные (Looking for data) ..."
                        sleep 1
                        eval $(jq -r '. | "PRIVATE_KEY=\(.private_key)"' ~/popm-address.json)
                        echo ""

                        # get data from user
                        read -p "Введите комиссию (Enter FEE) [press enter for default 100]: " POPM_STATIC_FEE
                        POPM_STATIC_FEE=${POPM_STATIC_FEE:-100}

                        read -p "Укажите RPC (Enter RPC) [press enter for default]: " POPM_BFG_URL
                        POPM_BFG_URL=${POPM_BFG_URL:-wss://testnet.rpc.hemi.network/v1/ws/public}
                        echo ""

                        # check and export data
                        show_orange "Проверяем .bashrc (Cheking bashrc)..."
                        sleep 1
                        FILE=$HOME/.bashrc
                        if [ -f "$HOME/.bashrc" ]; then
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
                        process_notification "Создаем и запускаем  (Creating and starting)..."
                        if screen -dmS hemi && screen -S hemi -X stuff "cd $HOME/Hemi-Node && ./popmd\n"; then
                            sleep 1
                            show_green "НОДА ЗАПУЩЕНА И РАБОТАЕТ (NODE STARTED AND RUNNING)!!!"
                            echo ""
                        else
                            show_red "НЕ УДАЛОСЬ ЗАПУСТИТЬ НОДУ (FAILED TO START THE NODE)!!!!"
                            echo ""
                        fi
                        ;;
                    2)
                        # stop
                        process_notification "Закрываем screen сессию (Closing screen session)..."
                        run_commands_info "screen -r hemi -X quit"
                        ;;
                    3)
                        break
                        ;;
                    *)
                        incorrect_option
                        ;;
                esac
            done
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
            #check logs
            screen -r hemi
            ;;
        6)
            #update
            echo ""
            show_orange "----- Зарезервировано. TBA. -----"
            echo ""
            ;;
        7)
            # deletting node
            process_notification "Удаляем ноду (Deletting node)..."
            echo ""

            process_notification "Останавливаем сессию (Stopping session)..."
            run_commands_info "screen -r hemi -X quit"

            process_notification "Удаляем папку (Deleting folder)..."
            run_commands_info "sudo rm -rvf $HOME/Hemi-Node"

            show_green "----- HEMI НОДА УДАЛЕНА. HEMI NODE DELETED! ------"
            echo ""
            ;;
        8)
            # JSON Recovery
            process_notification "Начинаем восстановление. Starting data recovery"
            echo ""

            process_notification "Ищем JSON фаил (Looking for JSON File)... "
            if [ -f "$HOME/popm-address.json" ]; then
                sleep 1
                echo ""
                show_green "Успешно (Success)"
                echo ""
                FILE="$HOME/popm-address.json"

                read -p "Введите (enter) Ethereum Address: " ethereum_address
                read -p "Введите сеть (enter network): " network
                read -p "Введите (enter) private key: " private_key
                read -p "Введите (enter) public key: " public_key
                read -p "Введите (enter) pubkey hash: " pubkey_hash

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
            else
                sleep 1
                echo ""
                show_red "Не найден (Didn't find)"
                echo ""
            fi
            ;;

        9)
            # contract deploy
            cd $HOME && \
            curl -O https://raw.githubusercontent.com/Alexjptz/Hemi-node/main/contract_deploy.sh && \
            chmod +x contract_deploy.sh && \
            ./contract_deploy.sh && \
            rm $HOME/contract_deploy.sh
            ;;
        10)
            # Stop script and exit
            exit_script
            ;;
        *)
            # incorrect options handling
            incorrect_option
            ;;
    esac
done
