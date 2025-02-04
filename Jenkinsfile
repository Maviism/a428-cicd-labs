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
            }
        }
        stage('Test') {
            steps {
                sh 'chmod +x ./jenkins/scripts/test.sh' // fix ./jenkins/scripts/test.sh: Permission denied
                sh 'ls -la ./jenkins/scripts/'
                sh './jenkins/scripts/test.sh'
            }
        }
        stage('Deploy') {
            steps {
                sh 'chmod +x ./jenkins/scripts/deliver.sh' // update chmod to fix ./jenkins/scripts/deliver.sh: Permission denied
                sh './jenkins/scripts/deliver.sh'
                input message: 'Sudah selesai menggunakan React App? (Klik "Proceed" untuk mengakhiri)'
                sh 'chmod +x ./jenkins/scripts/kill.sh' // fix ./jenkins/scripts/kill.sh: Permission denied
                sh './jenkins/scripts/kill.sh'
            }
        }
    }
}