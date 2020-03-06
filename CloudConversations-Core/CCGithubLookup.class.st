"
I handle lookup of Smalltalk project on Github
"
Class {
	#name : #CCGithubLookup,
	#superclass : #CCGenericLookup,
	#instVars : [
		'pageZise',
		'client',
		'query',
		'result'
	],
	#category : #'CloudConversations-Core-Lookup'
}

{ #category : #'accessing - backend' }
CCGithubLookup >> findProjectsFromPage: page [
	"https://api.github.com/search/repositories?per_page=$perPage&page=$pIndex&q=topic:pharo"

	| path |
	path := 'https://api.github.com/search/repositories?per_page='
		, pageZise asString , '&page=' , page asString , '&q=' , query.
	Transcript show:'path=',path;cr.	
	client
		contentReader: [ :entity | NeoJSONReader fromString: entity contents ];
		url: path;
		get.
	^ client contents at: #items ifAbsent: [ #() ]
]

{ #category : #'accessing - backend' }
CCGithubLookup >> findSmalltalkProjects [
	^ self findProjectsFromPage: 0
]

{ #category : #accessing }
CCGithubLookup >> getSourceDirForItem: item [
	"https://raw.githubusercontent.com/$user/$pkgName/master/README.md"

	| url s html_url reader |
	html_url := item at: #html_url.
	s := html_url substrings: '/'.
	url := 'https://raw.githubusercontent.com/' , (s at: 3) , '/'
		, (s at: 4) , '/master/.project'.
	(client := ZnClient new)
		url: url;
		get.
	reader := [ :string | (NeoJSONReader on: string readStream) next ].
	result := client contents
		copyReplaceAll: $' asString
		with: $" asString.
	^ (reader value: result) at: 'srcDirectory'
]

{ #category : #initialization }
CCGithubLookup >> initialize [ 
	pageZise := 10.
	client := ZnClient new.
	query := 'topic:smalltalk'
	
]

{ #category : #accessing }
CCGithubLookup >> installStringForItem: item [
	| html_url s repoDir |
	html_url := item at: #html_url.
	s := html_url substrings: '/'.
	repoDir := self getSourceDirForItem: item.
	^ 'Metacello new repository: ''github://',(s at:3) , '/' , (s at: 4),'/', repoDir, '''; baseline: ''',
	(s at: 4), '''; load. '
]

{ #category : #accessing }
CCGithubLookup >> pageZise [
	^ pageZise
]

{ #category : #accessing }
CCGithubLookup >> pageZise: anObject [
	pageZise := anObject
]

{ #category : #accessing }
CCGithubLookup >> printStringForItem: item [
	^ item name , ' - ' , item description
]

{ #category : #accessing }
CCGithubLookup >> query [
	^ query
]

{ #category : #accessing }
CCGithubLookup >> query: anObject [
	query := anObject
]
