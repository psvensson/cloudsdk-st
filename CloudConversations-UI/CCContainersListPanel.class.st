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
	account ifNotNil: [ self getContainerListFromCloud ]
]

{ #category : #rendering }
CCContainersListPanel >> asynchronousResolver: item [
	^  self getContainerFor: item
]

{ #category : #rendering }
CCContainersListPanel >> asynchronouslyResolveSelectedItems [
	^ true
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
CCContainersListPanel >> getContainerFor: aContainerProxy [
	| containerVersions cdict container future |
	future := TKTFuture new.
	(containerConnection listRepositoryTags: (aContainerProxy name))
		onSuccessDo: [ :tags | 
			containerVersions := tags at: #manifest ifAbsent: [  ].
			containerVersions
				ifNotEmpty: [ cdict := CCContainer getLatestContainerVersion: containerVersions.
					cdict at: #name put: aContainerProxy name.
					cdict at: #tags put: (tags at: #tags).
					cdict at: #manifest put: containerVersions.
					container := CCContainer from: cdict.
					future deploySuccess: container ] ].
	^ future
]

{ #category : #initialization }
CCContainersListPanel >> getContainerListFromCloud [
	| connection future |
	connection := CCMainController 
		getConnectionForAccount: CCMainController lastUsedAccount.
	connection
		ifNotNil: [ connection connect.
			containerConnection := CCGoogleContainers with: connection.
			future := containerConnection listContainers.
			future
				onSuccessDo: [ :clist | 
					CCMainController getMainWindow hideBusyIcon.
					clist
						ifNotNil: [ (clist includesKey: #errors)
								ifTrue: [ self handleError: clist ]
								ifFalse: [ self handleFetchedContainerList: clist ] ] ];
				onFailureDo: [ :fail | self reportProblem: fail ] ]
]

{ #category : #accessing }
CCContainersListPanel >> handleError: clist [
	| msg |
	msg := (clist at: #errors) at: 1.
	UIManager default inform: (msg at: #code) , ': ' , (msg at: #message)
]

{ #category : #accessing }
CCContainersListPanel >> handleFetchedContainerList: clist [
	| cs |
	cs := clist at: #child.
	self listCollection: (cs collect: [:name | CCContainerProxy new name: name; yourself]).
	cs isEmpty
		ifFalse: [ self itemSelected: 1 ]
]

{ #category : #initialization }
CCContainersListPanel >> initialize [
	super initialize.	
	self initializeButtons.
]

{ #category : #initialization }
CCContainersListPanel >> initializeButtons [
	reloadButton := CCMainController
		buildButtonText: #reloadButtonLabel 
		action: #reloadResults
		model: self.
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

{ #category : #accessing }
CCContainersListPanel >> reloadButtonLabel [
	^ 'Reload'
]

{ #category : #initialization }
CCContainersListPanel >> reloadResults [
	Transcript show:'CCContainerList reloadResult';cr.
	CCMainController getMainWindow showBusyIcon.
	self getContainerListFromCloud
	
]

{ #category : #accessing }
CCContainersListPanel >> reportProblem: fail [
	Transcript
		show: 'failed to get container list: ' , fail asString;
		cr
]

{ #category : #initialization }
CCContainersListPanel >> selectedContainerIndex [
	^ selectedContainerIndex
]

{ #category : #rendering }
CCContainersListPanel >> updateList [
	self reloadResults
]
