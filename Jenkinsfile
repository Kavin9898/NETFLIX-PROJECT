pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
        ECR_REPO = "netflix-devops-app"
        ACCOUNT_ID = "801195563235"   // replace with your AWS account id
        IMAGE_TAG = "${BUILD_NUMBER}"
        IMAGE_URI = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Kavin9898/NETFLIX-PROJECT.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                docker build -t ${ECR_REPO}:${IMAGE_TAG} ./app
                """
            }
        }

        stage('Login to AWS ECR') {
            steps {
                sh """
                aws ecr get-login-password --region ${AWS_REGION} | \
                docker login --username AWS --password-stdin \
                ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                """
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                sh """
                docker tag ${ECR_REPO}:${IMAGE_TAG} ${IMAGE_URI}
                docker push ${IMAGE_URI}
                """
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                dir('terraform') {
                    sh """
                    terraform init
                    terraform apply -auto-approve \
                        -var="ami_id=ami-0f5ee92e2d63afc18" \
                        -var="instance_type=t2.micro" \
                        -var="key_name=jenkins-mum"
                    """
                }
            }
        }

        stage('Trigger Auto Scaling Refresh') {
            steps {
                sh """
                aws autoscaling start-instance-refresh \
                --auto-scaling-group-name web-auto-scaling-group \
                --region ${AWS_REGION}
                """
            }
        }
    }

    post {
        success {
            echo "Deployment Successful 🚀"
        }
        failure {
            echo "Deployment Failed ❌"
        }
    }
}
