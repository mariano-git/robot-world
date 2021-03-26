## Foreword
First of all, thanks for taking the time to take this tech challenge. We really appreciate it. And now, are you ready to rumble? :)

## Robot World

It's the year 2020, the developers are part of the past. You are probably the last dev on the earth and you are pretty busy, so you decide the best is the robots can handle all the work instead of you.

## Robot builder and initial data structure.
This robot will be the one in charge to generate the data that will feed the whole process.

 + Model a Car factory and the cars. The factory will have 3 assembly lines: “Basic structure”, “Electronic devices” and “Painting and final details”. When the car passes throughout the 3 lines we can consider it as complete.
 + The cars have simple parts: 4 wheels, 1 chassis, 1 laser, 1 computer, 1 engine, price, cost price and 2 seats. We should know the car year and the model name. The car computer should know if the car has any defect and where it is (which part). We should know the car model stock.
 + We have a warehouse when the cars are parked after completion. We should know how many cars by the model we have in the warehouse. We call this factory stock.
 + The cars should answer if it's a complete car or not and its current assembly stage.
 + Create a robot builder, once you create the data structure, you have to create a process (our robot builder) which will generate random cars each minute, it will be the one assigning the model names, the year, the parts, the assembly stage, the defects. 
Each minute 10 new cars are created, every day the robot builder process start over from scratch wiping all the cars at the end of the day. Even though the generated cars are randomly generated, we have only 10 different car models. 


## Guard robot
-  This robot will be looking for any kind of defect, it will send an alert when the defect is detected and it will inform the details using slack.
Here you go, a curl example (of course you’ll do this using Ruby rather than CURL)

curl -X POST -H 'Content-type: application/json' --data '{"text":"Hello, World!"}' https://hooks.slack.com/services/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

You can check the details here:
https://api.slack.com/docs/messages
Note: The URL =>  https://hooks.slack.com/services/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 is a real URL, it will post the message you will format to the person who is reviewing the challenge.


## About the stock
The factory stock is different from the store stock. Every 30 minutes the guard robot beside of watching our defects will transfer the stock from factory stock to store stock in order to be sold (it will transfer only the non-defective cars stock). 


## Robot buyer, order model and store stock

Once the cars are ready to be sold, the cars are taken to another place, far from the factory and the factory warehouse. Here is where the Robot buyer comes on the scene, this process will buy a random number of cars always < 10 units each X amount of time (it can buy 10 cars/min top). When the robot buyer purchases a car an order will be placed. The robot only can buy 1 car at a time, so each order will have only 1 item. The stock will be decreased when the order is placed. Well, there’s a detail here, the stock we decreased is the store stock. If when the robot buyer wants to purchase a car model and there’s no stock, it won’t be able to buy it and that event will have to be logged.


## The problem.
You know the robot buyer knows the car models he is able to buy, we want to optimize the sales, as we have lag between the factory stock and the store stock, it may happen that we don’t have stock at the store stock but we actually have brand new cars ready to be sold in the factory stock. How can we optimize the stock management? (sadly we can’t centralize the stock)

## The other problem.
After you finish to code this challenge, imagine you'll receive a text message from the robot buyer, it says that several orders need to be changed because they want to change the cars models.
First, you receive an order_id and the car model, but an hour later you'll start to receive several changes of this kind request per hour.
What is your proposal to solve this need? Also please implement the solution.

## A plus.
Making the robot execs happy would be a good idea, it would be great to pull the daily revenue, how many cars we sell, average order value on a daily basis. 

## Notes and considerations
+ This is a pretty open challenge, there are several ways to solve it, the idea behind this you show us how you think, how you solve the problems. So express yourself, apply the good practices and techniques you learned but always with the right balance, keep it simple.
+ Tests are important, we use Rspec, but mini test or another framework will do the job.
+ Don't hesitate to ask, we are here to help.
+ We use Rails and Postgres. The Postgres DB is mandatory for this challenge, but as this challenge doesn't have front-end, if you feel comfortable using plain ruby it's fine (if you decide to use a framework the only allowed is Rails). 

---

## Robot World ( The Challenge )

## Dependencies

**Docker**  
Running this project under a docker environment allows new users ( or reviewers ) to run the application avoiding versioning issues.

**Dependencies installed inside docker container**
+ Ruby
+ Postgres
+ Rails
+ Adminer

**Extra Gems**
+ Whenever  
  This gem makes chron jobs easier to create and run. Please visit its [repositry](https://github.com/javan/whenever)

## Start Up

+ To run this app for the first time you need to run  
`$ docker-compose build`

+ After the build is completed run  
`$ docker-compose up`

+ To stop the app  
`$ docker-compose stop`

+ To run it again  
`$ docker-compose up`

## Class diagram
![alt text](https://github.com/gacierno/robot-world/blob/Fixes-and-updates/UML.png "Class Diagram")  

+ Red represents **Initial Structure**
+ Blue represents classes and methods added to solve **The Problem**
+ Green represents classes and methods added to solve **The Other Problem**
+ Yellow represents classes and methods added to solve **A Plus**
+ Purple represents classes and methods added to solve **An Extra**

## Tasks

Inside the aplication there are 6 tasks created to work as robots

+ **Robot Builder**  
   To build cars on demand use  
   `$ rake robot:builder:start` inside the container or  
   `$ docker-compose run web rake robot:builder:start` from your terminal 
   To clean up on demand
   `$ rake robot:builder:cleanup` inside the container or  
   `$ docker-compose run web rake robot:builder:cleanup` from your terminal

+ **Robot Guard**    
   To inspect cars run  
   `$ rake bobot:guard:inspect_cars` or `$ docker-compose run web rake robot:guard:inspect_cars`  
   To move the cars run  
   `$ rake bobot:guard:move_cars` or `$ docker-compose run web rake robot:guard:move_cars` 

+ **Robot Buyer**  
   To buy cars on demand use  
   `$ rake robot:buyer:buy_cars` inside the container or  
   `$ docker-compose run web rake robot:buyer:buy_cars` from your terminal  
   To change a random car user  
   `$ rake robot:buyer:ask_for_a_car_change` inside the container or  
   `$ docker-compose run web rake robot:buyer:ask_for_a_car_change` from your terminal

+ **Robot Car Delivery**  
   To deliver reserved cars that are on the store 
   `$ rake robot:car_delivery` inside the container or  
   `$ docker-compose run web rake robot:car_delivery` from your terminal

+ **Robot Repairer**  
   To repair rejected cars that are on the warehose
   `$ rake robot:repairer` inside the container or  
   `$ docker-compose run web rake robot:repairer` from your terminal


## The Problem (solved) 
To solve the problem generated by the lag between the factory stock and the store stock a Reservation system will be implemented so the Robot Buyer will be able to "reserve" a car that is on the factory stock.
When the Robot Buyer find the car it is looking for in the factory stock a Reservation will be generated.
Then whe the reserved car gets the store, the store will "send" the car to an order and set it as sold.
+ When the Robot Buyer "wants" to buy a model that it isn't on store can look for it on the factory stock
   If this car exists and it isn't already reserved the system can create a reservation.
+ After reservation is created when the Robot Guard move the cars from factory stock to the store a new Robot called Car Delivery will look for reservations.
   If the car on the reservation is at the store the Robot will "deliver" the car and create an order.
+ The reservation will be set as delivered so Delivery Robot don't check on already delivered reservations

## The other problem (solved)
To manage product changes it's important to set the steps and rules for this procedure.

+ When the Robot buyer needs a product change. System will create a "change order" to revert the order data ( car and prices so the Robot Buyer has the car value in its favor and the company has the car available for sale ).
+ At the moment that the Robot buyer request the change there will be 3 posibilities:
   1. **The new car is available on the store**  
      Then the chage will be done instantly. Creating the change order and the new order with the new car. 
   2. **The new car isn't on store but it is on factory stock**  
      Then system will create the change order and a reservation for the new car. The order will be created when the car arrives to the store.
   3. **The new car isn't available in the store or factory**  
      Unfortunately the change won't be done

## A plus (solved)
Company will need a robot that at the end of the day give them some metrics to understand where the company is going.  
+ To get the daily revenue Robot will calculate the difference, ( in money ) between orders ( cars delivered ) and change orders ( canceled orders ). 
+ To get how many cars are sold Robot will calculate the difference, ( in cars ) between orders ( cars delivered ) and change orders ( canceled orders ).
+ To get the average will calculate the income divided by que cars ( both already calculated on 1 and 2 )  

## RSpec
Rspect has been implemented on the proyect to test all models that extend ApplicationRecord.  
To run these tests use (inside the container):
+ `$ rspec spec/models/model_spec.rb` to test car models
+ `$ rspec spec/models/car_spec.rb` to test cars
+ `$ rspec spec/models/car_part_spec.rb` to test car parts
+ `$ rspec spec/models/order_spec.rb` to test orders
+ `$ rspec spec/models/reservation_spec.rb` to test reservations
+ `$ rspec spec/models/change_order_spec.rb` to test change orders
To run these tests on terminal use:
+ `$ docker-compose run web rspec spec/models/model_spec.rb` to test car models
+ `$ docker-compose run web rspec spec/models/car_spec.rb` to test cars
+ `$ docker-compose run web rspec spec/models/car_part_spec.rb` to test car parts
+ `$ docker-compose run web rspec spec/models/order_spec.rb` to test orders
+ `$ docker-compose run web rspec spec/models/reservation_spec.rb` to test reservations
+ `$ docker-compose run web rspec spec/models/change_order_spec.rb` to test change orders

## An Extra (Robot Repairer)
While time goes on, a lot of rejected cars are stored on warehouse. It reperesents a lot of lost money for the company.  
As a solution a new Robot will work on the compamy, the Robot Repairer.
This Robot will look for rejected cars on warehouse, find defects, repair and set them as uninspected so Robot Guard can make its inspection.  
+ Frecuency: Once a day






