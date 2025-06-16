pipeline {
    agent any

    environment {
        IMAGE_NAME = "flask-app"
        IMAGE_TAR = "flask-app.tar"
    }

    stages {
        stage('Clone Code') {
            steps {
                git 'https://github.com/Manasi6901/ci-cd-pipeline-project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Save Image to Tar') {
            steps {
                sh 'docker save $IMAGE_NAME -o $IMAGE_TAR'
            }
        }

        stage('Run Ansible Deployment') {
            steps {
                sh 'ansible-playbook -i inventory ansible/deploy.yml'
            }
        }
    }
}

