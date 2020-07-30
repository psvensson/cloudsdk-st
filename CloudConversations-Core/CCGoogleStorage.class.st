Class {
	#name : #CCGoogleStorage,
	#superclass : #CCStorage,
	#category : #'CloudConversations-Core-Storage'
}

{ #category : #'as yet unclassified' }
CCGoogleStorage class >> getBucketNameFor: projectId [
	|rv|
	rv := projectId.
	"^ projectId , '.appspot.com'"
	Transcript show:'getBucketName for returning: ',rv;cr.
	^ rv
]

{ #category : #'as yet unclassified' }
CCGoogleStorage >> delete: aFileReference [
	Transcript show:'CCGoogleSTorage.delete (unimplemented)';cr.
]

{ #category : #'as yet unclassified' }
CCGoogleStorage >> list [
	"List all files in the default bucket for the project defined by the service account"

	| projectId url future |
	future := TKTFuture new.
	Transcript
		show: 'CCGoogleSTorage.list (unimplemented)';
		cr.
	projectId := connection serviceAccount projectId.
	url := 'https://storage.googleapis.com/storage/v1/b/' , self class getBucketNameFor:  projectId.
	"Transcript show: url;cr."
	(connection secureJSONCallTo: url)
		onSuccessDo: [ :result | future deploySuccess: (result at: #items) ].
	^ future
]

{ #category : #'as yet unclassified' }
CCGoogleStorage >> upload: fileContent as: fileName [
	| url projectId bucket |
	projectId := connection serviceAccount projectId.
	bucket := self class getBucketNameFor: projectId.
	url := 'https://storage.googleapis.com/upload/storage/v1/b/' , bucket
		, '/o?uploadType=media&name=' , fileName.
	^ connection secureJSONCallTo: url withFile: fileContent as: fileName
]
