FROM openjdk:17 as base 
WORKDIR /app
COPY . . 
RUN chmod +x gradlew
RUN ./gradlew build 

FROM tomcat:latest
WORKDIR webapps
COPY --from=base /app/build/libs/springboot-tomcat-gradle-war-0.0.1-SNAPSHOT.war .
RUN rm -rf ROOT && mv springboot-tomcat-gradle-war-0.0.1-SNAPSHOT.war ROOT.war
