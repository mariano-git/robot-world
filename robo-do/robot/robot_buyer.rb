#!/usr/bin/env ruby

require 'rest_client'
require 'json'
require_relative "robot_base"

class RobotBuyer < RobotBase

  # constructor
  def initialize
    @success = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    @failed = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  end

  def getRandom
    # models goes from 1 to 11
    return rand(1..11)
  end

  def addTo(currentArray, response)
    currentArray[response['modelId']] = currentArray[response['modelId']] + 1
  end

  def createPayload(operation, modelId)
    return {
      'type' => operation,
      'modelId' => modelId,
      'buyer' => "RoboBuyer-#{getRandom}"
    }
  end

  def sendRequest(payLoad)
    begin
      results = RestClient.post(
        getUrl('pos'),
        payLoad.to_json, content_type: :json
      )
      addTo(@success, JSON.parse(results))
      puts results
    rescue RestClient::ExceptionWithResponse => e
      puts "Opss RoboBrain says #{e}"
      puts e.response
      addTo(@failed, JSON.parse(e.response))

    end
  end

  def retryPurchase
    retries = [true, true, true, true, true, true, true, true, true, true, true, true]
    counter = 10
    for index in (1...12)
      try = @failed[index] + @success[index]
      counter = counter - @success[index]
      if try > 0
        retries[index] = false
      end
    end
    puts "quedan #{counter}"
    puts "retries #{retries}"
    for index in (1...12)
      if (retries[index] && (counter > 0))
        sendRequest(createPayload('PURCHASE', index))
        counter = counter - 1
      end
    end
    puts("failed #{@failed}")
    puts("success #{@success}")
  end

  def doPurchase
    # Once the cars are ready to be sold, the cars are taken to another place,
    # far from the factory and the factory warehouse.
    # Here is where the Robot buyer comes on the scene,
    # this process will buy a random number of cars always < 10 units each X amount of time (it can buy 10 cars/min top).
    # When the robot buyer purchases a car an order will be placed.
    # The robot only can buy 1 car at a time, so each order will have only 1 item.
    # The stock will be decreased when the order is placed.

    # Well, there’s a detail here, the stock we decreased is the store stock.
    # If when the robot buyer wants to purchase a car model and there’s no stock,
    # it won’t be able to buy it and that event will have to be logged.

    for index in (1...11)
      sendRequest(createPayload('PURCHASE', index))
    end
    puts("failed #{@failed}")
    puts("success #{@success}")

    retryPurchase
  end

  def doRequisition
    # code here
    sendRequest(createPayload('REQUISITION', getRandom))
  end
end

buyer = RobotBuyer.new
#(it can buy 10 cars/min top).
#n = rand(1..10)
#n.times { }
buyer.doPurchase

