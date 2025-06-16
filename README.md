# CI/CD Pipeline: Jenkins + Ansible + Docker (Manual Build, No DockerHub)

This project demonstrates a fully automated **CI/CD pipeline** using **Jenkins**, **Docker**, and **Ansible** to:
- Pull source code from Git
- Build a Docker image from scratch (no DockerHub)
- Save the image as a tar file
- Use Ansible to transfer and deploy the container on a remote Linux server

---

## 🚀 Tech Stack

- **Jenkins**: Continuous Integration / Orchestration
- **Docker**: Containerization (image built from scratch)
- **Ansible**: Configuration management & remote deployment
- **Python Flask**: Sample app for testing

---

## 📁 Project Structure

ci-cd-pipeline-project/
├── app/
│ └── app.py # Simple Python Flask app
├── Dockerfile # Custom base image (Ubuntu)
├── flask-app.tar # Docker image archive (generated during pipeline)
├── Jenkinsfile # CI/CD pipeline definition
├── ansible/
│ └── deploy.yml # Ansible playbook for deployment
├── inventory # Ansible inventory file
└── README.md

yaml
Copy code

---

## 🐳 Dockerfile

Builds a container image **from Ubuntu**, installs dependencies manually (no DockerHub base images used).

```Dockerfile
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y python3 python3-pip
WORKDIR /app
COPY app/ /app/
RUN pip3 install flask

CMD ["python3", "app.py"]
📜 Ansible Playbook (ansible/deploy.yml)
Handles:

Removing old containers

Copying image tar

Loading image

Running container on remote target server

yaml
Copy code
- name: Deploy Flask App Container
  hosts: appserver
  become: true
  tasks:
    - name: Stop existing container
      shell: docker rm -f flask-app || true

    - name: Copy Docker image
      copy:
        src: ../flask-app.tar
        dest: /tmp/flask-app.tar

    - name: Load Docker image
      shell: docker load -i /tmp/flask-app.tar

    - name: Run Docker container
      shell: docker run -d --name flask-app -p 5000:5000 flask-app
📄 Ansible Inventory
Update this file with your target server details:

ini
Copy code
[appserver]
<REMOTE_SERVER_IP> ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa
⚙️ Jenkins Pipeline (Jenkinsfile)
This pipeline executes the entire CI/CD process:

groovy
Copy code
pipeline {
    agent any

    environment {
        IMAGE_NAME = "flask-app"
        IMAGE_TAR = "flask-app.tar"
    }

    stages {
        stage('Clone Code') {
            steps {
                git 'https://github.com/<your-username>/ci-cd-pipeline-project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Save Docker Image') {
            steps {
                sh 'docker save $IMAGE_NAME -o $IMAGE_TAR'
            }
        }

        stage('Deploy via Ansible') {
            steps {
                sh 'ansible-playbook -i inventory ansible/deploy.yml'
            }
        }
    }
}
🛠️ Prerequisites
Jenkins Server
Git, Docker, Ansible installed

Jenkins plugins:

Pipeline

Git plugin

Ansible plugin

Remote Server (target VM)
Docker installed

SSH key access configured from Jenkins

✅ How It Works
Jenkins clones the repo

Builds Docker image locally (no DockerHub)

Exports the image to flask-app.tar

Ansible uploads and deploys the image on the remote VM

App runs and is accessible on http://<REMOTE_SERVER_IP>:5000/

🧪 Test the App
Visit your deployed app:

cpp
Copy code
http://<REMOTE_SERVER_IP>:5000/
Expected Output:

csharp
Copy code
Hello from CI/CD Pipeline App!
🔐 Security Tips
Do not hard-code credentials in playbooks or Jenkinsfile.

Use Jenkins credentials store and Ansible vault.

Limit SSH access to Jenkins server IP only.
