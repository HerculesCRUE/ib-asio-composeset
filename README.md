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

Se crea el usuario **herculesizertis** en todos los entornos para realizar tareas de despliegue y gestión.

## Instalaciones

### Docker

Instalar dependencias   

```
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```

Añadir repositorio   

```
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

Instalar docker-ce   

```
sudo yum install docker-ce
```

Añadir el usuario actual el grupo docker   

```
sudo usermod -aG docker $(whoami)
```

Configurar el servicio Docker para comenzar automáticamente en cada reinicio   
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

Añadir grupos **herculesizertis**  

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

### Actualización vm.max_map_count

Elasticsearch precisa que el valor de la variable `vm.max_map_count` sea de al menos 262144, para ello se precisa ejecutar el siguiente comando:

```
sudo sysctl -w vm.max_map_count=262144
```

## Despliegue  

Se indica a continuación los elementos desplegados por cada máquina.

### Máquina base de datos herc-iz-bd-desa.atica.um.es

La máquina de base de datos será la encargada de alojar todo lo que se refiere a persistencia de información. Los servicios desplegados son:

* **MariaDB**
  * Nombre del servicio: mariadb
  * Puertos: 3306
  * Descripción: base de datos MariaDB
* **Mongo**
  * Nombre del servicio: mongodb
  * Puertos: 27017
  * Descripción: base de datos MongoDB
* **Kafka**
  * Nombre del servicio: kafka
  * Puertos: 9092, 29092 (disponible desde el exterior)
  * Descripción: Servicio de Kafka
* **Zookeeper**
  * Nombre del servicio: zookeeper
  * Puertos: 2181
  * Descripción: Zookeeper para Kafka
* **Elasticsearch**
  * Nombre del servicio: elasticsearch
  * Puertos: 9200, 9300
  * Descripción: Servicio de búsquedas Elasticsearch
* **Kafdrop**
  * Nombre del servicio: kafdrop
  * Puertos: 19000
  * Descripción: Monitor de Kafka
* **Fuseki**
  * Nombre del servicio: jena-fuseki
  * Puertos: 3030
  * Descripción: Fuseki
* **Wikibase Elasticsearch AS**
  * Nombre del servicio: wiki-as-elasticsearch
  * Puertos: 9202
  * Descripción: Elasticsearch para Wikibase Arquitectura Semántica
* **Wikibase Elasticsearch IO**
  * Nombre del servicio: wiki-io-elasticsearch
  * Puertos: 9202
  * Descripción: Elasticsearch para Wikibase Infraestructura Ontológica

### Máquina back herc-iz-back-desa.atica.um.es

La máquina de back será la encargada de alojar las aplicaciones y los procesos batch. Los servicios desplegados son:

* **Graylog**
  * Nombre del servicio: graylog
  * Puertos: 9000
  * Descripción: Servicio de monitorización
* **Input Processor**
  * Nombre del servicio: input-processor
  * Puertos: N/A
  * Descripción: Procesador de datos de entrada
* **Management system**
  * Nombre del servicio: management-system
  * Puertos: N/A
  * Descripción: Sistema de gestión, generación de RDF
* **URIs Generator**
  * Nombre del servicio: uris-generator
  * Puertos: N/A
  * Descripción: Generador de URIs
* **Discovery**
  * Nombre del servicio: discovery
  * Puertos: N/A
  * Descripción: Librería de descubrimiento
* **Trellis event processor**
  * Nombre del servicio: trellis-event-processor
  * Puertos: N/A
  * Descripción: Procesador de eventos para Trellis
* **Trellis storage adapter**
  * Nombre del servicio: trellis-storage-adapter
  * Puertos: N/A
  * Descripción: Adaptador para almacenamiento en Trellis
* **Wikibase event processor**
  * Nombre del servicio: wikibase-event-processor
  * Puertos: N/A
  * Descripción: Procesador de eventos para Wikibase
* **Wikibase storage adapter**
  * Nombre del servicio: wikibase-storage-adapter
  * Puertos: N/A
  * Descripción: Adaptador para almacenamiento en Wikibase
* **PDI**
  * Nombre del servicio: pdi
  * Puertos: 8080
  * Descripción: Pentaho Data Integration para proceso de transformación de datos ETL

Además se configuran los siguientes procesos batch vía crontab

* **Dataset importer**
  * Nombre del servicio: dataset-importer
  * Cron expression: */5 * * * *
  * Descripción: Importador de dataset de UM
* **CVN importer**
  * Nombre del servicio: cvn-importer
  * Cron expression: */10 * * * *
  * Descripción: Importador de CVN

####  Configuración de procesos batch

Para configurar los procesos batch se opta por la configuración mediante crontab. Para ello, desde el usuario que se desea ejecutar el proceso se deberá ejecutar el comando:

  crontab -e

Se deberá configurar mediante una cron expression la frecuencia de ejecución del proceso. Como sugerencia, será necesario moverse al directorio en el que se encuentra el script para que pueda acceder de forma relativa a los recursos necesarios.

Para configurar la expresión cron, existen herrameitas que lo facilitan como por ejemplo https://crontab-generator.org/

Por ejemplo, en caso de querer ejecutar cada 5 minutos:

```crontab
*/5 * * * * cd /home/herculesizertis/deploy/scripts && ./launch_dataset_importer.sh >/dev/null 2>&1
*/10 * * * * cd /home/herculesizertis/deploy/scripts && ./launch_cvn_importer.sh >/dev/null 2>&1

```

### Máquina front herc-iz-front-desa.atica.um.es

La máquina de front será la encargada de alojar las aplicaciones de frontal. Los servicios desplegados son:

* **Trellis**
  * Nombre del servicio: trellis
  * Puertos: 80
  * Descripción: Linked Data Platform (LDP)
* **Wikibase AS**
  * Nombre del servicio: wikibase
  * Puertos: 8181, 8282, 9191
  * Descripción: Wikibase Arquitectura Semántica
* **Keycloak**
  * Nombre del servicio: keycloak
  * Puertos: 8080
  * Descripción: Keycloak

## Anexo

### Conexión a los servicios desde entorno local

Los servicios desplegados solamente son visibles desde las máquinas de la red, pero no así desde la máquina local, aunque esta se encuentre conectada a la VPN. Para poder acceder a los servicios será preciso configurar un tunel SSH a los puertos de las aplicaciones. Los pasos a seguir son:

1. Configurar en el fichero /etc/hosts (en Windows C:\\Windows\\System32\\drivers\\etc\\hosts) los nombres herc-iz-bd-desa.atica.um.es y herc-iz-back-desa.atica.um.es para que resuelvan a la IP 127.0.0.1
  
  127.0.0.1	herc-iz-bd-desa.atica.um.es
  127.0.0.1	herc-iz-back-desa.atica.um.es

2. Configurar tunel SSH, accediendo mediante la IP a la máquina herc-iz-back-desa.atica.um.es (155.54.239.208):
  * **Kafdrop**: 
    * Túnel SSH: 19000 -> herc-iz-bd-desa.atica.um.es:19000
    * Acceso desde navegador: http://herc-iz-bd-desa.atica.um.es:19000/
    * Autenticación: no requiere
  * **MariaDB**: 
    * Túnel SSH: 3306 -> herc-iz-bd-desa.atica.um.es:3306
    * Autenticación: usuarios de base de datos
  * **Trellis**:
    * Túnel SSH: 80 -> herc-iz-front-desa.atica.um.es:80
    * Acceso desde navegador: http://herc-iz-front-desa.atica.um.es/
    * Autenticación: configurado WebAC, posible acceso con autenticación básica o token JWT obtenido de Keycloak
  * **Wikibase AS**:
    * Túnel SSH: 8181 -> herc-iz-front-desa.atica.um.es:8181
    * Acceso desde navegador: http://herc-iz-front-desa.atica.um.es:8181/
    * Autenticación: no es necesario para la visualización de datos
  * **Graylog**:
    * Túnel SSH: 9000 -> herc-iz-back-desa.atica.um.es:9000
    * Acceso desde navegador: http://herc-iz-back-desa.atica.um.es:9000/
    * Autenticación: es precisa, configurado usuario "admin"
  * **Keycloak**:
    * Tunel SSH: 8443 -> herc-iz-front-desa.atica.um.es:8443
    * Acceso desde navegador: https://herc-iz-front-desa.atica.um.es:8443
    * Autenticación: es necesaria

#### Obtención de token JWT

Para obtener el token JWT desde Keycloak, es puede hacer con Postman configurando los siguientes parámetros:

* Grant type: Authorization Code
* Callback URL: http://localhost:8082
* Auth URL: https://herc-iz-front-desa.atica.um.es:8443/auth/realms/asio/protocol/openid-connect/auth
* Access Token URL: https://herc-iz-front-desa.atica.um.es:8443/auth/realms/asio/protocol/openid-connect/token
* Client ID: trellis
* Client Secret: 7c950207-b369-4a33-bbf0-fe2c6ca59e9a
* Scope: openid
* State: 12345
* Client Authentication: Send as Basic Auth header

Una vez configurados estos datos, al obtener el token se pedirán los datos del usuario y se obtendrá el token JWT que será preciso utilizar para llamar a aquellas aplicaciones que lo precisen.

#### Windows

Para conectar desde windows a un servicio ubicado en el puerto 8181, es necesario establecer un tunel ssh de la siguiente forma:

1. Establecer conexión VPN con UM usando credenciales

   ![vpn](data:image/png;base64,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)

2. Establecer túnel SSH con putty
  - Crear sesión con Putty

    ![sesion](https://i.ibb.co/qMFrwVv/sesion.png)

  - Añadir en la sesión la public key facilitada por la UM para el acceso

    ![public-key](https://i.ibb.co/GdTdDKD/public-key.png)

  - Crear tunel. En **Source Port** ponemos el puerto que vamos a utilizar para el túnel (por ejemplo el 8081), **destination** lo dejamos en blanco y en las opciones de abajo lo ponemos en **Dynamic** y en **AUTO**. Y luego seleccionamos ADD (para añadir la configuración)

    ![tunel](https://www.redeszone.net/app/uploads-redeszone.net/manual_tunel_ssh_2.png)

   - Conectarnos al servidor ssh

     ![abrir sesión](https://i.ibb.co/YBsspGH/abrir-Sesion.png)

   - Configurar navegador (firefox)
     - Opciones, Avanzado, Red 

       ![img](https://www.redeszone.net/content/uploads/manual_tunel_ssh_5.png)

     - Configurar el proxy. **Configuración Manual del Proxy**, **Servidor SOCKS: 127.0.0.1** y el **puerto 8081** (el que pusimos anteriormente), elegimos **SOCKS v5** (comprobado que funciona).

       ![img](https://www.redeszone.net/content/uploads/manual_tunel_ssh_6.png)

     - Comprobar

       ![wikibase1](https://i.ibb.co/jH6tfKm/wiki.png)
