"
I handle Google Cloud specific things related to containers building and general managemenet.
"
Class {
	#name : #CCGoogleContainers,
	#superclass : #CCContainers,
	#category : #'CloudConversations-Core-Containers'
}

{ #category : #accessing }
CCGoogleContainers >> createContainerForTemplate: aTemplate [
	| conn files zipfile storage |
	conn := CCMainController lastUsedConnection.
	conn isNil
		ifTrue: [ ^ self ].
	files := Dictionary new.
	files at: #Dockerfile put: aTemplate content.
	zipfile := CCStorage createZipFileOf: files.
	storage := CCMainController lastUsedStorage.
	storage upload: zipfile as: (aTemplate name,'.zip')
]

{ #category : #accessing }
CCGoogleContainers >> list [ 
	"list all containers present on the cloud provider"
	"GET https://cloudbuild.googleapis.com/v1/projects/{projectId}/builds"
	| projectId url result |
	"Transcript show: token;cr."
	projectId := connection serviceAccount projectId .
	url := 'https://cloudbuild.googleapis.com/v1/projects/',projectId,'/builds'.
	"Transcript show: url;cr."
	result := connection secureJSONCallTo: url.
	^ (result contents) at: #builds
]
