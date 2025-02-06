pipeline {
    agent {
        docker {
            image 'node:16' 
            args '-p 3000:3000' 
        }
    }
    environment {
        USER = 'maviism'              // Remote server username
        REMOTE_SERVER = '98.66.137.249' // Remote server IP or hostname
        REMOTE_PATH = '/var/www/html/dist'  // Target path for SCP
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
                sh 'sleep 60'
                script {
                    // Add remote server's SSH key to known_hosts automatically
                    sh '''
                        mkdir -p ~/.ssh
                        ssh-keyscan -H $REMOTE_SERVER >> ~/.ssh/known_hosts
                    '''

                    // SCP command using the SSH credentials
                    withCredentials([sshUserPrivateKey(credentialsId: 'my-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                        sh '''
                            scp -i $SSH_KEY -r ./build $USER@$REMOTE_SERVER:$REMOTE_PATH
                        '''
                    }
                }
                sh 'chmod +x ./jenkins/scripts/kill.sh' // fix ./jenkins/scripts/kill.sh: Permission denied
                sh './jenkins/scripts/kill.sh'
            }
        }
    }
}
