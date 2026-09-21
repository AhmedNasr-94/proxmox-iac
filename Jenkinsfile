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

    stage('Ansible ping') {
      steps {
        dir('ansible') {
          sh 'ansible devops -i inventory.ini -m ping'
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
