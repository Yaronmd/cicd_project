pipeline {
    agent any
    stages {
        stage('Check & Install kubectl') {
            steps {
                script {
                    def kubectlExists = sh(script: 'which kubectl || echo "not found"', returnStdout: true).trim()
                    if (kubectlExists.contains("not found")) {
                        echo "🚀 Installing kubectl..."
                        sh '''
                        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                        chmod +x kubectl
                        mv kubectl /usr/local/bin/
                        kubectl version --client
                        '''
                    } else {
                        echo "✅ kubectl is already installed!"
                    }
                }
            }
        }

        stage('Verify Kubernetes Access') {
            steps {
                script {
                    echo "🔍 Checking Kubernetes access..."
                    sh 'kubectl get pods --all-namespaces || echo "❌ Access Denied!"'
                }
            }
        }
        stage('Install Dependencies and Run Tests') {
            agent {
                kubernetes {
                    label 'pytest-pod'
                    yamlFile 'kubernetes/test-pod.yaml'  // Reference to the YAML file
                }
               
            }
            
            steps {
                container('python') {
                    script {
                        // Install dependencies
                        sh 'pip install --no-cache-dir -r requirements.txt'
                        
                        // Run E2E tests
                        sh 'pytest tests/e2e_test.py'
                    }
                }
            }
        }
        stage('Monitor Job Status') {
            steps {
                script {
                    // Example: Monitoring with kubectl (checking pod status)
                    sh 'kubectl get pods -l app=pytest-pod'
                }
            }
        }
    }
    post {
        always {
            echo 'Test execution complete!'
        }
        success {
            echo 'Tests Passed!'
        }
        failure {
            echo 'Tests Failed!'
        }
    }
}
