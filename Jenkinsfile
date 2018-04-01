pipeline {
  agent{label 'jenkinsslave111'}
  	environment{
  				imagename = 'sudharsan_10606385_img'
				containername = 'sudharsan_10606385_con'
				storagepath = 'example-repo-local/sudharsan_10606385'
				buildnumber  = "${currentBuild.number}" 
    }
stages {
        stage('Maven Build') {
          agent{
    			docker{
        			image 'maven:3.5-jdk-8-alpine'
    				label 'jenkinsslave111'
      				args '-v /root/.m2:/root/.m2:rw'
  				}
  		  }
            steps {
                sh 'mvn -B clean package -Dskip.unit.tests=true'
              	sh 'mvn test'
            }
            post {
                always {
                  junit 'target/surefire-reports/*.xml'
                }
            }
        }
  
  	  stage('Sonar Code Analysis') {
          agent{
    			docker{
        			image 'sonar-scanner2.8:latest'
                    label 'jenkinsslave111'
                  	args '-v /root/.sonar/cache:/root/.sonar/cache:rw'
  				}
  		  }
            steps {
             	sh 'sonar-scanner'
            }
  	}
  
  stage('System Testing') {
    	agent {label 'jenkinsslave111'}
    
    			steps {
                    system_testing(imagename,containername)
                }
  }
  stage ('Upload Artifacts') { 
    agent {label 'jenkinsslave117'}
    steps{
    
      script{
        def server = Artifactory.newServer url: 'http://172.17.36.113:8081/artifactory', credentialsId: 'artifact-creds'
    
def uploadSpec = """{
  "files": [
    {
      "pattern": "target/*.war",
      "target": "${storagepath}/V${buildnumber}/war/"
    }
 ]
}"""
      server.upload(uploadSpec)
                }
  }
  }
  stage ('Download Artifacts') {
        agent {label 'jenkinsslave117'}
    steps{
    
      script{
        def server = Artifactory.newServer url: 'http://172.17.36.113:8081/artifactory', credentialsId: 'artifact-creds'
    
def downloadSpec = """{
  "files": [
    {
      "pattern": "${storagepath}/V${buildnumber}/war/AngularJavaApp.war",
      "target": "/home/skill_user/test/$Application"
    }
 ]
}"""
      server.download(downloadSpec)
                }
  }
  }
    
stage('Download Artifacts and Deploy'){
        agent {label 'jenkinsslave117'}
               
    			steps {
                    
                  	sh 'ansible-playbook /home/skill_user/playbooks/Sudharsan/sudharsan_deployment.yaml --extra-vars "target=Sudharsan_vm app_name=${Application} env_name=${Environment}"'
                }
  } 


  
	}
}
