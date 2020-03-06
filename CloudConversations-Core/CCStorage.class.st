Class {
	#name : #CCStorage,
	#superclass : #Object,
	#instVars : [
		'connection'
	],
	#category : #'CloudConversations-Core-Storage'
}

{ #category : #generating }
CCStorage class >> createZipFileOf: aDictionary [
	"The dictionary is assumed to have the structure of #fileName->#fileContentString"

	| archive |
	archive := ZipArchive new.
	aDictionary
		keysAndValuesDo:
			[ :key :value | archive addDeflateString: value withInternetLineEndings as: key ].
	^ ByteArray streamContents: [ :strm | archive writeTo: strm ]
]

{ #category : #generating }
CCStorage class >> createZipFileOfFilenames: anArray [
	"The dictionary is assumed to have the structure of #fileName->#fileContentString"

	| archive |
	archive := ZipArchive new.
	anArray do: [ :value | archive addFile: value asFileReference ].
	^ ByteArray streamContents: [ :strm | archive writeTo: strm ]
]

{ #category : #'instance creation' }
CCStorage class >> with: aConnection [
	| instance |
	instance := aConnection serviceAccount cloudType = 'google'
		ifTrue: [ CCGoogleStorage new ].
	instance connection: aConnection .
	^ instance	
]

{ #category : #accessing }
CCStorage >> connection [
	^ connection
]

{ #category : #accessing }
CCStorage >> connection: anObject [
	connection := anObject
]

{ #category : #'as yet unclassified' }
CCStorage >> delete: aFileReference [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
CCStorage >> list [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
CCStorage >> upload: fileContent as: fileName [
	self subclassResponsibility 
]
