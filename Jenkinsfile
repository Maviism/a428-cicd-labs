pipeline {
    agent {
        docker {
            image 'node:16-buster-slim' 
            args '-p 3000:3000'
        }
    }
    stages {
        stage('Build') { 
            steps {
                sh 'npm install'
                sh 'npm run build'
            }
        }
        stage('Test') {
            steps {
                sh 'chmod +x ./jenkins/scripts/test.sh'
                sh './jenkins/scripts/test.sh'
            }
        }
        stage('Manual Approval') {
            steps {
                input message: 'Lanjut ke tahap deploy?'
            }
        }
        stage('Deploy') {
            agent { label 'docker-node' }
            steps {
                script {
                    sh '''
                    apt-get update && apt-get install -y sshpass
                    chmod +x ./jenkins/scripts/deploy.sh
                    ./jenkins/scripts/deploy.sh
                    '''
                }
            }
        }
    }
}
