pipeline {
    agent any

    tools {
        maven "maven"
        jdk "jdk17"
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
        EC2_HOST = 'ec2-18-118-119-205.us-east-2.compute.amazonaws.com'
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/mayurjagtap15/secretsanta-generator.git'
            }
        }

        stage('Compile Source') {
            steps {
                sh "mvn compile"
            }
        }

        stage('Run Tests') {
            steps {
                sh "mvn test -DskipTests=true"
            }
        }

        stage('Build Application') {
            steps {
                sh "mvn package"
            }
        }
		
		stage('Push Artifact to GitHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github-public-pat', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')]) {
                    sh """
                        echo "Cloning artifact repo"
                        rm -rf secretsanta-artifact-repo
                        git clone https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/mayurjagtap15/secretsanta-generator-artifact.git secretsanta-artifact-repo

                        echo "Copying JAR to artifacts/"
                        mkdir -p secretsanta-artifact-repo/artifacts/
                        cp target/*.jar secretsanta-artifact-repo/artifacts/app-${BUILD_NUMBER}.jar

                        cd secretsanta-artifact-repo
                        git config user.name "jenkins"
                        git config user.email "jenkins@ci.local"
                        git add artifacts/
                        git commit -m "Add app-${BUILD_NUMBER}.jar artifact"
                        git push origin main
                    """
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
               sshagent(['ec2-ssh-key']) {
            sh """
                echo "Transferring JAR to EC2"
                scp -o StrictHostKeyChecking=no target/*.jar ubuntu@${EC2_HOST}:/home/ubuntu/app.jar

                echo "Restarting application on EC2"
                ssh -o StrictHostKeyChecking=no ubuntu@${EC2_HOST} '
                    nohup java -jar /home/ubuntu/app.jar > /home/ubuntu/app.log 2>&1 &
                '
               """
                }
            }
        }
    }

}
