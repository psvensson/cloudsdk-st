Class {
	#name : #CCTemplate,
	#superclass : #Object,
	#instVars : [
		'content',
		'loadingContent',
		'name',
		'dependencies',
		'imagePackages'
	],
	#category : #'CloudConversations-Models'
}

{ #category : #accessing }
CCTemplate >> asString [
	^ self name 
]

{ #category : #accessing }
CCTemplate >> content [
	content isNil ifTrue: [ self regenerateContent  ].
	^ content
]

{ #category : #accessing }
CCTemplate >> content: anObject [
	content := anObject
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
	Transcript show:'dockerfile deps: ',dependencies size asString;cr.
	rv := ''.
	dependencies do: [  :dep |
		|istr|
		istr := dep installString isNil ifTrue: [ '' ] ifFalse: [ dep installString ].
		rv := rv, istr].
	^ rv
]

{ #category : #accessing }
CCTemplate >> firstPartDockerfile [
	^ '######################################
# Based on Ubuntu image
######################################
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
	loadingContent := ''
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
	content := self firstPartDockerfile , self dependenciesPartDockerfile
		, self secondPartDockerfile
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
