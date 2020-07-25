Class {
	#name : #CCContainersListPanel,
	#superclass : #CCListPanel,
	#instVars : [
		'containerList',
		'containers',
		'selectedContainerIndex',
		'account',
		'table',
		'containerConnection',
		'reloadButton'
	],
	#classInstVars : [
		'savedContainers'
	],
	#category : #'CloudConversations-UI-Containers'
}

{ #category : #accessing }
CCContainersListPanel class >> savedContainers [
	^ savedContainers
]

{ #category : #accessing }
CCContainersListPanel class >> savedContainers: anObject [
	savedContainers := anObject
]

{ #category : #accessing }
CCContainersListPanel >> account [
	^ account
]

{ #category : #accessing }
CCContainersListPanel >> account: anObject [
	account := anObject.
	self getContainerListFromCloud
]

{ #category : #accessing }
CCContainersListPanel >> containers [
	^ containers
]

{ #category : #accessing }
CCContainersListPanel >> containers: anObject [
	containers := anObject
]

{ #category : #accessing }
CCContainersListPanel >> deleteContainer [
	Transcript show:'delte container (unimplemented)';cr.
]

{ #category : #accessing }
CCContainersListPanel >> deployContainer [
	Transcript show:'deploycontainer (unimplemented)';cr.
]

{ #category : #initialization }
CCContainersListPanel >> getContainerFor: aContainerName [
	| containerVersions cdict container future |
	future := TKTFuture new.
	(containerConnection listRepositoryTags: aContainerName)
		onSuccessDo: [ :tags | 
			containerVersions := tags at: #manifest ifAbsent: [  ].
			containerVersions
				ifNotNil: [ cdict := CCContainer getLatestContainerVersion: containerVersions.
					cdict at: #name put: aContainerName.
					cdict at: #tags put: (tags at: #tags).
					cdict at: #manifest put: containerVersions.
					container := CCContainer from: cdict.
					future deploySuccess: container ] ].
	^ future
]

{ #category : #initialization }
CCContainersListPanel >> getContainerListFromCloud [
	| connection future |
	connection := CCMainController getConnectionForAccount: account.
	connection connect.
	containerConnection := CCGoogleContainers with: connection.
	future := containerConnection listContainers.
	future
		onSuccessDo: [ :clist | 
			(clist includesKey: #errors)
				ifTrue: [ | msg |
					msg := (clist at: #errors) at: 1.
					UIManager default
						inform: (msg at: #code) , ': ' , (msg at: #message) ]
				ifFalse: [ | containerFutures |
					containerFutures := (clist at: #child)
						collect: [ :each | self getContainerFor: each ].
					(CCMainController futuresAll: containerFutures)
						onSuccessDo: [ :cs | 
							self listCollection: cs.
							cs isEmpty
								ifFalse: [ self itemSelected: 1 ].
								 ] ] ];
		onFailureDo: [ :fail | 
			Transcript
				show: 'failed to get container list: ' , fail asString;
				cr ]
]

{ #category : #initialization }
CCContainersListPanel >> initialize [
	super initialize.	
	self initializeButtons.
	containers := CCMainWindow models containers.
	
]

{ #category : #initialization }
CCContainersListPanel >> initializeButtons [
	reloadButton := SimpleButtonMorph newWithLabel: 'Reload'.
	reloadButton
		color: Color green darker darker;
		target: self;
		actionSelector: #reloadResults.
	self addMorph: reloadButton.
	
]

{ #category : #initialization }
CCContainersListPanel >> initializeTable [
	table := CCContainerDetail new.
	table
		top: 35.
		"left: 250"
	self addMorph: table
]

{ #category : #initialization }
CCContainersListPanel >> reloadResults [
	self getContainerListFromCloud
	
]

{ #category : #initialization }
CCContainersListPanel >> selectedContainerIndex [
	^ selectedContainerIndex
]

{ #category : #rendering }
CCContainersListPanel >> updateList [
	self reloadResults
]
