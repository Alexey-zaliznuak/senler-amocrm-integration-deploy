import os
import platform
import subprocess

# Определяем префикс sudo для Linux
sudo_prefix = "sudo " if platform.system() == "Linux" else ""

def execute(cmd: str):
    """
    Выполняет команды через subprocess, поддерживает sudo.
    """
    result = subprocess.run(sudo_prefix + cmd, shell=True, text=True)
    if result.returncode != 0:
        print(f"Ошибка выполнения команды: {cmd}")
    return result.returncode

# Обновляем git-репозитории
execute("git pull")
execute("git submodule update --init --recursive")

# Работа с поддиректориями
os.chdir("backend")
execute("git pull")
os.chdir("..")

os.chdir("frontend")
execute("git pull")
os.chdir("..")

# Запускаем docker-compose
execute("docker compose up --build -d")
