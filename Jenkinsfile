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
        
    }
}
