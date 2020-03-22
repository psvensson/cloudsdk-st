# cloudsdk-st
An tool for deploying Smalltalk application directly to the cloud, from the image, without touching any files.
Currently only supporting deploy to Google Cloud and to Google Cloud Run cloud functions (lambdas).

# Installation
```Smalltalk
Metacello new
    repository: 'github://psvensson/cloudsdk-st:master';
    baseline: 'cloudsdk-st';
    load
```

# Prerequisites

  - A Google Cloud project
  - A downloaded JSON file for a service account (use 'create key' on 'IAM & Admin' -> 'service accounts' -> (the service account) -> 'edit').
  - Granting access for Google Cloud build to deploy to Google Cloud Run (step 2 here; (https://cloud.google.com/run/docs/continuous-deployment-with-cloud-build#continuous)).
  - 

# How to use

Opening application (from playground):
```Smalltalk
CCMainWindow open
```

Add at least one service account key (from file or pasting) by pressing the 'New Account' button. Nothing works before this is done.

In the 'Docker templates' pane is a list of templates for creating custom Docker images of Pharo 7 with the options to add extra packages and edit the startup script (load file).

When done editing a template, press 'Create Container'. This will use Google Cloud Build to both create a Docker image of the tamplte and then deploy it to Google Cloud Run as a cloud function. The process usually takes 1-2 minutes.

The button 'Containers' list Docker containers and the button 'Build results' lists the results of all builds, including failed ones. The 'Deployments' button, finally, lists finished running cloud functions and the 'url' property in the details is the ulr where the cloud function can be accessed.



