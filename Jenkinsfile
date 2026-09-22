pipeline {
  agent any

  environment {
    ANSIBLE_HOST_KEY_CHECKING = 'False'
    PROXMOX_VE_SSH_USERNAME   = 'root'
  }

  stages {
    stage('Terraform plan') {
      steps {
        withCredentials([
          string(credentialsId: 'proxmox-api-token',    variable: 'TF_VAR_proxmox_api_token'),
          string(credentialsId: 'proxmox-ssh-password', variable: 'PROXMOX_VE_SSH_PASSWORD')
        ]) {
          sh 'terraform init -input=false -backend-config="path=/var/jenkins_home/tfstate/devops-vm.tfstate"'
          sh 'terraform apply -input=false -auto-approve'
        }
      }
    }

        stage('Wait for VM') {
      steps {
        dir('ansible') {
          sh '''
            for i in $(seq 1 20); do
              ansible devops -i inventory.ini -m ping && exit 0
              echo "VM not ready yet, waiting 10s..."
              sleep 10
            done
            echo "VM never became reachable"
            exit 1
          '''
        }
      }
    }

    stage('Ansible deploy') {
      steps {
        dir('ansible') {
          sh 'ansible-playbook -i inventory.ini docker.yml'
          sh 'ansible-playbook -i inventory.ini portainer.yml'
          sh 'ansible-playbook -i inventory.ini monitoring.yml'
        }
      }
    }
  }
}
