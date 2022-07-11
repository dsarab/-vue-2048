pipeline {
  agent any
  def build = 0
  options{
    ansiColor('xterm')

  }
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


    stage('Build Kubernetes') {
      steps {
        withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'cert-kubernetes', namespace: 'default', serverUrl: 'https://192.168.49.2:8443') {
            sh "kubectl apply -f kubernetes/vue2048.yaml"
        }
      }
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

    if (build == 1) {
      stage('Terraform') {
        steps {
          withAWS(credentials: 'aws', region: 'eu-west-1') {
            sh 'terraform -chdir=terraform init'
            sh 'terraform -chdir=terraform fmt'
            sh 'terraform -chdir=terraform validate'
            sh 'terraform -chdir=terraform apply --auto-approve'
          }
        }
      }

      stage('Ansible') {
        steps {
          withAWS(credentials: 'aws', region: 'eu-west-1') {
            //sh 'ansible-playbook -i ansible/aws_ec2.yml ec2_provision.yml'
            ansiblePlaybook credentialsId: 'ssh-ansible', inventory: 'ansible/aws_ec2.yml', disableHostKeyChecking: true, playbook: 'ansible/ec2_provision.yml', colorized: true
          }
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
