#!/bin/bash

sudo yum update -y
sudo yum install -y docker 
sudo systemctl start docker
sudo systemctl enable docker 

sudo mkdir -p /home/ec2-user/grafana/provisioning/datasources /home/ec2-user/grafana/provisioning/dashboards
sudo curl -o /home/ec2-user/grafana/provisioning/dashboards/dashboard.json https://grafana.com/api/dashboards/10180/revisions/1/download
sed -i 's/DS_PROMETHEUS/Prometheus/g' /home/ec2-user/grafana/provisioning/dashboards/dashboard.json
sed -i 's/${Prometheus}/Prometheus/g' /home/ec2-user/grafana/provisioning/dashboards/dashboard.json



echo "global:
  scrape_interval: 1m

scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 1m
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node'
    static_configs:
      - targets: ['node-exporter:9100']" | sudo tee /etc/prometheus/prometheus.yml



echo "datasources:
 - name: Prometheus
   access: proxy
   type: prometheus
   url: http://prometheus:9090
   isDefault: true" | sudo tee /home/ec2-user/grafana/provisioning/datasources/prometheus_ds.yml

echo "apiVersion: 1

providers:
  - name: Default # A uniquely identifiable name for the provider
    folder: Linux Host # The folder where to place the dashboards
    type: file
    options:
      path: /etc/grafana/provisioning/dashboards" | sudo tee /home/ec2-user/grafana/provisioning/dashboards/host_metrics.yml



sudo docker volume create grafana-data
sudo docker volume create prometheus-data

sudo docker run -d \
  --name node-exporter \
  --restart unless-stopped \
  -v /proc:/host/proc:ro \
  -v /sys:/host/sys:ro \
  -v /:/rootfs:ro \
  -p 9100:9100 \
  prom/node-exporter:latest \
  --path.procfs=/host/proc \
  --path.rootfs=/rootfs \
  --path.sysfs=/host/sys \
  --collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)




# Prometheus
sudo docker run -d --name=prometheus -p 9090:9090 prom/prometheus -v /etc/prometheus:/etc/prometheus -v prometheus-data:/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/prometheus --web.console.libraries=/etc/prometheus/console_libraries --web.console.templates=/etc/prometheus/consoles --web.enable-lifecycle

# Grafana
sudo docker run -d --name=grafana -p 3000:3000 -v /home/ec2-user/grafana/provisioning/:/etc/grafana/provisioning -v grafana-data:/var/lib/grafana grafana/grafana









# Prometheus
#sudo docker run -d --name=prometheus -p 9090:9090 -v /etc/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml -v prometheus-data:/prometheus prom/prometheus:latest

#sudo docker run -d --name=prometheus -p 9090:9090 -v /etc/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml -v prometheus-data:/prometheus prom/prometheus:latest --storage.tsdb.path=/prometheus --web.console.libraries=/etc/prometheus/console_libraries --web.console.templates=/etc/prometheus/consoles --web.enable-lifecycle
#node 
#sudo docker run -d --name=node-exporter --net="host" --pid="host" -v "/:/host:ro,rslave" quay.io/prometheus/node-exporter:v1.2.2 --path.procfs=/host/proc --path.rootfs=/host --path.sysfs=/host/sys --collector.filesystem.ignored-mount-points="^/(sys|proc|dev|host|etc)($$|/)"
