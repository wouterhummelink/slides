![Jenkins Logo](images/jenkins-ar21.svg) <!-- {_ height="40%" width="40% style="border-width: 0;"  } -->
# Jenkins CI
## & Ansible testing using molecule

--

### What is continuous integration
![CI](images/0_Ibsu7Nvvd9gyhHxO.png)

--

### Jenkins history

* Oorspronkelijk ontwikkeld bij Sun door Kohsuke Kawaguchi
* Begonnen onder de naam Hudson als opensource java-buildserver
* Jenkins sinds 2011 na conflict met Oracle
* Sindsdien doorontwikkeld tot CI tool die met ongeveer alle talen kan werken
* Over 1400 plugins

-- 

### Jenkins v1 

In jenkins v1 kon je jobs in elkaar klikken uit voorgedefinieerde stappen

### Jenkins v2

Sinds Jenkins versie 2 build jobs kunnen worden beschreven in een op Apache Groovy gebaseerde DSL

-- 

### Jenkinsfile

Jenkinsfile (scripted)

```groovy
node {  
    stage('Build') { 
        // 
    }
    stage('Test') { 
        // 
    }
    stage('Deploy') { 
        // 
    }
}
```

--

### Jenkinsfile #2
```groovy
pipeline { 
    agent any 
    stages {
        stage('Build') { 
            steps { 
                sh 'make' 
            }
        }
        stage('Test'){
            steps {
                sh 'make check'
                junit 'reports/**/*.xml' 
            }
        }
        stage('Deploy') {
            steps {
                sh 'make publish'
            }
        }
    }
}
```

--

### Concepten

* Pipeline
* Node
* Stage
* Step
* Credential handling

--

### Zero configuration Jenkins

* init.groovy

--

## Demo 1

---

## Molecule

* Molecule is een testharness voor ansible code
* Kan via diverse drivers testsystemen creeren (docker, vagrant, vmware, cloud)
* test ansible roles & playbooks

--

### Project structure
```
molecule/
└── default
    ├── create.yml
    ├── destroy.yml
    ├── INSTALL.rst
    ├── molecule.yml
    ├── playbook.yml
    ├── prepare.yml
    ├── tests
    │   └── test_default.rb
    └── verify.yml
```

--

### Molecule.yml

```
---
dependency:
  name: galaxy
driver:
  name: vagrant
  provider:
    name: libvirt
lint:
  name: yamllint
platforms:
  - name: instance
    box: centos/7
    provider_options:
      uri: '"qemu+ssh://wouterhummelink@192.168.122.1/system"'
provisioner:
  name: ansible
  lint:
    name: ansible-lint
scenario:
  name: default
verifier:
  name: inspec
  lint:
    name: rubocop
    enabled: false
```

--

### Verifiers

* goss
* InSpec
* testinfra

--

### Default test sequence
* lint
* destroy
* dependency
* syntax
* create
* prepare
* converge
* idempotence
* side\_effect
* verify
* destroy

--

# Demo #2


