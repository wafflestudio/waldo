class Phrase < ActiveRecord::Base
  validates :input, :presence => true
  validates :output, :presence => true
end
