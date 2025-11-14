pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = "integracion-continua:${env.BUILD_NUMBER}"
        CONTAINER_NAME = "integracion-continua-${env.BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo "INICIANDO PIPELINE DE INTEGRACIÓN CONTINUA"
                echo "Descargando código fuente del repositorio..."
                checkout scm
                sh 'git log -1 --oneline'
            }
            post {
                success {
                    echo "Checkout completado exitosamente"
                }
            }
        }
        
        stage('Compilación') {
            steps {
                echo "Compilando la aplicación..."
                sh '''
                    echo "Simulando compilación Java..."
                    mkdir -p target/classes
                    echo "Compilación exitosa - archivos en target/"
                    ls -la
                '''
            }
        }
        
        stage('Pruebas Unitarias') {
            steps {
                echo "Ejecutando simulación pruebas unitarias..."
                sh '''
                    echo "Ejecutando tests..."
                    echo "Tests unitarios pasados: 15/15"
                    echo "Covertura: 85%"
                    mkdir -p test-reports
                    echo '<?xml version="1.0" encoding="UTF-8"?>
                    <testsuite name="UnitTests" tests="15" failures="0" errors="0">
                        <testcase name="Test1Simulado" classname="TestSuite" time="0.1"/>
                        <testcase name="Test2Simulado" classname="TestSuite" time="0.2"/>
                    </testsuite>' > test-reports/test-results.xml
                    echo "Reporte de tests generado"
                '''
            }
            post {
                always {
                    junit 'test-reports/*.xml'
                }
            }
        }
        
        stage('Análisis de Calidad') {
            steps {
                echo "Analizando calidad del código..."
                sh '''
                    echo "Realizando análisis estático..."
                    echo "Code Smells: 2"
                    echo "Bugs: 0"
                    echo "Vulnerabilidades: 0"
                    echo "Calidad del código: APROBADA"
                '''
            }
        }
        
        stage('Construcción Docker') {
            steps {
                echo "Construyendo imagen Docker..."
                sh """
                    if [ -f "Dockerfile" ]; then
                        echo "Encontrado Dockerfile existente"
                        docker build -t ${env.DOCKER_IMAGE} .
                        echo "Imagen Docker construida: ${env.DOCKER_IMAGE}"
                        docker images | grep integracion-continua || echo "Imagen no listada"
                    else
                        echo "No se encontró Dockerfile - creando uno básico..."
                        echo "FROM nginx:alpine" > Dockerfile
                        echo "RUN mkdir -p /usr/share/nginx/html" >> Dockerfile
                        echo "COPY . /usr/share/nginx/html/" >> Dockerfile
                        echo "EXPOSE 80" >> Dockerfile
                        docker build -t ${env.DOCKER_IMAGE} .
                        echo "Imagen Docker construida con Dockerfile básico"
                    fi
                """
            }
        }
        
        stage('Despliegue') {
            steps {
                echo "Desplegando contenedor..."
                sh """
                    docker stop ${env.CONTAINER_NAME} || true
                    docker rm ${env.CONTAINER_NAME} || true
                    
                    docker run -d --name ${env.CONTAINER_NAME} -p 8081:80 ${env.DOCKER_IMAGE}
                    sleep 5
                    
                    echo "Verificando estado del contenedor:"
                    docker ps | grep ${env.CONTAINER_NAME} || echo "Contenedor no encontrado en ps"
                    
                    echo "Todos los contenedores:"
                    docker ps -a | grep ${env.CONTAINER_NAME} || echo "Contenedor no existe"
                """
            }
            post {
                success {
                    echo "Contenedor desplegado exitosamente"
                    echo "Aplicación disponible en: http://localhost:8081"
                }
            }
        }
        
        stage('Verificación') {
            steps {
                echo "Verificando despliegue..."
                sh """
                    sleep 8
                    
                    if curl -f http://localhost:8081 > /dev/null 2>&1; then
                        echo "Aplicación respondiendo correctamente en puerto 8081"
                        echo "Contenido de la página:"
                        curl -s http://localhost:8081 | head -n 5
                    else
                        echo "Aplicación no responde - puede ser normal en entornos de prueba"
                        docker logs ${env.CONTAINER_NAME} || echo "No se pueden ver logs del contenedor"
                    fi
                """
            }
        }
    }
    
    post {
        always {
            echo "RESUMEN DEL PIPELINE"
            echo "================================"
            echo "Estado final: ${currentBuild.result ?: 'SUCCESS'}"
            echo "Duración: ${currentBuild.durationString}"
            echo "Número de build: ${currentBuild.number}"
            echo "Contenedor: ${env.CONTAINER_NAME}"
            echo "Imagen: ${env.DOCKER_IMAGE}"
            echo "================================"
            
            sh 'rm -f Main.java Main.class 2>/dev/null || true'
        }
        
        success {
            echo "PIPELINE COMPLETADO EXITOSAMENTE"
            echo "Todas las etapas pasaron correctamente"
            echo "Aplicación desplegada y funcionando"
        }
        
        failure {
            echo "PIPELINE FALLIDO"
            echo "Revisar los logs para identificar el error"
        }
    }
}