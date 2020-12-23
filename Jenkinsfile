node('haimaxy-jnlp') {
    stage('Clone') {
        echo "1.Clone Stage"
		checkout scm
        script {
            build_tag = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
			if (env.BRANCH_NAME != 'main') {
                build_tag = "${env.BRANCH_NAME}-${build_tag}"
        }
    }
	}
	stage('Sonar') {
        echo "3.Sonar Stage"
    sh 'sonar-scanner \
  -Dsonar.projectKey=python1 \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://192.168.6.150:8050 \
  -Dsonar.login=8fa5f29c83611ad51de080d24bf08b8e3ab64426'

    }
    stage('Build') {
        echo "3.Build Docker Image Stage"
    sh "docker build -t firexuxiaoman/golang-demo:${build_tag} ."
    }
    stage('Push') {
        echo "4.Push Docker Image Stage"
        withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
        sh "docker login -u ${dockerHubUser} -p ${dockerHubPassword}"
        sh "docker push firexuxiaoman/golang-demo:${build_tag}"
    }
        }
		stage('Deploy') {
        echo "5. Deploy Stage"
        if (env.BRANCH_NAME == 'main') {
            input "确认要部署线上环境吗？"
        }
        sh "sed -i 's/<BUILD_TAG>/${build_tag}/' k8s.yaml"
        sh "sed -i 's/<BRANCH_NAME>/${env.BRANCH_NAME}/' k8s.yaml"
        sh "kubectl apply -f k8s.yaml --record"
		sh "kubectl apply -f ingress.yaml --record"
    }
    }
