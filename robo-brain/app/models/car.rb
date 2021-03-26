class Car < ApplicationRecord
  belongs_to :model
  belongs_to :warehouse
  has_many :assembly, foreign_key: :car_serial_num
  has_one :purchase, foreign_key: :car_serial_num

  def isComplete()
    return status == 'READY'
  end

  def getComputer()

    return CarComputer.new Assembly.includes(:component).where(car_serial_num: self.serial_num)
    #Why this doesn't work?
    #return CarComputer.new :assembly
  end
end

class CarComputer
  @assemblies

  def initialize(assemblies)
    @assemblies = assemblies
  end

  def getDiagnostics()

    computerName = ''
    howMany = @assemblies.length * 2

    fail = rand(1..howMany)

    @assemblies.each do |part|

      if part.component.category.eql? 'COMPUTER'
        computerName = part.component.name
      end
    end

    diagnostic = 'FAIL'

    if @assemblies[fail].blank?
      diagnostic = 'OK'
      failedComponent = 'none'
    else
      failedComponent = {
        'name' => @assemblies[fail].name,
        'type' => @assemblies[fail].component.category,
        'assemblyId' => @assemblies[fail].id,
        'serial' => @assemblies[fail].component_serial_num
      }
    end

    return { 'computerName' => computerName,
             'diagnostic' => diagnostic,
             'failedComponent' => failedComponent
    }
  end
end
