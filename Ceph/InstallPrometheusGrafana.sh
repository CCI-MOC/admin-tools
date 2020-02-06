DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

sudo ceph mgr module enable prometheus

curl -s https://packagecloud.io/install/repositories/prometheus-rpm/release/script.rpm.sh | sudo bash
sudo yum -y install prometheus2 node_exporter
sudo /bin/cp $DIR/conf/prometheus/prometheus.yml /etc/prometheus/
sudo systemctl enable --now prometheus
sudo systemctl enable --now node_exporter

sudo echo '[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
'> /etc/yum.repos.d/grafana.repo

sudo yum -y install initscripts urw-fonts
sudo yum -y install grafana
sudo grafana-cli plugins install vonage-status-panel
sudo grafana-cli plugins install grafana-piechart-panel
sudo /bin/cp $DIR/conf/grafana/grafana.ini /etc/grafana/
sudo /bin/cp $DIR/conf/grafana/grafana.db /var/lib/grafana
sudo chown grafana:grafana /var/lib/grafana/grafana.db

sudo systemctl enable --now grafana-server

sudo ceph dashboard set-grafana-api-url http://localhost:3000
