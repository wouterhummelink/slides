#  Docker

![Docker Logo](images/docker-tile.svg) <!-- {_ height="40%" width="40% style="border-width: 0;"  } -->

---

### Wat is Docker?

Docker is een toolset waarmee gebruikers applicaties in containers kunnen draaien.
* Een _runtime_ waarmee images als _container_ gedraaid kunnen worden
* Een _taal_ om het bouwen van images te beschrijven
* Een _image format_ om gebouwde images op te slaan
* Een _protocol_ om images op te halen bij een "registry"

--

### Container?

![Container 101](images/containers-101.png) <!-- {_ style="background-color: white;" } -->

--

### Hoe werkt het?

Elk proces op Linux heeft namespaces

* PID <!-- {_ class="fragment"} -->
* Network  <!-- {_ class="fragment"} -->
* Mounts  <!-- {_ class="fragment"} -->
* UTS (hostname/nisdomainname)  <!-- {_ class="fragment"} -->
* IPC  <!-- {_ class="fragment"} -->
* cgroups (cpu/memory/io)  <!-- {_ class="fragment"} -->

--

### Windows container

![Windows container](images/containerfund.png) <!-- {_ style="background-color: white;" } -->

--

### Containers zijn onveranderlijk

* Containers draaien altijd op een copy-on-write filesystem (overlayfs)
* Als een container stopt gaan wijzigingen verloren

---

## Dockerfile

Een dockerfile bevat de stap-voor-stap instructies om een container image te maken.
Deze dockerfile draait deze presentatie in een Docker container.
```dockerfile
FROM centos:7
RUN yum -y install httpd && yum clean all
ADD . /var/www/html/

EXPOSE 80/tcp
CMD ["-D","FOREGROUND"]
ENTRYPOINT ["/usr/sbin/httpd"] 
```

--

### Step by step
* `FROM centos/7 #Basis image` <!-- {_ class="fragment"} -->
* `RUN yum -y install httpd && yum clean all # Installeer software` <!-- {_ class="fragment"} -->
* `ADD . /var/www/html/ # Voeg files toe` <!-- {_ class="fragment"} -->
* `EXPOSE 80/tcp # Geef aan dat we op port 80 verkeer ontvangen` <!-- {_ class="fragment"} -->
* `CMD ["-D","FOREGROUND"] # Command arguments` <!-- {_ class="fragment"} -->
* `ENTRYPOINT ["/usr/bin/httpd"] # Primary commmand` <!-- {_ class="fragment"} -->


--

###Overige directives

* ENV <!-- {_ class="fragment"} -->
* VOLUME <!-- {_ class="fragment"} -->
* ONBUILD <!-- {_ class="fragment"} -->
* LABEL <!-- {_ class="fragment"} -->
* ARG <!-- {_ class="fragment"} -->
* WORKDIR <!-- {_ class="fragment"} -->

---

Docker gebruiken

* `docker build -t slides .` 
  * Bouw de dockerfile in de huidige directory
* `docker run -ti busybox`
  * Draai een busybox shell in docker
* `docker run -d -p 8080:80 slides -n slides`
  * Docker run de _slides_ container en bind host port 8080 aan container port 80
* `docker exec -ti slides bash` 
  * Draai een shell in een draaiende container 

---

OCI Images

Docker images zijn gestandaardiseerd in de OCI Image specificatie
Elke _layer_ wordt targzipt en voorzien van metadata in json format

https://github.com/opencontainers/image-spec

---

Registries

Docker registry is in feite een http dienst waar de layers van images en metadata kan worden gezocht en gedownload

docker pull docker.io/php

* Docker Hub (docker.io)
* Redhat Container Registry (registry.access.redhat.com)
* CentOS Container Registry (registry.centos.org)
* Quay (quay.io)

---

Docker advanced topics

* docker run -d mysql -v /var/tmp/mysql:/var/lib/mysql:Z
* docker run -d -l mysql app 
* docker run --volumes-from app web

---

Alternate runtimes

* rkt (Tectonic/Container Linux)
* containerd
* cri-o (Openshift)
