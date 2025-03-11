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
       
       stage ("Deploy to Kubernetes") {
           steps {
               script {
                   def releaseName = "my-app"  // Helm release name
                   def chartPath = "./my-app/helm"  // Path to Helm chart
                   def namespace = "default"  // Kubernetes namespace
            
                   // Deploy using Helm
                   sh """
                   helm upgrade --install ${releaseName} ${chartPath} \
                    --set image.repository=${DOCKER_IMAGE} \
                    --set image.tag=${BUILD_NUMBER} \
                    --namespace ${namespace}
                   """
               }
           }
       }
   }
}
