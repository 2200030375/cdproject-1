pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/2200030375/book-app-cicd.git'
            }
        }
        stage('Build') {
            steps {
                sh '''
                    npm install
                    npm run build
                '''
            }
        }
        stage('Deploy') {
            steps {
                sh 'ansible-playbook ansible/playbook.yml -i ansible/inventory'
            }
        }
        stage('Health Check') {
            steps {
                script {
                    def status = sh(script: 'bash scripts/health_check.sh', returnStatus: true)
                    if (status != 0) {
                        error("Health check failed. Triggering rollback.")
                    }
                }
            }
        }
        stage('Save Last Good Commit') {
            when {
                expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
            }
            steps {
                sh 'bash scripts/save_last_good_commit.sh'
            }
        }
    }
    post {
        failure {
            echo "Rolling back due to failure."
            sh 'ansible-playbook ansible/rollback.yml -i ansible/inventory'
        }
    }
}
