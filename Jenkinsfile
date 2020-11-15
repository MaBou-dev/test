pipeline {
    agent {
        docker { image 'debian:10' }
    }
    stages {
        stage ('Static Test') {
            steps {
                echo 'Testing...'
            }
        }
        stage ('Build') {
            steps {
                echo 'Building...'
            }
        }
        stage ('Test') {
            steps {
                echo 'Testing...'
            }
        }
        stage ('Deploy') {
            steps {
                echo 'Deploying...'
            }
        }
    }
}
