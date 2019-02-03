Here we support running the RCPTT tests while collecting coverage via Jacoco. 

We started from ideas from the https://www.eclipse.org/rcptt/blog/2015/06/17/code-coverage.html

It proved to be quite simple:
+ Use the jacoco-maven-plugin 
* Pass the info value for the prepare-agent as an additional vmArg parameter to the AUT (assuming default values for the .m2 repository and build-director

The Jenkins JaCoCo plugins visualizes the output
https://plugins.jenkins.io/jacoco


