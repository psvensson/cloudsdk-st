# cloudsdk-st
A tool for deploying Smalltalk application directly to the cloud, from the image, without touching any files.
Currently supporting deploy to Google Cloud and to Google Cloud Run cloud functions (lambdas) and Google Compute Engine VMs.

If deploying to Compute Engine, you need to manually add a rule for your project's firewall to allow traffic to the VM. The VM wil be tagged with both 'pharo' and the individual name of the deployment, so if you add a rule targeting the 'pharo' tag, it will work for all VM deployments.

There is a blog post with more details and screenshots that describes the onboarding process in more detail here; (https://unclescript.blogspot.com/2020/03/a-cloud-sdk-for-pharo-smalltalk.html).

# Installation

If you had a previous installation, please delete the directory ~/Pharo/Images/{your image}/pharo-local/iceberg/psvensson to make sure that you get any new stuff. Thx.

Tested for Pharo 8. Does *not* work with Pharo 9 yet.

```Smalltalk
Metacello new
    repository: 'github://psvensson/cloudsdk-st:master';
    baseline: 'CloudConversations';
    load
```

# Prerequisites

  - A Google Cloud project. If you haven't signed up for Google cloud, you can do so here; https://cloud.google.com/gcp/. Instructions on how to get started can be found here; https://cloud.google.com/resource-manager/docs/creating-managing-projects .
  - A downloaded JSON file for a service account (use 'create key' on 'IAM & Admin' -> 'service accounts' -> (the service account) -> 'edit'). The default Compute Engine service account works well for this. The list of accounts for your project can be found here; (https://console.cloud.google.com/iam-admin/serviceaccounts)
  - Granting access for Google Cloud build to deploy to Google Cloud Run, by setting 'Cloud Run Admin, Compute Instance Admin and Service Account User' to enabled here; (https://console.cloud.google.com/cloud-build/settings). (First klick 'Enable' and then go to 'Settings' to do so)
  - If creating a new project from scratch, visist the Compute Engine page at least once to see that everything is active; (https://console.cloud.google.com/compute/instance).
  - Go to Google Cloud Storage for the project and create a storage bucket. If the storage bucket have the same name as your project id (If you're project is called 'foobar', create a new bucket named 'foobar' as well), everything should work automatically, otherwise you can change bucket name inside the cloudsdk after adding your account; https://console.cloud.google.com/storage.
  - Enabling the Cloud resource manager API, here; (https://console.developers.google.com/apis/api/cloudresourcemanager.googleapis.com/overview)
  - Enabling the Cloud Run API, here; (https://console.developers.google.com/apis/api/run.googleapis.com/overview)
  
  You might need to add the cloud build service account a a member to the service account you're using, to be able to deploy to Cloud Run. See How to manage Google IAM. See https://cloud.google.com/cloud-build/docs/securing-builds/set-service-account-permissions

# How to use

Opening application (from playground):
```Smalltalk
CCMainWindow open
```

Add at least one service account key (from file or pasting) by pressing the 'New Account' button. Nothing works before this is done.

In the 'Docker templates' pane is a list of templates for creating custom Docker images of Pharo 7 with the options to add extra packages and edit the startup script (load file).

When done editing a template, press 'Create Container'. This will use Google Cloud Build to both create a Docker image of the tamplte and then deploy it to Google Cloud Run as a cloud function. The process usually takes 1-2 minutes. You can follow the build process in the Google Cloud Console here; (https://console.cloud.google.com/cloud-build/builds)

The button 'Containers' list Docker containers and the button 'Build results' lists the results of all builds, including failed ones. The 'Deployments' button, finally, lists finished running cloud functions and the 'url' property in the details is the ulr where the cloud function can be accessed. You can also see and manage the cloud function directly in the Google Cloud Console here; (https://console.cloud.google.com/run)



