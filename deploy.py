import os
import platform


sudo_prefix = "sudo" if platform.system() == "Linux" else ""


def execute(cmd: str):
    os.system(sudo_prefix + cmd)


execute("git pull")
execute("git submodule update --init --recursive")
