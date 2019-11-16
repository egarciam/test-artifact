# POC para generar artefactos de test

## Idea
La idea consiste en generar conjuntamente en la construccion del artefacto de codigo un
artefacto de test que alrededor del cual se incluira como dependen de test en un
proyecto propio que lo ejecutara

### Mecanismo
Se inserta el pom.xml la dependencia de una test-class generada y desplegada en el
proyecto que contiene los tests que se van a reutilizar.

Dicha dependencia se inserta
```
<dependency>
  <groupId>es.orange.dsi.cgsw</groupId>
  <artifactId>sample-app</artifactId>
  <version>0.0.1</version>
  <type>test-jar</type>
  <scope>test</scope>
</dependency>

```
Para poder emplearla y ejecutar los tests mediante
```
mvn test
```
Es necesario incluir el plugin surefire en el pom.xml de la siguiente manera
```
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-surefire-plugin</artifactId>
  <version>2.20.1</version>
  <configuration>
    <dependenciesToScan>
      <dependency>es.orange.dsi.cgsw:sample-app</dependency>
    </dependenciesToScan>
  </configuration>
</plugin>

```
