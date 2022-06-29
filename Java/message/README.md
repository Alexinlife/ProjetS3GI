exemple Message 
===================



### Comment l'exécuter

- Mettre en place la base de données postgres dans docker Assurez vous que docker est démarrer.
- cd docker 
- docker-compose up -d

- Démarrer le service en exécutant le main dans  intellij
- Tester un service dans un browser : localhost:8089/api/getallmessages
- installé sur nodes.js et npm

- run ```npm install```
- run ```npm start``` auto-compilation et auto-refresh avec serveur webpack (port 8080)
- run ```npm exec webpack``` auto-compilation avec serveur quarkus (port quarkus: 8089)
- open ```http://localhost:8080```


labo gegi:
- partir Docker Desktop
  - cd docker
  - docker-compose up
- configurer gradle
    - ouvrir la configuration gradle (File -> Settings -> Build, Execution, Deployment -> Gradle)
    - dans la section: Gradle JVM choisir Project SDK
- Partir le projet avec la configuration "message.main"
