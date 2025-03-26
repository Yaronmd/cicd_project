pipeline {
    agent any
    stages {
        stage('Install Dependencies and Run Tests') {
            agent {
                kubernetes {
                    label 'pytest-pod'
                    yamlFile 'kubernetes/test-pod.yaml'  // Reference to the YAML file
                }
                docker {
                image 'bitnami/kubectl:latest'  // ✅ Uses a prebuilt image with kubectl
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
