Class {
	#name : #CCGroupbox,
	#superclass : #GroupboxMorph,
	#instVars : [
		'panel',
		'detail'
	],
	#category : #'CloudConversations-UI-Common'
}

{ #category : #initialization }
CCGroupbox >> getDetailPanel [
	self subclassResponsibility 
]

{ #category : #initialization }
CCGroupbox >> getListPanel [
	self subclassResponsibility 
]

{ #category : #initialization }
CCGroupbox >> initialize [
	super initialize.
	self vResizing: #shrinkWrap.
	panel := self getListPanel.
	panel onItemSelected: [ :selectedItem | detail item: selectedItem ].
	detail := self getDetailPanel.
	detail onItemUpdate: [ panel updateList ].
	detail onItemDelete: [ :item | panel deleteItem ].
	self initializeLayout.	
	self addMorph: panel.
	self addMorph: detail.
	self label: self modelName
]

{ #category : #initialization }
CCGroupbox >> initializeLayout [
	self
		layoutPolicy: TableLayout new;
		listDirection: #topToBottom;
		"width:350;"
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap
]

{ #category : #initialization }
CCGroupbox >> modelName [
	self subclassResponsibility  
]
