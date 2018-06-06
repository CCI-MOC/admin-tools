# Install everything
echo " (1/4) Install Packages"
bash -x "./install_packages.sh"
echo " (2/4) Install HIL"
bash -x "./install_hil.sh"
echo "(3/4) Install Postgres"
bash -x "./install_postgres.sh"
echo "(4/4) Configure HIL for development"
bash -x "./config_dev.sh"

echo "Finished everything"
