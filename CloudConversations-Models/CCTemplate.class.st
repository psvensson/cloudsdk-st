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
	^ '######################################
# Based on Ubuntu image
######################################
USER root
FROM ubuntu

######################################
# Basic project infos
######################################
LABEL maintainer="',Author fullName,'"

######################################
# Update Ubuntu apt and install some tools
######################################
RUN  apt-get update \
  && apt-get install -y wget \
  && apt-get install -y git \
  && apt-get install -y unzip \
  && rm -rf /var/lib/apt/lists/*

######################################
# Have an own directory for the tool
######################################
RUN mkdir webapp
WORKDIR webapp

######################################
# Download Pharo using Zeroconf & start script
######################################
RUN wget -O- https://get.pharo.org/64/70+vm | bash
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
	content := "self firstPartDockerfile , self dependenciesPartDockerfile
		, self secondPartDockerfile"
		'######################################
# Based on a pre-built Pharo 8 Debian image
######################################
FROM psvensson/pharo8-base

######################################
# Basic project infos
######################################
LABEL maintainer="',Author fullName,'"

COPY service_account.json service_account.json
RUN export certificate="$(cat service_account.json)"
COPY load.st load.st
COPY setup.sh setup.sh
RUN chmod +x setup.sh
RUN setup.sh; echo 0

RUN ./pharo Pharo.image load.st; echo 0

######################################
# Expose port 8080 of Zinc outside the container
######################################
EXPOSE 8080

######################################
# Finally run headless as server
######################################
ENTRYPOINT ["./pharo","--headless", "Pharo.image", "--no-quit"]'


]

{ #category : #accessing }
CCTemplate >> secondPartDockerfile [
	^ '
RUN ./pharo --headless Pharo.image eval --save "ZnServer startDefaultOn: 8080"
######################################
# Expose port 8080 of Zinc outside the container
######################################
EXPOSE 8080

######################################
# Finally run headless as server
######################################
CMD ./pharo --headless Pharo.image --no-quit'
]

{ #category : #accessing }
CCTemplate >> setupFile [
	^ '#!/bin/sh\n cat <<END | tee /etc/security/limits.d/pharo.conf\n
Step #0: *      hard    rtprio  2\n
Step #0: *      soft    rtprio  2\n
Step #0: END'
]

{ #category : #accessing }
CCTemplate >> startFile [
	^ '#!/bin/bash\n./pharo --headless Pharo.image --no-quit'
]

{ #category : #accessing }
CCTemplate >> zipArchiveForBuildWith: aServiceAccount [
	| dict |
	dict := Dictionary new.
	dict at: #Dockerfile put: self content.
	dict at: 'setup.sh' put: self setupFile .
	dict at: 'startup.sh' put: self startFile .
	dict at: 'service_account.json' put: aServiceAccount jsonStringCertificate .
	dict at: 'load.st' put: self depFile , self loadFile.
	^ CCStorage createZipFileOf: dict
]
