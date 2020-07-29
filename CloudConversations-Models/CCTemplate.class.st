Class {
	#name : #CCTemplate,
	#superclass : #Object,
	#instVars : [
		'content',
		'loadingContent',
		'name',
		'dependencies',
		'imagePackages',
		'loadfile',
		'generation'
	],
	#category : #'CloudConversations-Models'
}

{ #category : #accessing }
CCTemplate >> asString [
	^ self name 
]

{ #category : #accessing }
CCTemplate >> bumpGeneration [
	generation isNil ifTrue: [ generation := 0 ].
	generation := generation +1
]

{ #category : #accessing }
CCTemplate >> content [
	^ content
]

{ #category : #accessing }
CCTemplate >> content: anObject [
	content := anObject.
	
]

{ #category : #accessing }
CCTemplate >> depFile [
	| depStr |
	depStr := 'Iceberg remoteTypeSelector: #httpsUrl. '.
	dependencies isEmpty
		ifTrue: [ '' ]
		ifFalse: [ dependencies do: [ :each | depStr := depStr , each installString ] ].
	^ depStr
]

{ #category : #accessing }
CCTemplate >> dependencies [
	^ dependencies
]

{ #category : #accessing }
CCTemplate >> dependencies: anObject [
	dependencies := anObject
]

{ #category : #accessing }
CCTemplate >> dependenciesPartDockerfile [
	| rv |
	rv := ''.
	dependencies
		do: [ :dep | 
			| istr |
			istr := dep installString
				ifNil: [ '' ]
				ifNotNil: [ dep installString , '\n' ].
			rv := rv , istr ].
	^ rv
]

{ #category : #accessing }
CCTemplate >> dumpAsFiles [
	'Dockerfile' asFileReference
		writeStreamDo: [ :stream | stream << self content ].
	'load.st' asFileReference
		writeStreamDo: [ :stream | stream << self depFile , self loadFile ]	
]

{ #category : #accessing }
CCTemplate >> firstPartDockerfile [
	^ '
FROM psvensson/pharo8-base
LABEL maintainer="',Author fullName,'"

'
]

{ #category : #accessing }
CCTemplate >> imagePackages [
	^ imagePackages
]

{ #category : #accessing }
CCTemplate >> imagePackages: anObject [
	imagePackages := anObject
]

{ #category : #accessing }
CCTemplate >> initialize [
	imagePackages := OrderedCollection new.
	dependencies := OrderedCollection new.
	self regenerateContent .
	loadingContent := ''.
	generation := 1.
]

{ #category : #accessing }
CCTemplate >> loadFile [
	loadfile
		ifNil: [ loadfile := self dependenciesPartDockerfile ,'ZnServer startDefaultOn: 8080.
SmalltalkImage current snapshot: true andQuit: true' ].
	^ loadfile
]

{ #category : #accessing }
CCTemplate >> loadFile: string [
	loadfile := string.
]

{ #category : #accessing }
CCTemplate >> loadingContent [
	^ loadingContent
]

{ #category : #accessing }
CCTemplate >> loadingContent: anObject [
	loadingContent := anObject
]

{ #category : #accessing }
CCTemplate >> name [
	^ name isNil
		ifTrue: [ 'Default Template' ]
		ifFalse: [ name ]
]

{ #category : #accessing }
CCTemplate >> name: anObject [
	name := anObject
]

{ #category : #accessing }
CCTemplate >> regenerateContent [
	loadfile := nil.
	content := self firstPartDockerfile , self dependenciesPartDockerfile
		, self secondPartDockerfile
]

{ #category : #accessing }
CCTemplate >> secondPartDockerfile [
	^ '
RUN ./pharo --headless Pharo.image load.st;echo 0
######################################
# Expose port 8080 of Zinc outside the container
######################################
EXPOSE 8080

######################################
# Finally run headless as server
######################################
ENTRYPOINT ["./pharo", "--headless", "Pharo.image", "--no-quit"]'
]

{ #category : #accessing }
CCTemplate >> zipArchiveForBuildWith: aServiceAccount [
	| dict |
	dict := Dictionary new.
	dict at: #Dockerfile put: self content.
	dict at: 'service_account.json' put: aServiceAccount jsonStringCertificate .
	dict at: 'load.st' put: self depFile , self loadFile.
	^ CCStorage createZipFileOf: dict
]
