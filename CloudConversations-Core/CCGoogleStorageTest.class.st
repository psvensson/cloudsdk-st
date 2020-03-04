Class {
	#name : #CCGoogleStorageTest,
	#superclass : #TestCase,
	#instVars : [
		'certificateString'
	],
	#category : #'CloudConversations-Core-Tests'
}

{ #category : #running }
CCGoogleStorageTest >> setUp [
	certificateString := 'service_account.json' asFileReference readStream contents.
]

{ #category : #tests }
CCGoogleStorageTest >> testListStorage [
	| serviceAccount status connection storage result |
	serviceAccount := CCServiceAccount withCertificateAsJSONString: certificateString .	
	serviceAccount cloudType: 'google'.	
	connection := CCGoogleConnection with: serviceAccount .
	status := connection connect .
	self assert: status equals: true.
	storage := CCGoogleStorage with: connection.
	result := storage list.
	"Transcript show:'storage list found ',result size asString,' items';cr.
	result do: [ :file |
		Transcript show: (file at: #name);cr. ]."
	self assert: result size > 0 equals: true
]

{ #category : #tests }
CCGoogleStorageTest >> testUploadStorage [
	| serviceAccount status connection storage result files zipfile |
	serviceAccount := CCServiceAccount withCertificateAsJSONString: certificateString .	
	serviceAccount cloudType: 'google'.	
	connection := CCGoogleConnection with: serviceAccount .
	status := connection connect .
	self assert: status equals: true.
	storage := CCGoogleStorage with: connection.
	files := Dictionary new.
	files at: #Dockerfile put: 'ding dong, the withc is dead'.
	zipfile := CCStorage createZipFileOf: files.	
	result :=storage upload: zipfile asString as: 'smol_test.zip'.
	Transcript show:'storage upload result: ',result asString;cr.
	self assert: result size > 0 equals: true
]
