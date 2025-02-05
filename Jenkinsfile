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
        stage('Manual Approval') {
            steps {
                input message: 'Lanjut ke tahap deploy?'
            }
        }
        stage('Deploy') {
            // Run on the Jenkins host (not inside the agent container)
            agent none 
            steps {
                script {
                    // Ensure Docker is available on the host
                    sh 'docker --version'

                    // Stop & remove old container if exists
                    sh '''
                    docker stop myapp-production || true
                    docker rm myapp-production || true
                    '''

                    // Run React app inside a Node.js container
                    sh '''
                    docker run -d --name myapp-production -p 3001:3001 \
                        -v $(pwd):/app -w /app node:16-buster-slim \
                        sh -c "npm install && npm run build && npm install -g serve && serve -s build -l 3001"
                    '''
                }
            }
        }
    }
}