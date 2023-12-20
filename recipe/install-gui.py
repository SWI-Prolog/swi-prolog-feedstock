import subprocess

def install_component(c):
    if subprocess.run(["cmake", f"-DCMAKE_INSTALL_COMPONENT={c}", "-P", "cmake_install.cmake"],
                      cwd="build").returncode != 0:
        exit(1)

install_component("Graphics_subsystem")
