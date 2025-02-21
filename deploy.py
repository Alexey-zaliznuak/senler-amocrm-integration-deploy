import platform
import subprocess

sudo_prefix = "sudo " if platform.system() == "Linux" else ""

def execute(cmd: str):
    result = subprocess.run(sudo_prefix + cmd, shell=True, text=True)
    if result.returncode != 0:
        print(f"Ошибка выполнения команды: {cmd}")
    return result.returncode

execute("git pull")
execute("git submodule update --init --recursive")

execute("docker compose up --build -d")

execute("docker system prune -f")
