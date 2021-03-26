#!/usr/bin/env ruby
require 'rest_client'
require 'json'
require_relative "robot_base"

class RobotBuilder < RobotBase

  # constructor
  def initialize; end

  def doAssembleBasics(car)
    categories = ["BASIC_ASSEMBLY", "CHASSIS", "WHEEL", "ENGINE"]
    components = car['components']
    basics = components.select { |component| categories.include?(component['category']) }
    assemblies = []
    basics.each do |b|
      assemblies.push ({
        'name' => b['name'],
        'component_id' => b['id'],
        'component_serial' => b['serial']
      })
    end
    car_status = { 'stage' => 'BASIC_LINE', 'assemblies' => assemblies }

    begin
      uri = getUrl(format('factory/car/%s', car['serial']))
      RestClient.put(uri, car_status.to_json, content_type: :json)
    rescue RestClient::ExceptionWithResponse => e
      puts "Can't inform Basic Assembly to RoboBrain #{e}"
    end
    puts "Basics done for Car: #{car['serial']}"
  end

  def doAssembleElectronics(car)
    categories = ["ELECTRONIC_ASSEMBLY", "LASER", "COMPUTER"]
    components = car['components']
    basics = components.select { |component| categories.include?(component['category']) }
    assemblies = []
    basics.each do |b|
      assemblies.push ({ 'name' => b['name'],
                         'component_id' => b['id'],
                         'component_serial' => b['serial']
      })
    end
    car_status = { 'stage' => 'ELECTRONIC_LINE', 'assemblies' => assemblies }

    begin
      uri = getUrl(format('factory/car/%s', car['serial']))
      RestClient.put(uri, car_status.to_json, content_type: :json)
    rescue RestClient::ExceptionWithResponse => e
      puts "Can't inform ELECTRONIC Assembly to RoboBrain #{e}"
    end
    puts "Electronics done for Car: #{car['serial']}"
  end

  def doAssembleFinal(car)
    categories = ["PAINT", "FINAL_ASSEMBLY", "SEAT"]
    components = car['components']
    basics = components.select { |component| categories.include?(component['category']) }
    assemblies = []
    basics.each do |b|
      assemblies.push ({ 'name' => b['name'],
                         'component_id' => b['id'],
                         'component_serial' => b['serial']
      })
    end
    car_status = { 'stage' => 'FINAL_LINE', 'assemblies' => assemblies }

    begin
      uri = getUrl(format('factory/car/%s', car['serial']))
      RestClient.put(
        uri,
        car_status.to_json,
        content_type: :json
      )
    rescue RestClient::ExceptionWithResponse => e
      puts "Can't inform FINAL Assembly to RoboBrain #{e}"
    end
    puts "Final stuff done for Car: #{car['serial']}"
  end

  #
  #  Let roboBrain knows that we're starting to build a car
  #
  def getPayLoadStatusStage(item, status, stage)
    return {
      serial_num: item['serial'],
      model_id: item['id'],
      status: status,
      stage: stage
    }
  end

  def startBuild(item)
    begin
      RestClient.post(
        getUrl('factory/car'),
        getPayLoadStatusStage(item, "BUILDING", "START").to_json,
        content_type: :json
      )

      doAssembleBasics item
      doAssembleElectronics item
      doAssembleFinal item

      #uri = @@url % ['factory/car/%s' % item['serial']]
      results = RestClient.put(
        getUrl(format('factory/car/%s', item['serial'])),
        getPayLoadStatusStage(item, "READY_TO_INSPECT", "BUILD_END").to_json,
        content_type: :json
      )

      puts results

    rescue RestClient::ExceptionWithResponse => e
      puts "Can't connect to RoboBrain #{e}"
    end
    puts "Done with this round... :)"
  end

  def getBom
    begin
      response = RestClient.get(getUrl('factory/bom'))
      bom = JSON.parse(response)

      bom['items'].each do |item|
        startBuild item
      end

    rescue RestClient::ExceptionWithResponse => e
      puts "Can't connect to RoboBrain #{e}"

    end
  end
end

builder = RobotBuilder.new

1.times { builder.getBom }
#builder.getBom

