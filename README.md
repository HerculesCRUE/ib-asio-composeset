![](./images/logos_feder.png)


| Entregable     | Documentaci髇 sobre el despliegue en                                   |
| -------------- | ------------------------------------------------------------ |
| Fecha          | 25/05/2020                                                   |
| Proyecto       | [ASIO](https://www.um.es/web/hercules/proyectos/asio) (Arquitectura Sem醤tica e Infraestructura Ontol骻ica) en el marco de la iniciativa [H閞cules](https://www.um.es/web/hercules/) para la Sem醤tica de Datos de Investigaci髇 de Universidades que forma parte de [CRUE-TIC](http://www.crue.org/SitePages/ProyectoHercules.aspx) |
| M骴ulo         | Arquitectura Sem醤tica                                                   |
| Tipo           | Documento                                                    |
| Objetivo       | Despliegue en entorno de desarrollo para la Universidad de Murcia                          |
| Estado         | 100% para el hito 1                                          |
| Pr髕imos pasos | Actualizar de forma acorde al avance del proyecto y surjan necesidades.    


# Despliegue en entorno de desarrollo para la Universidad de Murcia
---

## Entornos 

### Hardware  

| Nombre | herc-iz-front-desa.atica.um.es | herc-iz-back-desa.atica.um.es | herc-iz-bd-desa.atica.um.es |
|---|---|---|---|
| **IP**  | 155.54.239.207  | 155.54.239.208  | 155.54.239.209 |
| **SO**  | CentOS Linux release 7.7.1908  | CentOS Linux release 7.7.1908  | CentOS Linux release 7.7.1908  |
| **MEMORIA** | 8GB  | 16GB  | 8GB |
| **PROCESADOR** | Intel Core i7 9xx (Nehalem Class Core i7)  | Intel Core i7 9xx (Nehalem Class Core i7)  | Intel Core i7 9xx (Nehalem Class Core i7) |
| **CORES** | 4  | 4  | 4 |
| **ARQUITECTURA** | 64  | 64  | 64 |

### Usuario

Se crea el usuario **herculesizertis** en todos los entornos para realizar tareas de despliegue y gesti贸n.

## Instalaciones

### Docker

Instalar dependencias   

```
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```

A帽adir repositorio   

```
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

Instalar docker-ce   

```
sudo yum install docker-ce
```

A帽adir el usuario actual el grupo docker   

```
sudo usermod -aG docker $(whoami)
```

Configurar el servicio Docker para comenzar autom谩ticamente en cada reinicio   
```
sudo systemctl enable docker.service
```

Arrancar servicio  

```
sudo systemctl start docker.service
```

### Crear usuario   

Crear grupo de usuario   

```
sudo groupadd herculesizertis
```

Crear  usuario **herculesizertis**  

```
sudo useradd -g herculesizertis  -d /home/herculesizertis -m -p h3rcul3s1z3rt1s herculesizertis
```

A帽adir grupos **herculesizertis**  

```
sudo usermod -a -G sistemas herculesizertis
sudo usermod -a -G docker herculesizertis
```

Cambiar el grupo  

```
sudo usermod -a -G sistemas herculesizertis
sudo usermod -a -G docker herculesizertis
```

Dar los permisos a usuario  

```
usermod -a -G wheel herculesizertis
```

Cambiar de usuario   

```
su herculesizertis
```

Dar los permisos a usuario  

```
usermod -a -G wheel herculesizertis
```

Cambiar grupo principal

```
newgrp docker
```

### Instalar docker-compose   

Actualizar

```
yum update -y
```

Instalar dependencias

```
sudo yum install epel-release
```

Instalar Python y gcc

```
sudo yum install -y python-pip python-devel gcc
```

Actualizar python

```
 sudo yum upgrade python*
```

Actualizar pip

```
sudo pip install --upgrade pip
```

Instalar docker-compose

```
sudo pip install docker-compose
```

Comprobar instalacion

```
docker-compose version
```

### Actualizaci贸n vm.max_map_count

Elasticsearch precisa que el valor de la variable `vm.max_map_count` sea de al menos 262144, para ello se precisa ejecutar el siguiente comando:

```
sudo sysctl -w vm.max_map_count=262144
```

## Despliegue  

Se indica a continuaci贸n los elementos desplegados por cada m谩quina.

### M谩quina base de datos herc-iz-bd-desa.atica.um.es

La m谩quina de base de datos ser谩 la encargada de alojar todo lo que se refiere a persistencia de informaci贸n. Los servicios desplegados son:

* **MariaDB**
  * Nombre del servicio: mariadb
  * Puertos: 3306
  * Descripci贸n: base de datos MariaDB
* **Mongo**
  * Nombre del servicio: mongodb
  * Puertos: 27017
  * Descripci贸n: base de datos MongoDB
* **Kafka**
  * Nombre del servicio: kafka
  * Puertos: 9092, 29092 (disponible desde el exterior)
  * Descripci贸n: Servicio de Kafka
* **Zookeeper**
  * Nombre del servicio: zookeeper
  * Puertos: 2181
  * Descripci贸n: Zookeeper para Kafka
* **Elasticsearch**
  * Nombre del servicio: elasticsearch
  * Puertos: 9200, 9300
  * Descripci贸n: Servicio de b煤squedas Elasticsearch
* **Kafdrop**
  * Nombre del servicio: kafdrop
  * Puertos: 19000
  * Descripci贸n: Monitor de Kafka
* **Fuseki**
  * Nombre del servicio: jena-fuseki
  * Puertos: 3030
  * Descripci贸n: Fuseki
* **Wikibase Elasticsearch AS**
  * Nombre del servicio: wiki-as-elasticsearch
  * Puertos: 9202
  * Descripci贸n: Elasticsearch para Wikibase Arquitectura Sem谩ntica
* **Wikibase Elasticsearch IO**
  * Nombre del servicio: wiki-io-elasticsearch
  * Puertos: 9202
  * Descripci贸n: Elasticsearch para Wikibase Infraestructura Ontol贸gica

### M谩quina back herc-iz-back-desa.atica.um.es

La m谩quina de back ser谩 la encargada de alojar las aplicaciones y los procesos batch. Los servicios desplegados son:

* **Graylog**
  * Nombre del servicio: graylog
  * Puertos: 9000
  * Descripci贸n: Servicio de monitorizaci贸n
* **Input Processor**
  * Nombre del servicio: input-processor
  * Puertos: N/A
  * Descripci贸n: Procesador de datos de entrada
* **Management system**
  * Nombre del servicio: management-system
  * Puertos: N/A
  * Descripci贸n: Sistema de gesti贸n, generaci贸n de RDF
* **URIs Generator**
  * Nombre del servicio: uris-generator
  * Puertos: N/A
  * Descripci贸n: Generador de URIs
* **Discovery**
  * Nombre del servicio: discovery
  * Puertos: N/A
  * Descripci贸n: Librer铆a de descubrimiento
* **Trellis event processor**
  * Nombre del servicio: trellis-event-processor
  * Puertos: N/A
  * Descripci贸n: Procesador de eventos para Trellis
* **Trellis storage adapter**
  * Nombre del servicio: trellis-storage-adapter
  * Puertos: N/A
  * Descripci贸n: Adaptador para almacenamiento en Trellis
* **Wikibase event processor**
  * Nombre del servicio: wikibase-event-processor
  * Puertos: N/A
  * Descripci贸n: Procesador de eventos para Wikibase
* **Wikibase storage adapter**
  * Nombre del servicio: wikibase-storage-adapter
  * Puertos: N/A
  * Descripci贸n: Adaptador para almacenamiento en Wikibase
* **PDI**
  * Nombre del servicio: pdi
  * Puertos: 8080
  * Descripci贸n: Pentaho Data Integration para proceso de transformaci贸n de datos ETL

Adem谩s se configuran los siguientes procesos batch v铆a crontab

* **Dataset importer**
  * Nombre del servicio: dataset-importer
  * Cron expression: */5 * * * *
  * Descripci贸n: Importador de dataset de UM
* **CVN importer**
  * Nombre del servicio: cvn-importer
  * Cron expression: */10 * * * *
  * Descripci贸n: Importador de CVN

####  Configuraci贸n de procesos batch

Para configurar los procesos batch se opta por la configuraci贸n mediante crontab. Para ello, desde el usuario que se desea ejecutar el proceso se deber谩 ejecutar el comando:

  crontab -e

Se deber谩 configurar mediante una cron expression la frecuencia de ejecuci贸n del proceso. Como sugerencia, ser谩 necesario moverse al directorio en el que se encuentra el script para que pueda acceder de forma relativa a los recursos necesarios.

Para configurar la expresi贸n cron, existen herrameitas que lo facilitan como por ejemplo https://crontab-generator.org/

Por ejemplo, en caso de querer ejecutar cada 5 minutos:

```crontab
*/5 * * * * cd /home/herculesizertis/deploy/scripts && ./launch_dataset_importer.sh >/dev/null 2>&1
*/10 * * * * cd /home/herculesizertis/deploy/scripts && ./launch_cvn_importer.sh >/dev/null 2>&1

```

### M谩quina front herc-iz-front-desa.atica.um.es

La m谩quina de front ser谩 la encargada de alojar las aplicaciones de frontal. Los servicios desplegados son:

* **Trellis**
  * Nombre del servicio: trellis
  * Puertos: 80
  * Descripci贸n: Linked Data Platform (LDP)
* **Wikibase AS**
  * Nombre del servicio: wikibase
  * Puertos: 8181, 8282, 9191
  * Descripci贸n: Wikibase Arquitectura Sem谩ntica
* **Keycloak**
  * Nombre del servicio: keycloak
  * Puertos: 8080
  * Descripci贸n: Keycloak

## Anexo

### Conexi贸n a los servicios desde entorno local

Los servicios desplegados solamente son visibles desde las m谩quinas de la red, pero no as铆 desde la m谩quina local, aunque esta se encuentre conectada a la VPN. Para poder acceder a los servicios ser谩 preciso configurar un tunel SSH a los puertos de las aplicaciones. Los pasos a seguir son:

1. Configurar en el fichero /etc/hosts (en Windows C:\\Windows\\System32\\drivers\\etc\\hosts) los nombres herc-iz-bd-desa.atica.um.es y herc-iz-back-desa.atica.um.es para que resuelvan a la IP 127.0.0.1
  
  127.0.0.1	herc-iz-bd-desa.atica.um.es
  127.0.0.1	herc-iz-back-desa.atica.um.es

2. Configurar tunel SSH, accediendo mediante la IP a la m谩quina herc-iz-back-desa.atica.um.es (155.54.239.208):
  * **Kafdrop**: 
    * T煤nel SSH: 19000 -> herc-iz-bd-desa.atica.um.es:19000
    * Acceso desde navegador: http://herc-iz-bd-desa.atica.um.es:19000/
    * Autenticaci贸n: no requiere
  * **MariaDB**: 
    * T煤nel SSH: 3306 -> herc-iz-bd-desa.atica.um.es:3306
    * Autenticaci贸n: usuarios de base de datos
  * **Trellis**:
    * T煤nel SSH: 80 -> herc-iz-front-desa.atica.um.es:80
    * Acceso desde navegador: http://herc-iz-front-desa.atica.um.es/
    * Autenticaci贸n: configurado WebAC, posible acceso con autenticaci贸n b谩sica o token JWT obtenido de Keycloak
  * **Wikibase AS**:
    * T煤nel SSH: 8181 -> herc-iz-front-desa.atica.um.es:8181
    * Acceso desde navegador: http://herc-iz-front-desa.atica.um.es:8181/
    * Autenticaci贸n: no es necesario para la visualizaci贸n de datos
  * **Graylog**:
    * T煤nel SSH: 9000 -> herc-iz-back-desa.atica.um.es:9000
    * Acceso desde navegador: http://herc-iz-back-desa.atica.um.es:9000/
    * Autenticaci贸n: es precisa, configurado usuario "admin"
  * **Keycloak**:
    * Tunel SSH: 8443 -> herc-iz-front-desa.atica.um.es:8443
    * Acceso desde navegador: https://herc-iz-front-desa.atica.um.es:8443
    * Autenticaci贸n: es necesaria

#### Obtenci贸n de token JWT

Para obtener el token JWT desde Keycloak, es puede hacer con Postman configurando los siguientes par谩metros:

* Grant type: Authorization Code
* Callback URL: http://localhost:8082
* Auth URL: https://herc-iz-front-desa.atica.um.es:8443/auth/realms/asio/protocol/openid-connect/auth
* Access Token URL: https://herc-iz-front-desa.atica.um.es:8443/auth/realms/asio/protocol/openid-connect/token
* Client ID: trellis
* Client Secret: 7c950207-b369-4a33-bbf0-fe2c6ca59e9a
* Scope: openid
* State: 12345
* Client Authentication: Send as Basic Auth header

Una vez configurados estos datos, al obtener el token se pedir谩n los datos del usuario y se obtendr谩 el token JWT que ser谩 preciso utilizar para llamar a aquellas aplicaciones que lo precisen.

#### Windows

Para conectar desde windows a un servicio ubicado en el puerto 8181, es necesario establecer un tunel ssh de la siguiente forma:

1. Establecer conexi贸n VPN con UM usando credenciales

   ![vpn](./doc/images/vpn.jpg)

2. Establecer t煤nel SSH con putty
  - Crear sesi贸n con Putty

    ![sesion](./doc/images/sesion.png)

  - A帽adir en la sesi贸n la public key facilitada por la UM para el acceso

    ![public-key](./doc/images/public-key.png)

  - Crear tunel. En **Source Port** ponemos el puerto que vamos a utilizar para el t煤nel (por ejemplo el 8081), **destination** lo dejamos en blanco y en las opciones de abajo lo ponemos en **Dynamic** y en **AUTO**. Y luego seleccionamos ADD (para a帽adir la configuraci贸n)

    ![tunel](./doc/images/manual_tunel_ssh_2.png)

   - Conectarnos al servidor ssh

     ![abrir sesi贸n](./doc/images/abrir-Sesion.png)

   - Configurar navegador (firefox)
     - Opciones, Avanzado, Red 

       ![img](./doc/images/manual_tunel_ssh_5.png)

     - Configurar el proxy. **Configuraci贸n Manual del Proxy**, **Servidor SOCKS: 127.0.0.1** y el **puerto 8081** (el que pusimos anteriormente), elegimos **SOCKS v5** (comprobado que funciona).

       ![img](./doc/images/manual_tunel_ssh_6.png)

     - Comprobar

       ![wikibase1](./doc/images/wiki.png)
