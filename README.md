# Grafana task
## Description
This repository is a collection of Terraform modules with provisioning shell script designed to automate the process of provisioning an instance in Amazon Web Services (AWS) and providing access to the Grafana dashboard. Provisioning shell script setup Docker, Node Exporter, Prometheus and Grafana on AWS instance.
## Prerequisites

- You need to clone current repo
- In current directory run ssh-keygen and use key id_rsa
-You need to edit variables.tf with your own AWS Access and Secret keys from IAM
- Run "terraform init" then "terraform apply"
- Login to ip:3000 with credentials admin:admin 

## Technologies used

- AWS
- Terraform
- Docker
- Node Exporter
- Prometheus
- Grafana
- Git
