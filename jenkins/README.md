# Jenkins Notes
* Author:   Pedric Kng  
* Updated:  05 Dec 2019
***

## Clean Up Old Builds

You can update the configuration of all existing jobs on a Jenkins Master by running the following Groovy Script within Manage Jenkins -> Script Console which will apply a permanent build discard policy to your jobs that you can configure by passing the desired values to the listed parameters.

```groovy
// NOTES:
// dryRun: to only list the jobs which would be changed
// daysToKeep:  If not -1, history is only kept up to this day.
// numToKeep: If not -1, only this number of build logs are kept.
// artifactDaysToKeep: If not -1 nor null, artifacts are only kept up to this day.
// artifactNumToKeep: If not -1 nor null, only this number of builds have their artifacts kept.

import jenkins.model.Jenkins

def dryRun = true
def daysToKeep = 30
def numToKeep = 10
def artifactDaysToKeep = -1
def artifactNumToKeep = -1


Jenkins.instanceOrNull.allItems(hudson.model.Job).each { job ->
    if (job.isBuildable() && job.supportsLogRotator() && job.getProperty(jenkins.model.BuildDiscarderProperty) == null) {
        println "Processing \"${job.fullDisplayName}\""
        if (!"true".equals(dryRun)) {
            // adding a property implicitly saves so no explicit one
            try {
                job.setBuildDiscarder(new hudson.tasks.LogRotator ( daysToKeep, numToKeep, artifactDaysToKeep, artifactNumToKeep))
                println "${job.fullName} is updated"
            } catch (Exception e) {
                // Some implementation like for example the hudson.matrix.MatrixConfiguration supports a LogRotator but not setting it
                println "[WARNING] Failed to update ${job.fullName} of type ${job.class} : ${e}"
            }
        }
    }
}
return;
```

# References
Best Strategy for Disk Space Management: Clean Up Old Builds [[1]]  

[1]:https://support.cloudbees.com/hc/en-us/articles/215549798-Best-Strategy-for-Disk-Space-Management-Clean-Up-Old-Builds "Best Strategy for Disk Space Management: Clean Up Old Builds"
