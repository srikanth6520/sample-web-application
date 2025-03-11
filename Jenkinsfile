pipeline {
    agent any 

    environment {
        // Fetch values dynamically from the shell script
        DOCKER_ENV = sh(script: 'source ./build.sh && echo "DOCKER_HUB_USERNAME=$DOCKER_HUB_USERNAME IMAGE_NAME=$IMAGE_NAME GIT_REPO=$GIT_REPO GIT_BRANCH=$GIT_BRANCH"', returnStdout: true).trim()
    }

    stages {
        stage ("Checkout Code") {
            steps {
                script {
                    // Extract values from the fetched environment string
                    def envVars = DOCKER_ENV.tokenize(" ")
                    def gitRepo = envVars.find { it.startsWith("GIT_REPO=") }?.split("=")[1]
                    def gitBranch = envVars.find { it.startsWith("GIT_BRANCH=") }?.split("=")[1]

                    // Checkout the repository dynamically
                    git branch: "${gitBranch}", url: "${gitRepo}"
                }
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
                script {
                    // Extract values from the fetched environment string
                    def envVars = DOCKER_ENV.tokenize(" ")
                    def dockerHubUser = envVars.find { it.startsWith("DOCKER_HUB_USERNAME=") }?.split("=")[1]
                    def imageName = envVars.find { it.startsWith("IMAGE_NAME=") }?.split("=")[1]
                    def dockerImage = "${dockerHubUser}/${imageName}"

                    withDockerRegistry([credentialsId: 'docker-hub-credentials', url: 'https://index.docker.io/v1/']) {
                        sh "docker push ${dockerImage}:${BUILD_NUMBER}"
                    }
                }
            }
        }
    }
}
