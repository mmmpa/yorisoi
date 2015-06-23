# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sample do
    factory :valid_sample do
      sequence(:text) { |n| "text#{n}" }
      sequence(:password) { |n| "password#{n}" }
      sequence(:textarea) { |n| "textarea#{n}" }
      select {Const::SELECT.sample}
      radio {Const::RADIO.sample}
      checkbox {[Const::CHECKBOX.sample]}
    end
  end
end
