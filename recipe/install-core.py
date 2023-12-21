import sys
sys.path.insert(1, "scripts")
import conda_utils

conda_utils.install_component("Core_system")
conda_utils.install_component("Core_packages")
