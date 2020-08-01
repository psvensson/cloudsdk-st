"
I handle Google Cloud specific things related to containers building and general managemenet.
"
Class {
	#name : #CCGoogleContainers,
	#superclass : #CCContainers,
	#instVars : [
		'image'
	],
	#category : #'CloudConversations-Core-Containers'
}

{ #category : #accessing }
CCGoogleContainers >> buildDataFor: img serviceAccount: serviceAccount filename: filename bucket: bucket type: type [
	| dockerbuild dockerpush deploy data projectId |
	projectId := serviceAccount projectId .
	dockerbuild := self
		getBuildStepForDockerBuild: projectId
		filename: filename
		imagename: img.
	dockerpush := self
		getBuildStepForDockerPush: projectId
		filename: filename
		imagename: img.
	deploy := type = 'cloud run'
		ifTrue: [ self
				getBuildStepForCloudRunDeploy: serviceAccount
				filename: filename
				imagename: img ]
		ifFalse: [ self
				getBuildStepForCloudVMDeploy: projectId
				filename: filename
				imagename: img
			" , ','
				,
					(self
						getBuildStepForCloudVMFirewall: projectId
						filename: filename
						imagename: img)" ].
	data := '{"source":{"storageSource":{"bucket":"' , bucket
		, '","object":"' , filename , '.zip' , '"}},"steps":[' , dockerbuild
		, ',' , dockerpush , ',' , deploy , '],"images":[' , img , ']}'.
	^ data
]

{ #category : #accessing }
CCGoogleContainers >> get: buildId [
	| projectId url |
	"list all containers present on the cloud provider"
	"GET https://cloudbuild.googleapis.com/v1/projects/{projectId}/builds"
	"Transcript show: token;cr."
	projectId := connection serviceAccount projectId.
	url := 'https://cloudbuild.googleapis.com/v1/projects/' , projectId
		, '/builds/' , buildId.
	Transcript show: url;cr.
	^ connection secureJSONCallTo: url
]

{ #category : #'as yet unclassified' }
CCGoogleContainers >> getBuildResultFor: buildId [
	| future |
	future := TKTFuture new.
	(self get: buildId)
		onSuccessDo: [ :result | 
			| rv steps |
			rv := Dictionary new.
			steps := result at: #steps ifAbsent: [  ].
			steps
				ifNotNil: [ steps
						do: [ :step | 
							| stat type |
							stat := step at: #status ifAbsent: [ 'PENDING' ].
							type := (step at: #args) first.
							rv at: type put: stat ] ].
			future deploySuccess: rv ].
	^ future
]

{ #category : #accessing }
CCGoogleContainers >> getBuildStepForCloudRunDeploy: serviceAccount filename: filename imagename: img [
	| rv projectId email |
	projectId := serviceAccount projectId.
	email := serviceAccount certificate at: #client_email .
	rv := '{"name":"gcr.io/cloud-builders/gcloud","args":["run","deploy","',filename ,'","--image",',img,',"--region","us-central1","--platform","managed","--allow-unauthenticated"]}'.
	Transcript show:'cloud run build step: ',rv;cr.
	^ rv
]

{ #category : #accessing }
CCGoogleContainers >> getBuildStepForCloudVMDeploy: projectId filename: filename imagename: img [
	| rv zone |
	zone := CCMainWindow models selectedZone .
	rv := '{"name":"gcr.io/cloud-builders/gcloud","args":["compute","instances", "create-with-container","',filename ,'","--container-image",',img,',"--zone","',zone,'","--tags","',filename,',pharo", "--labels", "deployname=',filename,',deploytype=pharo"]}'.
	Transcript show:'cloud VM build step: ',rv;cr.
	^ rv
]

{ #category : #accessing }
CCGoogleContainers >> getBuildStepForCloudVMFirewall: projectId filename: filename imagename: img [
	| rv zone |
	zone := CCMainWindow models selectedZone .
	rv := '{"name":"gcr.io/cloud-builders/gcloud","args":["compute","firewall-rules", "create","',filename ,'","--allow","tcp:80,443,8080","--target-tags","',filename,', "--labels", "deployname=',filename,',deploytype=pharo"]}'.
	Transcript show:'cloud VM build step: ',rv;cr.
	^ rv
]

{ #category : #accessing }
CCGoogleContainers >> getBuildStepForDockerBuild: projectId filename: filename imagename: img [
	^ '{"name":"gcr.io/cloud-builders/docker","args":["build","--ulimit","rtprio=2","-t",',img,',"."]}'
]

{ #category : #accessing }
CCGoogleContainers >> getBuildStepForDockerPush: projectId filename: filename imagename: img [
	^ '{"name":"gcr.io/cloud-builders/docker","args":["push",',img,']}'
]

{ #category : #accessing }
CCGoogleContainers >> getContainerManifestByName: aRepositoryName andReference: aReference [
	| projectId url res |
	projectId := connection serviceAccount projectId.
	url := 'https://gcr.io/v2/' , aRepositoryName , '/manifests/'
		, aReference.
	Transcript
		show: 'getContainerManifestByReference url=' , url;
		cr.
	^ connection secureJSONCallTo: url
]

{ #category : #accessing }
CCGoogleContainers >> initializeRegistry [
	| sa url |
	sa := connection serviceAccount.
	url := 'https://gcr.io/' , 'foobar'.
	
]

{ #category : #accessing }
CCGoogleContainers >> list [
	| projectId url future |
	future := TKTFuture new.
	"list all containers present on the cloud provider"
	"GET https://cloudbuild.googleapis.com/v1/projects/{projectId}/builds"
	"Transcript show: token;cr."
	projectId := connection serviceAccount projectId.
	url := 'https://cloudbuild.googleapis.com/v1/projects/' , projectId
		, '/builds'.
	"Transcript show: url;cr."
	(connection secureJSONCallTo: url)
		onSuccessDo: [ :result | 
			result isEmpty
				ifTrue: [ future deploySuccess: #() ]
				ifFalse: [ future deploySuccess: (result contents at: #builds) ] ].
	^ future
]

{ #category : #accessing }
CCGoogleContainers >> listContainerAnalysis [
	"https://containeranalysis.googleapis.com/v1/projects/foobar-6e993/occurrences"

	| projectId url |
	projectId := connection serviceAccount projectId.
	Transcript
		show: 'listContaineAnalysiss. projectId=' , projectId;
		cr.
	url := 'https://containeranalysis.googleapis.com/v1/projects/'
		, projectId , '/occurences'.
	"url := 'https://gcr.io/v2/_catalog'."
	^ connection secureJSONCallTo: url
]

{ #category : #accessing }
CCGoogleContainers >> listContainers [
	"This can happen;

Cloud Resource Manager API has not been used in project 973408038350 before or it is disabled. Enable it by visiting https://console.developers.google.com/apis/api/cloudresourcemanager.googleapis.com/overview?project=973408038350 then retry. If you enabled this API recently, wait a few minutes for the action to propagate to our systems and retry.
"

	| projectId url |
	projectId := connection serviceAccount projectId.
	Transcript
		show: 'listContainers. projectId=' , projectId;
		cr.
	url := 'https://gcr.io/v2/' , projectId , '/tags/list'.
	"url := 'https://gcr.io/v2/_catalog'."
	^ connection secureJSONCallTo: url
]

{ #category : #accessing }
CCGoogleContainers >> listRepositoryTags: aRepositoryName [
	| projectId url |
	projectId := connection serviceAccount projectId.
	url := 'https://gcr.io/v2/', projectId , '/' , aRepositoryName
		, '/tags/list'.
	Transcript
		show: 'listRepositoryTags url=' , url;
		cr.
	^ connection secureJSONCallTo: url
]

{ #category : #accessing }
CCGoogleContainers >> startBuildProcessFor: serviceAccount filename: filename bucket: bucket type: type [
	| data url img projectId |
	projectId := serviceAccount projectId.
	img := '"gcr.io/' , projectId , '/' , filename , '"'.
	data := self
		buildDataFor: img
		serviceAccount: serviceAccount
		filename: filename
		bucket: bucket
		type: type.
	url := 'https://cloudbuild.googleapis.com/v1/projects/' , projectId
		, '/builds'.
	^ connection secureJSONCallTo: url JSONContent: data
]

{ #category : #accessing }
CCGoogleContainers >> uploadFile: zipfile as: name To: storage andCreate: aTemplate type: type [
	| bucket projectId filename |
	filename := (name copyReplaceAll: ' ' with: '') asLowercase  .
	projectId := connection serviceAccount projectId.
	bucket := connection serviceAccount bucket .
	storage upload: zipfile as: filename , '.zip'.
	^ self startBuildProcessFor: connection serviceAccount filename: filename bucket: bucket type: type.
	
	
]
