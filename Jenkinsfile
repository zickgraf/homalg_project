pipeline {
    agent any

    stages {
        state('Preparation')
            steps {
                echo 'Preparation...'
            }
        }
        stage('Build') {
            steps {
                echo 'Building..'
                sh 'cat /etc/bash.bashrc'
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
