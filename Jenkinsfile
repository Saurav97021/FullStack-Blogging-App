pipeline {
    agent any
    
    tools{
        jdk'jdk17'
        maven'maven3'
    }
    environment{
        SCANNER_HOME= tool'sonar-scanner'
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Saurav97021/FullStack-Blogging-App.git'
            }
        }
        stage('Compilation') {
            steps {
                sh 'mvn compile'
            }
        }
        stage('Testing') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Trivy FS Scan') {
            steps {
                sh 'trivy fs --format table -o fs.html .'
            }
        }
        stage('SoanrQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh '''$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Blogging-app -Dsonar.projectKey=Blogging-app  \
                          -Dsonar.java.binaries=target'''
                 }
            }
        }
        stage('Build') {
            steps {
                sh 'mvn package'
            }
        }
        stage('Publish Artifacts') {
            steps {
                withMaven(globalMavenSettingsConfig: 'maven-settings', jdk: 'jdk17', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                      sh 'mvn deploy'
                   }
                }
            }
        stage('Docker Build and Tag') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                      sh 'docker build -t saurav108/bloggingapp:latest . '
                   }
                }
            }
        }
        stage('Trivy Image Scan') {
            steps {
                sh 'trivy image --format table -o image.html saurav108/bloggingapp:latest'
            }
        }
        stage('Docker Push Image') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                      sh 'docker push saurav108/bloggingapp:latest'
                   }
                }
            }
        }
        stage('k8 Deploy') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: ' saurav-cluster', contextName: '', credentialsId: 'k8-cred', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://E17C7A60A4A034C8C7D30F636C0C5976.gr7.us-east-1.eks.amazonaws.com') {
                 sh 'kubectl apply -f deployment-service.yml'
                 sleep 30
               }
            }
        }
        stage('Verify the Deployement') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: ' saurav-cluster', contextName: '', credentialsId: 'k8-cred', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://E17C7A60A4A034C8C7D30F636C0C5976.gr7.us-east-1.eks.amazonaws.com') {
                 sh 'kubectl get pods'
                 sh 'kubectl get svc'
               }
            }
        }
        
    }
        
    post {
    always {
            script {
                def jobName = env.JOB_NAME
                def buildNumber = env.BUILD_NUMBER
                def pipelineStatus = currentBuild.result ?: 'UNKNOWN'
                def bannerColor = pipelineStatus.toUpperCase() == 'SUCCESS' ? 'green' : 'red'
                def body = """
                    <html>
                    <body>
                    <div style="border: 4px solid ${bannerColor}; padding: 10px;">
                    <h2>${jobName} - Build ${buildNumber}</h2>
                    <div style="background-color: ${bannerColor}; padding: 10px;">
                    <h3 style="color: white;">Pipeline Status: ${pipelineStatus.toUpperCase()}</h3>
                    </div>
                    <p>Check the <a href="${BUILD_URL}">console output</a>.</p>
                    </div>
                    </body>
                    </html>
                 """
               emailext (
                   subject: "${jobName} - Build ${buildNumber} - ${pipelineStatus.toUpperCase()}",
                   body: body,
                   to: 'tripathisaurav9702@gmail.com',
                   from: 'jenkins@example.com',
                   replyTo: 'jenkins@example.com',
                   mimeType: 'text/html',
                   attachmentsPattern: 'trivy-image-report.html'
                )
            }
        }
   }
}
