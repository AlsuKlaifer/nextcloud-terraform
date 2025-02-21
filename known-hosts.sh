#!/bin/sh

# Скрипт для безопасного добавления SSH-ключа сервера в known_hosts

set -e

# Получение IP-адреса сервера из аргумента
server_ip="${1:-}"

if [ -z "$server_ip" ]; then
    echo "Ошибка: Необходимо указать IP-адрес сервера." >&2
    exit 1
fi

ssh_config_dir="${HOME}/.ssh"
known_hosts_file="${ssh_config_dir}/known_hosts"
temp_log="/tmp/ssh_scan.log"

# Подготовка SSH-конфигурации
prepare_ssh_env() {
    [ -d "$ssh_config_dir" ] || mkdir -m 700 "$ssh_config_dir"
    [ -f "$known_hosts_file" ] || touch "$known_hosts_file"
    chmod 600 "$known_hosts_file"
}

# Добавление ключа сервера с повторами
add_ssh_key() {
    local attempts=0
    local max_attempts=10
    local delay=5

    echo "Добавление сервера $server_ip в known_hosts..."

    while [ "$attempts" -lt "$max_attempts" ]; do
        if ssh-keyscan -H "$server_ip" >> "$known_hosts_file" 2> "$temp_log"; then
            echo "✔ Сервер $server_ip успешно добавлен."
            return 0
        fi
        attempts=$((attempts + 1))
        echo "⚠ Попытка $attempts не удалась. Ожидание $delay сек..."
        sleep "$delay"
    done

    echo "❌ Ошибка: Не удалось получить ключ сервера $server_ip после $max_attempts попыток." >&2
    cat "$temp_log" >&2
    return 1
}

# Очистка временных файлов
clean_up() {
    rm -f "$temp_log"
}

# Запуск всех этапов
main() {
    prepare_ssh_env
    add_ssh_key && clean_up
}

main
