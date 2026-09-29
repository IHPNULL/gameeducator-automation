// Pipeline de automacao do GameEducator: constroi backend e frontend a partir dos
// seus repositorios, sobe os dois (perfil "automation") e roda as suites Cucumber
// de API (Cucumber-JVM) e de UI (Cucumber.js + Playwright).
pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
        timeout(time: 40, unit: 'MINUTES')
        skipDefaultCheckout()
    }

    parameters {
        string(name: 'BACKEND_CONTEXT', defaultValue: 'https://github.com/IHPNULL/gameeducator-backend.git#main', description: 'Contexto de build do backend (URL Git ou caminho)')
        string(name: 'FRONTEND_CONTEXT', defaultValue: 'https://github.com/IHPNULL/gameeducator-frontend.git#main', description: 'Contexto de build do frontend (URL Git ou caminho)')
    }

    environment {
        COMPOSE_PROJECT_NAME = "gameeducator-automation-${env.BUILD_NUMBER}"
        BACKEND_CONTEXT = "${params.BACKEND_CONTEXT}"
        FRONTEND_CONTEXT = "${params.FRONTEND_CONTEXT}"
        IMAGE_TAG = "local-${env.BUILD_NUMBER}"
    }

    stages {
        stage('Codigo-fonte') {
            steps {
                deleteDir()
                script {
                    if (env.LOCAL_SOURCE_DIR) {
                        sh """
                            tar -C "${env.LOCAL_SOURCE_DIR}" \\
                                --exclude=.git --exclude=node_modules --exclude=target --exclude=ui-tests/reports \\
                                -cf - . | tar -xf -
                        """
                    } else {
                        checkout scm
                    }
                }
            }
        }

        stage('Imagens') {
            steps {
                // O build de api-tests ja roda "mvnw test-compile" e falha se o codigo de teste nao compilar.
                sh "docker build -f docker/api-tests.Dockerfile -t gameeducator-api-tests:${IMAGE_TAG} api-tests"
                sh "docker build -f docker/ui-tests.Dockerfile -t gameeducator-ui-tests:${IMAGE_TAG} ui-tests"
                sh "docker compose -f docker/docker-compose.yml build backend frontend"
            }
        }

        stage('Cucumber API + UI') {
            steps {
                sh "docker compose -f docker/docker-compose.yml up -d --no-build backend frontend"
                sh '''
                    ok=0
                    for i in $(seq 1 45); do
                        if docker compose -f docker/docker-compose.yml exec -T frontend wget -q -O- http://127.0.0.1/v3/api-docs > /dev/null 2>&1; then
                            ok=1; break
                        fi
                        sleep 2
                    done
                    if [ "$ok" != "1" ]; then
                        echo "ERRO: backend (perfil automation) nao respondeu via frontend apos 90s" >&2
                        exit 1
                    fi
                '''
                sh "docker run --name ${COMPOSE_PROJECT_NAME}-api-tests --network ${COMPOSE_PROJECT_NAME}_default gameeducator-api-tests:${IMAGE_TAG}"
                sh "docker run --name ${COMPOSE_PROJECT_NAME}-ui-tests --network ${COMPOSE_PROJECT_NAME}_default gameeducator-ui-tests:${IMAGE_TAG}"
            }
            post {
                always {
                    sh "docker cp ${COMPOSE_PROJECT_NAME}-api-tests:/app/target/cucumber-report api-tests-cucumber-report || true"
                    sh "docker cp ${COMPOSE_PROJECT_NAME}-api-tests:/app/target/surefire-reports api-tests-surefire-reports || true"
                    sh "docker cp ${COMPOSE_PROJECT_NAME}-ui-tests:/app/reports ui-tests-reports || true"
                    sh "docker rm -f ${COMPOSE_PROJECT_NAME}-api-tests ${COMPOSE_PROJECT_NAME}-ui-tests || true"
                    sh 'docker compose -f docker/docker-compose.yml logs backend || true'
                    sh 'docker compose -f docker/docker-compose.yml down -v || true'
                    junit testResults: 'api-tests-surefire-reports/*.xml', allowEmptyResults: true
                    junit testResults: 'ui-tests-reports/junit-report.xml', allowEmptyResults: true
                    archiveArtifacts artifacts: 'api-tests-cucumber-report/**, ui-tests-reports/**', allowEmptyArchive: true
                }
            }
        }
    }
}
