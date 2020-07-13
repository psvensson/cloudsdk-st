Class {
	#name : #CCGoogleRunDeployments,
	#superclass : #CCGoogleDeployments,
	#instVars : [
		'endpoint'
	],
	#category : #'CloudConversations-Core-Deployments'
}

{ #category : #accessing }
CCGoogleRunDeployments class >> listServicesForConnection: connection andEndpoint: endpoint [
	| projectId url |	
	projectId := connection serviceAccount projectId.
	url := endpoint , '/apis/serving.knative.dev/v1/namespaces/'
		, projectId , '/services'.
	Transcript
		show: 'list service for: ' , url;
		cr.
	^ connection secureJSONCallTo: url
]

{ #category : #'as yet unclassified' }
CCGoogleRunDeployments class >> serviceEndpoints [
	| endpoints |
	endpoints := Dictionary new.
	endpoints at: 'us-central1' put: 'https://us-central1-run.googleapis.com';
		 at: 'asia-northeast-1' put: 'https://asia-northeast1-run.googleapis.com';
		 at: 'europe-west-1' put: 'https://europe-west1-run.googleapis.com';
		 at: 'us-east1' put: 'https://us-east1-run.googleapis.com';
		 at: 'europe-west4' put: 'https://europe-west4-run.googleapis.com';
		 at: 'us-west1' put: 'https://us-west1-run.googleapis.com';
		 at: 'asia-east1' put: 'https://asia-east1-run.googleapis.com';
		 at: 'europe-north1' put: 'https://europe-north1-run.googleapis.com';
		 at: 'us-east4' put: 'https://us-east4-run.googleapis.com'.
	^ endpoints 
]

{ #category : #accessing }
CCGoogleRunDeployments >> createDeployment: serviceResource [
	| url projectId jsonString |
	"POST https://{endpoint}/apis/serving.knative.dev/v1/{parent}/services"
	projectId := connection serviceAccount projectId.
	jsonString := STONJSON toString: serviceResource .
	url := endpoint,'/apis/serving.knative.dev/v1/namespaces/',projectId ,'/services'.
	^ connection secureJSONCallTo: url JSONContent: jsonString 
]

{ #category : #accessing }
CCGoogleRunDeployments >> createService: name fromContainer: container [
	|resource|
	resource := self getServiceResourceFrom: container.
	^ self createDeployment: resource
]

{ #category : #accessing }
CCGoogleRunDeployments >> endpoint [
	^ endpoint
]

{ #category : #accessing }
CCGoogleRunDeployments >> endpoint: anObject [
	endpoint := anObject
]

{ #category : #accessing }
CCGoogleRunDeployments >> getMetaDataForName: name [
	|metaData|
	metaData := Dictionary new.
	metaData at: #name put: name.
	metaData at: #namespace put: connection serviceAccount projectId.
	^ metaData
]

{ #category : #accessing }
CCGoogleRunDeployments >> getServiceResourceFrom: container [
	|r|
	r := Dictionary new.
	r at: #apiVersion put: 'serving.knative.dev/v1'.
	r at: #kind put: 'Service'.
	r at: #metadata put: (self getMetaDataForName: container name).
	r at: #spec put: (self getServiceSpecForContainer: container).
	"r at: #status put: (self getStatusForCotnainer: container)."
	^ r
]

{ #category : #accessing }
CCGoogleRunDeployments >> getServiceSpecForContainer: container [
	|s|
	s := Dictionary new.
	s at: #template put: (self getTemplateForContainer: container).
	s at: #traffic put: (self getTrafficForContainer: container).
	^ s
]

{ #category : #accessing }
CCGoogleRunDeployments >> getSpecForContainer: container [
	| spec |
	spec := Dictionary new.
	spec at: #containerConcurrency put: '80'.
	spec at: #timeoutSeconds put: '300'.
	spec at: #serviceAccountName put: (connection serviceAccount name).
	spec at: #containers put: (container getCreationSpec).
	^ spec
]

{ #category : #accessing }
CCGoogleRunDeployments >> getStatusForCotnainer: container [
	|s conditions|
	s := Dictionary new.
	s at: #observedGeneration put: '1'.
	conditions := Dictionary new.
	conditions at: #Ready put: true.
	s at: #conditions put: (conditions).
	"------- Hang on, the docs is unclear. I assume that stayus should not be part of the inital service object sent on creation, since otherwise it is named as read-only"
	^ s
]

{ #category : #accessing }
CCGoogleRunDeployments >> getTemplateForContainer: container [
	| template |
	template := Dictionary new.
	template at: #spec put: (self getSpecForContainer: container).
	^ template
]

{ #category : #accessing }
CCGoogleRunDeployments >> getTrafficForContainer: container [
	|t|
	t := Dictionary new.
	t at: #configurationName put: 'deafult'.
	t at: #percent put: 100.
	^ t
]

{ #category : #accessing }
CCGoogleRunDeployments >> initialize [ 
	super initialize.
	type := 'cloudrun'
]

{ #category : #accessing }
CCGoogleRunDeployments >> listDeployments [
	| url projectId |
	projectId := connection serviceAccount projectId.
	url := endpoint,'/apis/serving.knative.dev/v1/',projectId ,'/services'.
	^ connection secureJSONCallTo: url
]
