Class {
	#name : #CCGithubLookupTest,
	#superclass : #TestCase,
	#category : #'CloudConversations-Core-Tests'
}

{ #category : #'as yet unclassified' }
CCGithubLookupTest >> testFindProjectsFromPage [
	| githubLookup result |
	githubLookup := CCGithubLookup new.
	result := githubLookup findProjectsFromPage: 0.
	self assert: (result size) = 0 equals: false.
	
	
]

{ #category : #'as yet unclassified' }
CCGithubLookupTest >> testGetSourceDirForitem [
	| githubLookup result item |
	item := Dictionary new.
	item at: #html_url put: 'https://github.com/svenvc/ston'.
	githubLookup := CCGithubLookup new.
	result := githubLookup getSourceDirForItem: item.
	Transcript show: result;cr.
	self assert: (result size) = 0 equals: false.
	
	
]

{ #category : #'as yet unclassified' }
CCGithubLookupTest >> testInstallStringForitem [
	| githubLookup result item |
	item := Dictionary new.
	item at: #html_url put: 'https://github.com/svenvc/ston'.
	githubLookup := CCGithubLookup new.
	result := githubLookup installStringForItem: item.
	Transcript show: result;cr.
	self assert: (result size) = 0 equals: false.
	
	
]
