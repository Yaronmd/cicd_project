pipeline {
    agent any
    environment {
        KUBECTL_PATH = "$HOME/.local/bin/kubectl"
        PATH = "$HOME/.local/bin:$PATH"
    }
    stages {
        stage('Check & Install kubectl') {
            steps {
                script {
                    def kubectlExists = sh(script: 'which kubectl || echo "not found"', returnStdout: true).trim()
                    if (kubectlExists.contains("not found")) {
                        echo "🚀 Installing kubectl..."
                        sh '''
                        mkdir -p $HOME/.local/bin
                        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                        chmod +x kubectl
                        mv kubectl $HOME/.local/bin/
                        echo "✅ kubectl installed successfully!"
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
                    sh 'kubectl get nodes || echo "❌ Access Denied!"'
                }
            }
        }

        stage('Run Test Job') {
            steps {
                script {
                    echo "🚀 Deploying pytest Job..."
                    sh 'kubectl apply -f kubernetes/test-job.yaml'

                    echo "⏳ Waiting for Job to complete..."
                    sh 'kubectl wait --for=condition=complete job/pytest-job --timeout=300s'

                    echo "📜 Fetching logs..."
                    sh '''
                    POD_NAME=$(kubectl get pods --selector=job-name=pytest-job -o jsonpath="{.items[0].metadata.name}")
                    kubectl logs $POD_NAME
                    '''
                }
            }
        }

        stage('Clean Up') {
            steps {
                script {
                    echo "🧹 Cleaning up test job..."
                    sh 'kubectl delete job pytest-job'
                }
            }
        }
    }
    post {
        always {
            echo 'Test execution complete!'
        }
        success {
            echo '✅ Tests Passed!'
        }
        failure {
            echo '❌ Tests Failed!'
        }
    }
}
