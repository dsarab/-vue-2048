pipeline {
    agent any
    stages{

        stage('Parallel qa') {
          parallel{

            stage('Parallel1'){
              steps{
                  sh "trivy filesystem -f json -o results.json ."
                  recordIssues(tools: [trivy(id: 'repo', pattern: 'results.json')])

              }
            }
            stage('Parallel2'){
              steps{

                    sh "trivy image -f json -o results2.json nginx:latest"
                    recordIssues(tools: [trivy(id: 'image', pattern: 'results2.json')])

              }

            }

            }

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
                         //recordIssues(tools: [trivy(pattern: 'results.json')])
                         //recordIssues(tools: [trivy(pattern: 'results2.json')])

                        //}

          //}

        }

        stage('Publish') {
                 steps{
                    sshagent(['github-ssh2']){
                        sh 'git tag BUILD-1.0.${BUILD_NUMBER}'
                        sh 'git push --tags'
                    }
                }
            }
        }
    }
