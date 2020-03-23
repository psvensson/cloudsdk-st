# cloudsdk-st
A tool for deploying Smalltalk application directly to the cloud, from the image, without touching any files.
Currently only supporting deploy to Google Cloud and to Google Cloud Run cloud functions (lambdas).

This is an Alpha-release, so will have a lot of sharp corners. Please write issues like it's going out of style, to help me make it better :)

# Installation
```Smalltalk
Metacello new
    repository: 'github://psvensson/cloudsdk-st:master';
    baseline: 'CloudConversations';
    load
```

# Prerequisites

  - A Google Cloud project
  - A downloaded JSON file for a service account (use 'create key' on 'IAM & Admin' -> 'service accounts' -> (the service account) -> 'edit'). The default App Engine service account works well for this.
  - Granting access for Google Cloud build to deploy to Google Cloud Run, by setting 'Cloud Run Admin' to enabled here; (https://console.cloud.google.com/cloud-build/settings).
  - Enabling the Cloud resource manager API, here; (https://console.developers.google.com/apis/api/cloudresourcemanager.googleapis.com/overview)
  - Enabling the Cloud Run API, here; (https://console.developers.google.com/apis/api/run.googleapis.com/overview)

# How to use

Opening application (from playground):
```Smalltalk
CCMainWindow open
```

Add at least one service account key (from file or pasting) by pressing the 'New Account' button. Nothing works before this is done.

In the 'Docker templates' pane is a list of templates for creating custom Docker images of Pharo 7 with the options to add extra packages and edit the startup script (load file).

When done editing a template, press 'Create Container'. This will use Google Cloud Build to both create a Docker image of the tamplte and then deploy it to Google Cloud Run as a cloud function. The process usually takes 1-2 minutes. You can follow the build process in the Google Cloud Console here; (https://console.cloud.google.com/cloud-build/builds)

The button 'Containers' list Docker containers and the button 'Build results' lists the results of all builds, including failed ones. The 'Deployments' button, finally, lists finished running cloud functions and the 'url' property in the details is the ulr where the cloud function can be accessed. You can also see and manage the cloud function directly in the Google Cloud Console here; (https://console.cloud.google.com/run)



