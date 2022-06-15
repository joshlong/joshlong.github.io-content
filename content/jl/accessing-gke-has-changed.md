title=Accessing   GKE  Has Changed
date=2022-06-15
type=post
tags=blog
status=published
~~~~~~



Before I moved most of my workloads over to [Tanzu Community Edition](https://tanzucommunityedition.io/), I had [GKE](https://cloud.google.com/kubernetes-engine/), Google's simple and lean Kubernetes distribution. GKE's dead simple to get going and they walk you through the installation an connection step-by-step so that you'd be more surprised if you _couldn't_ get to your cluster.

Anyway, that appears to be changing. Just got this ominous email saying there's now an extra step. It's probably for good reason. No time to dig into it. But I do want to note it for posterity.

Henceforth, starting with Kubernetes v1.25, we'll need to install `gke-gcloud-auth-plugin` binary on systems where `kubectl` or custom clients are used before updating to clients built with Kubernetes v1.25 for continued access to GKE Clusters. And, soon: before early Fall 2022. So, in case I forget how and why, I'm noting the change here. 


 
From the announcement: 

"Existing versions of kubectl and custom Kubernetes clients contain provider-specific code to manage authentication between the client and Google Kubernetes Engine. Starting with v1.25, this code will no longer be included as part of the OSS kubectl. GKE users will need to download and use a separate authentication plugin to generate GKE-specific tokens. This new binary, gke-gcloud-auth-plugin, uses the Kubernetes Client-go Credential Plugin mechanism to extend kubectl’s authentication to support GKE. Because plugins are already supported by kubectl, you can switch to the new mechanism now, before v1.25 becomes available." 


You can install it  using `gcloud components install`, like this:

```
gcloud components install gke-gcloud-auth-plugin
```


