pipeline {
    agent any

    stages {
        stage('Preparation') {
            steps {
                echo 'Preparation...'
            }
        }
        stage('Build') {
            steps {
                echo 'Building..'
                sh 'cat /etc/bash.bashrc'
                sh 'pwd'
                sh 'pwd'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
