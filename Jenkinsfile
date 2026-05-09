pipeline {
    agent any

    parameters {
        choice(
            name: 'ACTION',
            choices: ['plan', 'apply', 'destroy'],
            description: 'Select Terraform Action'
        )

        string(
            name: 'BRANCH',
            defaultValue: 'main',
            description: 'Git Branch Name'
        )

        booleanParam(
            name: 'AUTO_APPROVE',
            defaultValue: false,
            description: 'Auto approve Terraform apply'
        )
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')

        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')

        AWS_DEFAULT_REGION    = 'ap-south-1'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out GitHub Repository'

                checkout scmGit(
                    branches: [[name: "*/${params.BRANCH}"]],
                    extensions: [],
                    userRemoteConfigs: [[
                        url: 'https://github.com/ashish-repository/Terraform-Jenkins-Pipeline.git'
                    ]]
                )
            }
        }

        stage('Terraform Version') {
            steps {
                sh 'terraform --version'
            }
        }

        stage('Terraform Init') {
            steps {
                echo 'Initializing Terraform'

                sh 'terraform init -reconfigure'
            }
        }

        stage('Terraform Format Check') {
            steps {
                echo 'Checking Terraform Formatting'

                sh 'terraform fmt -check'
            }
        }

        stage('Terraform Validate') {
            steps {
                echo 'Validating Terraform'

                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            when {
                anyOf {
                    expression { params.ACTION == 'plan' }

                    expression { params.ACTION == 'apply' }
                }
            }

            steps {
                echo 'Generating Terraform Plan'

                sh 'terraform plan -input=false -out=tfplan'

                sh 'terraform show tfplan'
            }
        }

        stage('Terraform Apply') {
            when {
                expression { params.ACTION == 'apply' }
            }

            steps {
                script {
                    if (!params.AUTO_APPROVE) {
                        timeout(time: 5, unit: 'MINUTES') {
                            input message: 'Approve Terraform Apply?'
                        }
                    }

                    echo 'Applying Terraform Changes'

                    sh 'terraform apply -input=false tfplan'
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }

            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    input message: 'Approve Terraform Destroy?'
                }

                echo 'Destroying Terraform Infrastructure'

                sh 'terraform destroy -input=false -auto-approve'
            }
        }
    }

    post {
        success {
            echo 'Pipeline Executed Successfully'
        }

        failure {
            echo 'Pipeline Failed'
        }

        always {
            echo 'Cleaning Workspace'

            cleanWs()
        }
    }
}
