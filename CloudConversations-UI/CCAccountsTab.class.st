Class {
	#name : #CCAccountsTab,
	#superclass : #TabMorph,
	#instVars : [
		'accounts',
		'accountsPanel',
		'accountDetail'
	],
	#category : #'CloudConversations-UI-Accounts'
}

{ #category : #accessing }
CCAccountsTab >> accounts: aCollection [
	|  |
	accounts := aCollection.
	accountsPanel accounts: accounts.
	
	accountDetail showAccount.
	accountsPanel
		onAccountSelected: [ :selectedAccount | 
			accountDetail isNil
				ifFalse: [ self morph removeMorph: accountDetail ].
			accountDetail
				account: selectedAccount item;
				showAccount ].
	self morph addMorph: accountDetail after: accountsPanel
]

{ #category : #initialization }
CCAccountsTab >> initialize [ 
	super initialize.
	self morph: Morph new.
	self morph color: (Color gray: 0.2).
	accountsPanel := CCAccountsPanel new.
	accountDetail := CCAccountDetail new.
	Transcript show:'CCAcoountsTab adding acountsPanel.';cr.
	self morph addMorph: accountsPanel.
		Transcript show:'CCAcoountsTab adding acountDetail.';cr.
	self morph addMorph: accountDetail .
		Transcript show:'CCAcoountsTab addiing done...';cr.
	self
		layoutPolicy: TableLayout new;
		height:400;
		listDirection: #leftToRight ;
		hResizing: #shrinkWrap ;
		vResizing: #shrinkWrap .
	self closeable: false.
	^ self
]
