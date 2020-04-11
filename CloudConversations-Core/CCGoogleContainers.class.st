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
CCGoogleContainers >> buildDataFor: img projectId: projectId filename: filename bucket: bucket type: type [
	| dockerbuild dockerpush deploy data |
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
				getBuildStepForCloudRunDeploy: projectId
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
CCGoogleContainers >> getBuildStepForCloudRunDeploy: projectId filename: filename imagename: img [
	| rv |
	rv := '{"name":"gcr.io/cloud-builders/gcloud","args":["run","deploy","',filename ,'","--image",',img,',"--region","us-central1","--platform","managed","--allow-unauthenticated"]}'.
	Transcript show:'cloud run build step: ',rv;cr.
	^ rv
]

{ #category : #accessing }
CCGoogleContainers >> getBuildStepForCloudVMDeploy: projectId filename: filename imagename: img [
	| rv zone |
	zone := CCMainWindow models selectedZone .
	rv := '{"name":"gcr.io/cloud-builders/gcloud","args":["compute","instances", "create-with-container","',filename ,'","--container-image",',img,',"--zone","',zone,'","--tags","',filename,',pharo"]}'.
	Transcript show:'cloud VM build step: ',rv;cr.
	^ rv
]

{ #category : #accessing }
CCGoogleContainers >> getBuildStepForCloudVMFirewall: projectId filename: filename imagename: img [
	| rv zone |
	zone := CCMainWindow models selectedZone .
	rv := '{"name":"gcr.io/cloud-builders/gcloud","args":["compute","firewall-rules", "create","',filename ,'","--allow","tcp:80,443,8080","--target-tags","',filename,'"]}'.
	Transcript show:'cloud VM build step: ',rv;cr.
	^ rv
]

{ #category : #accessing }
CCGoogleContainers >> getBuildStepForDockerBuild: projectId filename: filename imagename: img [
	^ '{"name":"gcr.io/cloud-builders/docker","args":["build","-t",',img,',"."]}'
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
CCGoogleContainers >> listContainers [
	"This can happen;

Cloud Resource Manager API has not been used in project 973408038350 before or it is disabled. Enable it by visiting https://console.developers.google.com/apis/api/cloudresourcemanager.googleapis.com/overview?project=973408038350 then retry. If you enabled this API recently, wait a few minutes for the action to propagate to our systems and retry.
"

	| projectId url |
	projectId := connection serviceAccount projectId.
	"url := 'https://gcr.io/v2/',projectId."
	url := 'https://gcr.io/v2/_catalog'.
	^ connection secureJSONCallTo: url
]

{ #category : #accessing }
CCGoogleContainers >> listRepositoryTags: aRepositoryName [
	| projectId url |
	projectId := connection serviceAccount projectId.
	url := 'https://gcr.io/v2/',aRepositoryName,'/tags/list'.
	Transcript show:'listRepositoryTags url=',url;cr.	
	^ connection secureJSONCallTo: url
]

{ #category : #accessing }
CCGoogleContainers >> startBuildProcessFor: projectId filename: filename bucket: bucket type: type [
	| data url img |
	img := '"gcr.io/' , projectId , '/' , filename , '"'.
	data := self
		buildDataFor: img
		projectId: projectId
		filename: filename
		bucket: bucket
		type: type.
	url := 'https://cloudbuild.googleapis.com/v1/projects/' , projectId
		, '/builds'.
	^ connection secureJSONCallTo: url JSONContent: data
]

{ #category : #accessing }
CCGoogleContainers >> uploadFile: zipfile To: storage andCreate: aTemplate [
	| bucket projectId data url filename |
	projectId := connection serviceAccount projectId.
	filename := (aTemplate name copyReplaceAll: ' ' with: '') asLowercase  .
	bucket := projectId , '.appspot.com'.
	storage upload: zipfile as: filename , '.zip'.
	data := '{"source":{"storageSource":{"bucket":"' , bucket
		, '","object":"' , filename , '.zip'
		,
			'"}},"steps":[{"name":"gcr.io/cloud-builders/docker","args":["build","--network=cloudbuild","-t","gcr.io/'
		, projectId , '/' , filename , '","."]}],"images":["gcr.io/'
		, projectId , '/' , filename , '"]}'.
	
	url := 'https://cloudbuild.googleapis.com/v1/projects/' , projectId
		, '/builds'.
	"Transcript show:'url=',url;cr."
	^ connection secureJSONCallTo: url JSONContent: data
]

{ #category : #accessing }
CCGoogleContainers >> uploadFile: zipfile as: name To: storage andCreate: aTemplate type: type [
	| bucket projectId filename result |
	filename := (name copyReplaceAll: ' ' with: '') asLowercase  .
	projectId := connection serviceAccount projectId.
	bucket := projectId , '.appspot.com'.
	storage upload: zipfile as: filename , '.zip'.
	^ self startBuildProcessFor: projectId filename: filename bucket: bucket type: type.
	
	
]
