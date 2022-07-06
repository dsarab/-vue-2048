pipeline {
  agent any
  stages {

    //stage('Parallel qa') {
    //parallel{

    //stage('Parallel1'){
    //steps{
    // sh "trivy filesystem -f json -o results.json ."
    //recordIssues(tools: [trivy(id: 'repo', pattern: 'results.json')])
    // }
    //}
    //stage('Parallel2'){
    //  steps{
    //       sh "trivy image -f json -o results2.json nginx:latest"
    //        recordIssues(tools: [trivy(id: 'image', pattern: 'results2.json')])
    //   }
    // }

    //  }

    //}
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
    stage('Dockerhub') {
      steps {
        withCredentials([usernamePassword(credentialsId: '8cfe86f5-3821-4503-a33b-76e79a25789d', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
          sh 'echo "${PASS}" | docker login -u ${USER} --password-stdin'
          //sh 'docker tag vue-2048 ${USER}/2048:latest'  al añadir en el dockercompose el nombre de la imagen tageada
          sh 'docker tag vue-2048 ${USER}/2048:BUILD-1.0.${BUILD_NUMBER}'
          sh 'docker push ${USER}/2048:latest'
          sh 'docker push ${USER}/2048:BUILD-1.0.${BUILD_NUMBER}'
        }
      }
    }
    stage('GitHubregistry') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'git.token', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
          sh 'echo ${PASS} | docker login ghcr.io -u dsarab --password-stdin'
          sh 'docker tag ${USER}/2048:latest ghcr.io/${USER}/2048:latest'
          sh 'docker tag ${USER}/2048:latest ghcr.io/${USER}/2048:BUILD-1.0.${BUILD_NUMBER}'
          sh 'docker push ghcr.io/${USER}/2048:latest'
          sh 'docker push ghcr.io/${USER}/2048:BUILD-1.0.${BUILD_NUMBER}'

        }
      }
    }
    stage('Aws') {
      steps {
        withAWS(credentials: 'aws', region: 'eu-west-1') {
          ansiblePlaybook credentialsId: 'ssh-ansible', disableHostKeyChecking: true, playbook: 'ansible/ec2_docker.yaml', colorized: true
        }
      }
    }
    stage('Publish') {
      steps {
        sshagent(['github-ssh2']) {
          sh 'git tag BUILD-1.0.${BUILD_NUMBER}'
          sh 'git push --tags'
        }
      }
    }
  }
}
