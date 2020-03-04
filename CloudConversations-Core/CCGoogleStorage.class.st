Class {
	#name : #CCGoogleStorage,
	#superclass : #CCStorage,
	#category : #'CloudConversations-Core-Storage'
}

{ #category : #'as yet unclassified' }
CCGoogleStorage >> delete: aFileReference [
	Transcript show:'CCGoogleSTorage.delete (unimplemented)';cr.
]

{ #category : #'as yet unclassified' }
CCGoogleStorage >> list [
	"List all files in the default bucket for the project defined by the service account"
	| projectId url result |
	Transcript show:'CCGoogleSTorage.list (unimplemented)';cr.
	projectId := connection serviceAccount projectId .
	url := 'https://storage.googleapis.com/storage/v1/b/',projectId,'.appspot.com/o'.
	"Transcript show: url;cr."
	result := connection secureJSONCallTo: url.
	^ result at: #items
]

{ #category : #'as yet unclassified' }
CCGoogleStorage >> upload: fileContent as: fileName [
	| url projectId bucket |
	projectId := connection serviceAccount projectId.
	bucket := projectId , '.appspot.com'.
	url := 'https://storage.googleapis.com/upload/storage/v1/b/' , bucket
		, '/o?uploadType=media&name=' , fileName.
	^ connection secureJSONCallTo: url withFile: fileContent as: fileName
]
