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
		'lastUsedStorage',
		'mainWindow'
	],
	#category : #'CloudConversations-UI-Main'
}

{ #category : #'as yet unclassified' }
CCMainController class >> buildButtonText: text action: action model: model [
	| b |
	b := PluggableButtonMorph
		on: model
		getState: nil
		action: action
		label: text
		menu: nil.
	b font: (LogicalFont familyName: 'Source Sans Pro' pointSize: 12).
	"backgroundColor: Color lightGreen"
	"hResizing: #spaceFill"
	"vResizing: #spaceFill"
	^ b
]

{ #category : #'as yet unclassified' }
CCMainController class >> buildButtonText: text action: action pointSize: pt color: c model: model [
	| b |
	b := PluggableButtonMorph
		on: model
		getState: nil
		action: action
		label: text
		menu: nil.
	b
		font: (LogicalFont familyName: 'Source Sans Pro' pointSize: pt);
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap.
	
	^ b
]

{ #category : #'as yet unclassified' }
CCMainController class >> buildButtonText: text action: action pointSize: pt model: model [
	| b |
	b := PluggableButtonMorph
		on: model
		getState: nil
		action: action
		label: text
		menu: nil.
	b font: (LogicalFont familyName: 'Source Sans Pro' pointSize: pt).
	"backgroundColor: Color lightGreen"
	"hResizing: #spaceFill"
	"vResizing: #spaceFill"
	^ b
]

{ #category : #accessing }
CCMainController class >> connection [
	^ connection
]

{ #category : #accessing }
CCMainController class >> formattedDateFromMillis: millis [
	| date rv |
	date := DateAndTime fromUnixTime: (millis asInteger) / 1000.
	rv := date asLocalStringYMDHM .
	^ rv
]

{ #category : #'as yet unclassified' }
CCMainController class >> futuresAll: futures [
	"Works like Promise.All() in JavaScript"
	| count results fblock |
	count := futures size.
	results := OrderedCollection new.
	fblock := TKTFuture new.
	futures
		do: [ :each | 
			each
				onSuccessDo: [ :v | 
					Transcript show:'--- onSuccess: ',v asString,' count = ',count asString;cr.
					v ifNotNil: [results add: (v value) ].
					count := count - 1.
					count < 1
						ifTrue: [ 
							Transcript show:'--deploySuccess--';cr.
							fblock deploySuccess: results ] ] ]  .
	^ fblock 
]

{ #category : #'as yet unclassified' }
CCMainController class >> futuresAll: futures whenDone: aBlock [
	"Works like Promise.All() in JavaScript"

	| count results fblock |
	count := futures size.
	results := OrderedCollection new.
	fblock := [ futures
		do:
			[ :each | 
			each
				onSuccessDo: [ :v | 
					Transcript
						show: '--- onSuccess: ' , v asString;
						cr.
					v isNil
						ifFalse: [ results add: v results value ].
					count := count - 1.
					count < 1
						ifTrue: [ aBlock value: results ] ].
			each
				onFailureDo: [ :err | 
					Transcript
						show: '--- onFailure: ' , err asString;
						cr.
					results add: err ] ] future ]
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
	account
		ifNotNil: [ connections ifNil: [ connections := Dictionary new ].
			connection := (connections includesKey: account)
				ifTrue: [ connections at: account ]
				ifFalse: [ account cloudType = 'google'
						ifTrue: [ connection := CCGoogleConnection with: account ] ].
			connections at: account name put: connection.
			connection onStartConnect: [ "mainWindow showBusyIcon" ].
			connection onEndConnect: [ "mainWindow hideBusyIcon" ].
			lastUsedConnection := connection ].
	^ connection
]

{ #category : #accessing }
CCMainController class >> getMainWindow [
	^ mainWindow 
]

{ #category : #accessing }
CCMainController class >> getTextMorph: text color: c pointSize: pt [
	| m |
	m := text asMorph.
	m
		color: c;
		font: (LogicalFont familyName: 'Source Sans Pro' pointSize: pt).
	^ m
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
				ifNotNil: [ lastUsedContainer := CCGoogleContainers with: lastUsedConnection ] ].
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

{ #category : #accessing }
CCMainController class >> setMainWindow: aWindow [
	Transcript show: 'setting main window in CCMainCOntroller';cr.
	mainWindow := aWindow 
]
