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
            steps {
                sh 'chmod +x ./jenkins/scripts/deliver.sh' // update chmod to fix ./jenkins/scripts/deliver.sh: Permission denied
                sh './jenkins/scripts/deliver.sh'
                // sleep 1 minute
                sh 'sleep 60'
                sh 'chmod +x ./jenkins/scripts/kill.sh' // fix ./jenkins/scripts/kill.sh: Permission denied
                sh './jenkins/scripts/kill.sh'
                 // Stop and remove old container if exists
                sh '''
                docker stop myapp-production || true
                docker rm myapp-production || true
                '''

                // Run the React app inside a Node.js container
                sh '''
                docker run -d --name myapp-production -p 3001:3001 -v $(pwd):/app -w /app node:16-buster-slim sh -c "npm install && npm run build && npm install -g serve && serve -s build -l 3001"
                '''
                        
            }
        }
    }
}