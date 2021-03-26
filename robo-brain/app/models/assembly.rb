class Assembly < ApplicationRecord
  belongs_to :car, foreign_key: :serial_num
  belongs_to :component
end
