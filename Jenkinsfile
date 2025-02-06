pipeline {
    agent {
        docker {
            image 'node:16' 
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
        stage('Manual Approval') {
            steps {
                input message: 'Lanjut ke tahap deploy?'
            }
        }
        stage('Deploy') {
            steps {
                sh 'chmod +x ./jenkins/scripts/deliver.sh' // update chmod to fix ./jenkins/scripts/deliver.sh: Permission denied
                sh './jenkins/scripts/deliver.sh'
                // sleep 1 minute
                // sh 'sleep 60'
                // deploy to production
                sh 'ls -la'
                script {
                    // SCP command using the SSH credentials
                    withCredentials([sshUserPrivateKey(credentialsId: 'my-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                        sh '''
                            scp -i $SSH_KEY -r ./dist maviism@98.66.137.249:/var/www/html/dist
                        '''
                    }
                }
                sh 'chmod +x ./jenkins/scripts/kill.sh' // fix ./jenkins/scripts/kill.sh: Permission denied
                sh './jenkins/scripts/kill.sh'
            }
        }
    }
}