#!/usr/bin/env ruby

require 'rest_client'
require 'json'
require_relative "robot_base"
require 'text-table'

class RobotGuard < RobotBase
  # the URL

  @@slackUrl = "https://hooks.slack.com/services/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" #mia
  #@@slackUrl = "https://hooks.slack.com/services/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"
  @head = ['Car Id', 'Model', 'Computer Name', 'Failed Component', 'Assembly Id']
  @rows = []

  def doRunDiagnostic(item)

    uri = format('qa/car/%s', item['serial'])
    url = getUrl(uri)
    begin
      response = RestClient.get(url)
      #puts response
      diagnostic = JSON.parse(response)

      if diagnostic['status']['diagnostic'].eql? 'FAIL'
        row = []
        row.push(diagnostic['id'])
           .push(diagnostic['modelName'])
           .push(diagnostic['status']['computerName'])
           .push(diagnostic['status']['failedComponent']['name'])
           .push(diagnostic['status']['failedComponent']['type'])
           .push(diagnostic['status']['failedComponent']['assemblyId'])

        @rows.push(row)
      end
    rescue RestClient::ExceptionWithResponse => e
      puts "Can't connect to RoboBrain #{e}"
    end
  end

  def sendSlackMessage(table)
    runTime = Time.now.strftime("%d/%m/%Y %H:%M")
    begin
      RestClient.post(
        @@slackUrl,
        {
          payload: {
            #channel: "#{channel}",
            text: ":robot_face: Hello from Mariano's Robot Guard ",
            username: "Robot Guard",
            icon_emoji: ":robot_face:",
            "attachments": [
              { "text": "Here's the list of failed checks for running: #{runTime}" },
              { "text": table }
            ]
          }.to_json
        }
      )
    rescue RestClient::ExceptionWithResponse => e
      puts "Can't connect to Slack #{e}"
    end
  end

  def getSerialsToInspect
    @rows = []
    @head = ['Car Serial', 'Model', 'Computer Name', 'Failed Component', 'Type', 'Component Serial']
    begin

      uri = format(
        'inventory/%s?status=%s&stage=%s',
        'FACTORY', 'READY_TO_INSPECT', 'BUILD_END'
      )
      url = getUrl(uri)
      puts url
      response = RestClient.get(url)
      inventory = JSON.parse(response)

      inventory.each do |item|
        doRunDiagnostic item
      end
      table = Text::Table.new(:head => @head, :rows => @rows)
      sendSlackMessage table
      puts table.to_s
    rescue RestClient::ExceptionWithResponse => e
      puts e
    end
  end
end

guard = RobotGuard.new
guard.getSerialsToInspect
