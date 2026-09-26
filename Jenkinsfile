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
        IMAGE_NAME = "python-app"
        IMAGE_TAG  = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Multi-stage Image') {
            steps {
                container(name: 'kaniko', shell: '/busybox/sh') {
                    sh """
                        /kaniko/executor \
                          --context=dir://\$WORKSPACE \
                          --dockerfile=Dockerfile \
                          --destination=${IMAGE_NAME}:${IMAGE_TAG} \
                          --no-push \
                          --verbosity=info
                    """
                }
            }
        }
    }

    post {
        success {
            echo "=============================================="
            echo "Multi-stage image built successfully!"
            echo "Image: ${IMAGE_NAME}:${IMAGE_TAG}"
            echo "=============================================="
        }
        failure {
            echo "Build failed"
        }
    }
}
