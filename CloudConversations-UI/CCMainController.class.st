"
I hold all the container and deployment info, and is the way the UI components create and ask for data
"
Class {
	#name : #CCMainController,
	#superclass : #Object,
	#instVars : [
		'fileMenu',
		'tools',
		'text',
		'dock',
		'holder',
		'cloud',
		'hat',
		'teacup',
		'tabmanager',
		'certificateDialog'
	],
	#classInstVars : [
		'connection',
		'connections',
		'accounts',
		'lastUsedAccount',
		'lastUsedConnection',
		'lasUsedContainer',
		'lastUsedContainer',
		'lastUsedStorage'
	],
	#category : #'CloudConversations-UI-Main'
}

{ #category : #accessing }
CCMainController class >> connection [
	^ connection
]

{ #category : #adding }
CCMainController class >> getAccountForCertificate: cert kind: kind [
	| account |
	accounts ifNil: [ accounts := Dictionary new ].
	account := (accounts includesKey: cert)
		ifTrue: [ accounts at: cert ]
		ifFalse: [ CCServiceAccount withCertificateAsJSONString: cert ].
	account cloudType: kind.		
	accounts at: cert put: account.	
	lastUsedAccount := account.	
	^ account
]

{ #category : #adding }
CCMainController class >> getConnectionForAccount: account [
	connections ifNil: [ connections := Dictionary new ].
	connection := (connections includesKey: account)
		ifTrue: [ connections at: account ]
		ifFalse: [ account cloudType = 'gcloud'
				ifTrue: [ connection := CCGoogleConnection with: account ] ].
	connections at: account put: connection.
	lastUsedConnection := connection .
	^ connection
]

{ #category : #accessing }
CCMainController class >> lastUsedAccount [
	^ lastUsedAccount
]

{ #category : #accessing }
CCMainController class >> lastUsedAccount: anObject [
	lastUsedAccount := anObject
]

{ #category : #accessing }
CCMainController class >> lastUsedConnection [
	lastUsedConnection ifNil: [ UIManager default
				alert: 'You need to select a service account to connect to'
				title: 'No default connection' ].
	^ lastUsedConnection
]

{ #category : #accessing }
CCMainController class >> lastUsedConnection: anObject [
	lastUsedConnection := anObject
]

{ #category : #accessing }
CCMainController class >> lastUsedContainer [
	lastUsedContainer
		ifNil: [ lastUsedConnection
				ifNil: [ UIManager default
						alert: 'You need to select a service account to connect to'
						title: 'No default connection' ]
				ifNotNil: [ lastUsedContainer := CCContainers with: lastUsedConnection ] ].
	^ lastUsedContainer
]

{ #category : #accessing }
CCMainController class >> lastUsedStorage [
	lastUsedStorage
		ifNil: [ lastUsedConnection
				ifNil: [ UIManager default
						alert: 'You need to select a service account to connect to'
						title: 'No default connection' ]
				ifNotNil: [ lastUsedStorage := CCStorage with: lastUsedConnection ] ].
	^ lastUsedStorage
]
