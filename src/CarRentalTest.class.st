"
'<historical>' prior: 0
"
Class {
	#name : #CarRentalTest,
	#superclass : #TestCase,
	#category : #'LifewareHR-Tests'
}

{ #category : #'1.1 examples ' }
CarRentalTest >> testBooleanCondition [
	| counter |
	counter := OrderedCollection new.
	1 > 0
		ifTrue: [ counter add: 1 ]
		ifFalse: [ counter add: 2 ].
	self assert: counter first equals: 1
]

{ #category : #'2 exercise' }
CarRentalTest >> testDiscountedPrice [
	"Starting from the 4th day, the customer gets a rebate of 10% on the daily rate"

	"extend the code to make this test green"

	| carRental myGolf |
	carRental := CarRental new.
	myGolf := Car golf.
	carRental addCar: myGolf.
	self assert: (carRental priceFor: myGolf days: 4) equals: 390
]

{ #category : #'3 exercise' }
CarRentalTest >> testFixedNumberOfCars [
	"Our car rental has now a fixed number of cars. Extend the code to make this test green: define the missing (red) methods in the class CarRental"

	| carRental |
	carRental := CarRental new.
	carRental
		addCar: Car panda;
		addCar: Car panda;
		addCar: Car tesla.
	self assert: carRental totalCars size equals: 3
]

{ #category : #'0 examples' }
CarRentalTest >> testPandaPrice [
	| panda |
	panda := Car panda.
	self assert: panda price equals: 50
]

{ #category : #'0 examples' }
CarRentalTest >> testRentPanda [
	| carRental myPanda |
	carRental := CarRental new.
	myPanda := Car panda.
	carRental addCar: myPanda.
	self assert: (carRental priceFor: myPanda days: 3) equals: 150
]

{ #category : #'1 warming up exercise' }
CarRentalTest >> testRentTesla [
	"Test: Renting a Tesla for 3 days"
	|myRental tesla|
	
	myRental := CarRental new.	
	tesla:= Car tesla.
	myRental addCar: tesla.
	self assert: (myRental priceFor: tesla days: 3) equals: 400*3
]

{ #category : #'3 exercise' }
CarRentalTest >> testRenting [
	"The same car cannot be rented twice. Extend the code to make this test green: define the missing (red) methods in the class CarRental"

	| carRental redPanda yellowPanda blackTesla |
	carRental := CarRental new.
	redPanda := Car panda.
	yellowPanda := Car panda.
	blackTesla := Car tesla.
	carRental
		addCar: redPanda;
		addCar: yellowPanda;
		addCar: blackTesla.
	self assert: carRental availableCars size equals: 3.
	carRental rent: redPanda days: 5.
	self assert: carRental availableCars size equals: 2.
	self assert: carRental rentedCars size equals: 1
]

{ #category : #'4 exercise' }
CarRentalTest >> testRentingWithDates [
	"Extend the code and write a test for the following scenario: Our car rentals has 3, 2 tesla and 1 golf. Customer Bob call our service asking for a golf for 5 days starting on the 1st of April. Unfortunately the golf is already rented up to the 3rd of april. Our service tells Bob that we have two available teslas, and that they can provide an individual discount of 10 euros per day. 

Our informatic system should offer the functionalities to sustain the above scenario, for example it should know whether the panda is free in the requested period and so on...

write test case(s) and code to simulate this scenario"

	|carRental blueGolf blueTesla blackTesla initialDate lastDate|
	carRental := CarRental new.
	blueGolf := Car golf.
	blueTesla := Car tesla.
	blackTesla := Car tesla.
	carRental
			addCar: blueGolf  ;
			addCar: blueTesla  ;
			addCar: blackTesla .
	initialDate := Date year:2021 month: 4 day: 1.
	lastDate := initialDate addDays: 4. 
	
	"golf is rented from April 1 to April 3"
	carRental rent: blueGolf from: initialDate to: (initialDate addDays: 2).
	
	self assert: (blueGolf availableFrom: initialDate to: lastDate) equals: false .
	self assert: (blueTesla availableFrom: initialDate to: lastDate) equals: true .
	self assert: (blackTesla availableFrom: initialDate to: lastDate) equals: true .
	"If we try to rent a golf, knowing that is not available, another recomendations will show up."
	carRental rent: blueGolf from: initialDate to: lastDate .
	
	"We suppose that we chose the blueTesla for this days (using an UI for exammple, car number = 1)"
	
	self assert: (carRental priceFor: blueTesla days:5 ) equals: 400*3+(360*2)
	
	





]

{ #category : #'1 warming up exercise' }
CarRentalTest >> testTeslaPrice [
	"Test for Tesla Price "
	|myTesla|
	myTesla := Car tesla.
	self assert: myTesla price equals: 400.
]

{ #category : #AdditionalTests }
CarRentalTest >> testWrongCar [
	"Check what is the response if we introduce a car we don't have inside our renting system."

	| carRental days golf tesla |
	carRental := CarRental new.
	golf := Car golf.
	tesla := Car tesla.
	carRental addCar: golf.
	days:= 5.
	
	carRental rent: tesla days:days.
	self assert: (tesla available: Date today) equals:true.
	self assert: (carRental availableCars size) equals:1.
	self assert: (carRental rentedCars size) equals: 0.
	self assert: (carRental priceFor: tesla days:5 ) equals: 0.
	
	
	
]

{ #category : #AdditionalTests }
CarRentalTest >> testWrongDates [
	"Check what is the response if we introduce wrong dates into our renting system."

	| carRental initialDate lastDate golf |
	carRental := CarRental new.
	golf := Car golf.
	carRental addCar: golf.
	initialDate := Date year:2021 month:4 day:1.
	lastDate := Date year: 2020 month:4 day: 5 ."We introduced the year incorrectly."
	carRental rent: golf from:  initialDate to: lastDate .
	
	self assert: (carRental availableCars size) equals:1.
	self assert: (carRental priceFor: golf days:-5) equals: 0.
	
	
]
