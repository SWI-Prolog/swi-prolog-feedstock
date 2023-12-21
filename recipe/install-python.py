import sys
sys.path.insert(1, "scripts")
import conda_utils
import subprocess
import glob
import os

# The SWI-Prolog library
conda_utils.install_component("Python_interface")

# Install the Python package
def install_janus():
    subprocess.run(["printenv"])          

    wheel = glob.glob("packages/swipy/dist/*.whl")[0];
    print(f"Installing wheel file {wheel}")
    print(f"sys.path = {sys.path}")

    if subprocess.run([ "python", "-m", "pip", "install",
                        "--prefix", os.environ["PREFIX"],
                        "--ignore-installed",
                        "-vvv",
                        wheel ]).returncode != 0:
        exit(1)

install_janus()
