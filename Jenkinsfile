pipeline {
    agent {
        kubernetes {
            yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:v1.23.2-debug
    command:
    - sleep
    args:
    - 99d
"""
        }
    }

    environment {
        DOCKERHUB_USERNAME = "your-dockerhub-username"   // ← Change this
        IMAGE_NAME         = "python-app"
        IMAGE_TAG          = "latest"
        FULL_IMAGE_NAME    = "${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Push Multi-stage Image') {
            steps {
                container(name: 'kaniko', shell: '/busybox/sh') {
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh '''
                            mkdir -p /kaniko/.docker

                            echo "{\\"auths\\":{\\"https://index.docker.io/v1/\\":{\\"username\\":\\"$DOCKER_USER\\",\\"password\\":\\"$DOCKER_PASS\\"}}}" > /kaniko/.docker/config.json

                            /kaniko/executor \
                              --context=dir://$WORKSPACE \
                              --dockerfile=Dockerfile \
                              --destination=$FULL_IMAGE_NAME \
                              --verbosity=info
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo "=============================================="
            echo "Multi-stage image built and pushed successfully!"
            echo "Image → ${FULL_IMAGE_NAME}"
            echo "=============================================="
        }
        failure {
            echo "Build or Push failed"
        }
    }
}
