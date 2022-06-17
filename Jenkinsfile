pipeline {
    agent any
    stages {
        stage('Qa') {
          parallel{
            parallel1 {
                sh "trivy filesystem -f json -o results.json ."
                recordIssues(tools: [trivy(pattern: 'results.json')])
            }
            parallel2 {
                 sh"trivy image -f json -o results2.json vue-2048"
                 recordIssues(tools: [trivy(pattern: 'results2.json')])
            }
          }



                    //steps {
                      //sh "trivy filesystem -f json -o results.json ."
                      //recordIssues(tools: [trivy(pattern: 'results.json')])

                      //sh"trivy image -f json -o results2.json vue-2048"
                      //recordIssues(tools: [trivy(pattern: 'results2.json')])

                   // }
        }
        stage('Build') {
            steps {
              sh "docker-compose build"
            }

          //post {
                        //success {
                            //junit 'build/test-results/test/*.xml'
                            //archiveArtifacts 'build/libs/*.jar'
                            //jacoco()
                            //recordIssues(tools: [pmdParser(pattern: 'build/reports/pmd/*.xml')])
                            //recordIssues(tools: [pit(pattern: 'build/reports/pitest/*.xml')])
                        //}

          //}

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

