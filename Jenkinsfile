pipeline {
    agent any
    stages {

        stage('Qa') {
                    steps {
                      sh "trivy filesystem -f json results.json ."
                    }
        }
        stage('Build') {
            steps {
              sh "docker-compose build"
            }

          post {
                        success {
                            //junit 'build/test-results/test/*.xml'
                            //archiveArtifacts 'build/libs/*.jar'
                            //jacoco()
                            //recordIssues(tools: [pmdParser(pattern: 'build/reports/pmd/*.xml')])
                            //recordIssues(tools: [pit(pattern: 'build/reports/pitest/*.xml')])
                         recordIssues(tools: [trivy(pattern: 'results.json')])
                        }

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

