"
I am the superclass for all lookup classes that search for Smalltalk projects in different places
"
Class {
	#name : #CCGenericLookup,
	#superclass : #Object,
	#category : #'CloudConversations-Core-Lookup'
}

{ #category : #constants }
CCGenericLookup >> getPiInstallStringForDockerfile [
	^  'sh -c "$(curl -fsSL https://raw.githubusercontent.com/hernanmd/pi/master/install.sh)"'
]
