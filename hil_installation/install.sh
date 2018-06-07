# Install everything
echo " (1/4) Install Packages"
./install_packages.sh || exit 1
echo " (2/4) Install HIL"
./install_hil.sh || exit 1
echo "(3/4) Install Postgres"
./install_postgres.sh || exit 1
echo "(4/4) Configure HIL for development"
./config_dev.sh ||exit 1

echo "Finished everything"
