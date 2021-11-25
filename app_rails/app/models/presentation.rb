class Presentation
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :professional, :date, :type

  validates :date, :type, presence: true
end