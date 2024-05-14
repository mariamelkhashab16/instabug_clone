class Chat < ApplicationRecord
  belongs_to :application
  attr_accessor :num

end
