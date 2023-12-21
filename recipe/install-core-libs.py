import sys
sys.path.insert(1, "scripts")
import conda_utils

conda_utils.install_component("Core_packages")
conda_utils.install_component("YAML_support")
conda_utils.install_component("TIPC_networking")
conda_utils.install_component("Commandline_editors")
