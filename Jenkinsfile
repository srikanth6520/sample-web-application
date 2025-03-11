pipeline {
   agent any 

   environment {
       DOCKER_HUB_USERNAME = env.DOCKER_HUB_USERNAME
       IMAGE_NAME = "${IMAGE_NAME}"
       DOCKER_IMAGE = "${DOCKER_HUB_USERNAME}/${IMAGE_NAME}"
   }

   stages {
       stage ("Checkout Code") {
          steps {
              git branch: 'main', url: 'https://github.com/srikanth6520/sample-web-application.git'
          }
       }

       stage ("Build the Code") {
          steps {
              sh 'mvn clean package -DskipTests'
          }
       }

       stage ("Package the Artifacts") {
          steps {
              sh 'chmod +x ./build.sh'
              sh "BUILD_TAG=${BUILD_NUMBER} ./build.sh" 
          }
       }

       stage ("Archive the Artifacts") {
          steps {
              archiveArtifacts artifacts: "metadata.json", fingerprint: true
              currentBuild.description = "${BUILD_NUMBER}"
          }
       }

       stage ("Push Artifacts to Docker Hub") {
          steps {
              withDockerRegistry([credentialsId: 'docker-hub-credentials', url: 'https://index.docker.io/v1/']) {
                  sh "docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}" 
              }
          }
       }
       
       stage('Deploy to Tomcat') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'your-azure-vm-credentials', usernameVariable: 'AZURE_USER', passwordVariable: 'AZURE_PASSWORD')]) {
                        sh """
                        ssh -o StrictHostKeyChecking=no $AZURE_USER@your-azure-vm-ip -p 22 'sudo rm -rf /var/lib/tomcat9/webapps/your-app.war'
                        scp target/your-app.war $AZURE_USER@your-azure-vm-ip:/var/lib/tomcat9/webapps/
                        ssh -o StrictHostKeyChecking=no $AZURE_USER@your-azure-vm-ip -p 22 'sudo systemctl restart tomcat9'
                        """
                    }
                }
            }
        }
    }
}
