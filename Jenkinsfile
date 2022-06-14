
pipeline {
    agent any
    options {
        ansiColor('xterm')
        timestamps ()
        disableConcurrentBuilds ()
        builDiscarder(logRotaror(numToKeepStr: '5', artifactNumToKeepStr: '5'))
    }

    
    stages {
        stage('Build') {
            steps {
              sh "docker-compose build"
            }
    }
    stage('Publish') {
                 steps{
                    sshagent(['github-ssh']){
                        sh 'git tag BUILD-1.0.${BUILD_NUMBER}'
                        sh 'git push --tags'
                    }
                }
            }
    }
}
