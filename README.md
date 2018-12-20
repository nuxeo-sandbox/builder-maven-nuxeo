# builder-maven-nuxeo

This is the base image used in the Jenkins X platform to build Nuxeo.

You have to update your jenkisx deployment to use it .
Create a file called myvalues.yaml in the jx home folder  ~/jx with the following configuration:

```
jenkins:
  Agent:
    PodTemplates:
      MyBuilder:
        Name: builder-maven-nuxeo
        Label: builder-maven-nuxeo
        volumes:
        - type: Secret
          secretName: jenkins-docker-cfg
          mountPath: /home/jenkins/.docker
        EnvVars:
          JENKINS_URL: http://jenkins:8080
          GIT_COMMITTER_EMAIL: jenkins-x@googlegroups.com
          GIT_AUTHOR_EMAIL: jenkins-x@googlegroups.com
          GIT_AUTHOR_NAME: jenkins-x-bot
          GIT_COMMITTER_NAME: jenkins-x-bot
          XDG_CONFIG_HOME: /home/jenkins
          DOCKER_CONFIG: /home/jenkins/.docker/
        ServiceAccount: jenkins
        Containers:
          Jnlp:
            Image: jenkinsci/jnlp-slave:3.14-1
            RequestCpu: "100m"
            RequestMemory: "128Mi"
            Args: '${computer.jnlpmac} ${computer.name}'
          maven-nuxeo:
            Image: 10.19.250.70:5000/nuxeo-sandbox/builder-maven-nuxeo 
            Privileged: true
            RequestCpu: "800m"
            RequestMemory: "2048Mi"
            LimitCpu: "1"
            LimitMemory: "2048Mi"
            Command: "/bin/sh -c"
            Args: "cat"
            Tty: true
```

And execute:

```
jx install --default-admin-password=$YourPass  --namespace=$YourNamespace --no-tiller
```

When jenkisx is updated you should get a message like:

```
Using local value overrides file /Users/mariana/.jx/myvalues.yaml
```

