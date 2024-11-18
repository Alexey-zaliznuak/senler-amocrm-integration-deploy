import os
import platform


sudo_prefix = "sudo " if platform.system() == "Linux" else ""


def execute(cmd: str):
    os.system(sudo_prefix + cmd)


execute("git pull")
execute("git submodule update --init --recursive")
execute("cd backend && git pull && cd ..")
execute("cd frontend && git pull && cd ..")
execute("docker compose up --build -d")