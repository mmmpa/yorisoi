class Sample < ActiveRecord::Base
  serialize :checkbox

  validates :text, :password, :textarea, :select, :radio, :checkbox,
      presence: true
  validates :text, :password, :textarea, :select, :radio,
      format: {with: /\A[a-z0-9]+\Z/i},
      length: {maximum: 20}
  validates :select, inclusion: {in: Const::SELECT}
  #validates :checkbox, inclusion: {in: Const::CHECKBOX}
  validates :radio, inclusion: {in: Const::RADIO}
end
