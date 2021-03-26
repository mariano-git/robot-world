class Purchase < ApplicationRecord
  belongs_to :requisition
  belongs_to :car, foreign_key: :car_sn


end
