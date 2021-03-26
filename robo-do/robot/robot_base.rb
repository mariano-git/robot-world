# frozen_string_literal: true
class RobotBase
  def initialize; end

  def getUrl(operation)
    base = 'http://%s:%d/api/v1/%s'
    url = format(base, ENV['ROBOBRAIN_HOST'], ENV['ROBOBRAIN_PORT'], operation)
    puts url
    return url
  end
end
