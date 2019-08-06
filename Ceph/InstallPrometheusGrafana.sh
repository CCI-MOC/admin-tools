DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

sudo ceph mgr module enable prometheus

curl -s https://packagecloud.io/install/repositories/prometheus-rpm/release/script.rpm.sh | sudo bash
sudo yum -y install prometheus2 node_exporter
sudo /bin/cp $DIR/conf/prometheus/prometheus.yml /etc/prometheus/
sudo systemctl enable --now prometheus
sudo systemctl enable --now node_exporter

sudo yum -y install initscripts urw-fonts
sudo yum -y install https://dl.grafana.com/oss/release/grafana-6.3.0-1.x86_64.rpm
sudo grafana-cli plugins install vonage-status-panel
sudo grafana-cli plugins install grafana-piechart-panel
sudo /bin/cp $DIR/conf/grafana/grafana.ini /etc/grafana/
sudo /bin/cp $DIR/conf/grafana/grafana.db /var/lib/grafana
sudo chown grafana:grafana /var/lib/grafana/grafana.db

sudo systemctl enable --now grafana-server

sudo ceph dashboard set-grafana-api-url http://localhost:3000
