pipeline {
    agent any

    environment {
        IMAGE_NAME = "python-app"
        IMAGE_TAG  = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the image
                    sh """
                        docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    """
                }
            }
        }

        stage('List Images') {
            steps {
                sh 'docker images | grep python-app'
            }
        }

        // Optional: Push to Docker Hub / ECR / Harbor
        /*
        stage('Push Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin
                        docker tag ${IMAGE_NAME}:${IMAGE_TAG} \$DOCKER_USER/${IMAGE_NAME}:${IMAGE_TAG}
                        docker push \$DOCKER_USER/${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }
        */
    }

    post {
        always {
            echo "Docker build pipeline finished"
        }
        success {
            echo "Image ${IMAGE_NAME}:${IMAGE_TAG} built successfully"
        }
        failure {
            echo "Docker build failed"
        }
    }
}
