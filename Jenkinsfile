pipeline {
    agent {
        kubernetes {
            yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command:
    - sleep
    args:
    - 99d
    volumeMounts:
    - name: docker-config
      mountPath: /kaniko/.docker
  volumes:
  - name: docker-config
    emptyDir: {}
"""
        }
    }

    stages {
        stage('Build with Kaniko') {
            steps {
                container('kaniko') {
                    sh '''
                        /kaniko/executor \
                          --context=dir://$(pwd) \
                          --dockerfile=Dockerfile \
                          --destination=python-app:latest \
                          --no-push
                    '''
                }
            }
        }
    }
}
