module ActiveModel
  module Validations
    def has_error_on(attribute, error)
      return false unless self.respond_to?(:valid?)
      self.valid?
      self.errors.messages[attribute].try(:include?, error)
    end
  end


  class Errors
    def generate_message(attribute, type = :invalid, options = {})
      message = type.to_sym
      message_table[message] || message
    end


    def message_table
      {
        present: :absence,
        accepted: :acceptance,
        invalid: :format,
        not_a_number: :numericality,
        not_an_integer: :numericality,
        blank: :presence,
        wrong_length: :length
      }
    end
  end
end
