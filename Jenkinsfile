
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                // Chicken-and-egg problem
                // git branch: 'main', url: 'https://github.com/devops-summer22/hello-springrest.git'
                sh "docker-compose build"
            }
            
        }
      
    }
}