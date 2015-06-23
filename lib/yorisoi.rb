module Yorisoi
  module Arralizer
    refine Object do
      def arralize
        return self if self.is_a?(Array)

        self.is_a?(NilClass) ? [] : [self]
      end
    end
  end


  module Flipper
    # https://gist.github.com/yuroyoro/3293046
    refine Proc do
      def flip
        f = self.to_proc
        case __arity(f)
          when 0, 1 then
            f
          when 2 then
            lambda { |x, y| self[y, x] }
          else
            lambda { |x, y, *arg| self[y, x, *arg] }
        end
      end


      private
      def __arity(f)
        (f.arity >= 0) ? f.arity : -(f.arity + 1)
      end
    end
  end


  class Builder < ::ActionView::Helpers::FormBuilder
    include ActionView::Helpers::TagHelper
    using Arralizer
    using Flipper

    attr_accessor :wrapper, :invalid_wrapper, :errors_wrapper, :error_wrapper


    def initialize(object_name, object, template, options)
      self.default_tag = options[:builder_tag] || {}
      super
    end


    (field_helpers - [:check_box, :radio_button, :fields_for, :hidden_field, :label]).each do |selector|
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
        def #{selector}(attribute, options = {})
          wrap_field(attribute, options) do
            super
          end
        end
      RUBY_EVAL
    end


    def check_box(attribute, options = {}, label_and_value = %w(1 1), unchecked_value = '0')
      wrap_field(attribute, options) do
        if label_and_value.is_a?(Array)
          @template.check_box(@object_name, attribute,
              objectify_options(options.merge(around: around_proc(label_and_value.first))),
              label_and_value.last, unchecked_value)
        else
          super
        end
      end
    end


    def check_boxes(attribute, options = {}, labels_and_values = [['', '1']],
        children_wrapper: check_box_wrapper, child_wrapper: check_box_child_wrapper)
      wrap_field(attribute, options.merge(no_wrap: true)) do
        children_wrapper.(labels_and_values.map do |label_and_value|
          child_wrapper.(check_box(attribute, options.merge(multiple: true, no_errors: true), label_and_value, nil), attribute)
        end.join.html_safe, attribute)
      end
    end


    def default_tag=(tags)
      self.wrapper = tags[:wrapper] || default_wrapper
      self.invalid_wrapper = tags[:invalid_wrapper] || default_invalid_wrapper
      self.errors_wrapper = tags[:errors_wrapper] || default_errors_wrapper
      self.error_wrapper = (tags[:error_wrapper] || default_error_wrapper).flip.curry
    end


    def label(attribute, options = {})
      wrap_field(attribute, options.merge(no_errors: true)) { super }
    end


    def pick_error(attribute)
      return nil if @object.nil? || !(messages = @object.errors.messages[attribute]).present?

      errors_wrapper.(messages.map(&error_wrapper.(attribute)).join.html_safe, attribute)
    end


    def radio_button(attribute, label_and_value, options = {})
      wrap_field(attribute, options) do
        if label_and_value.is_a?(Array)
          @template.radio_button(@object_name, attribute, label_and_value.last,
              objectify_options(options.merge(around: around_proc(label_and_value.first))))
        else
          super
        end
      end
    end


    def radio_buttons(attribute, options = {}, labels_and_values = [['', '1']],
        children_wrapper: radio_button_wrapper, child_wrapper: radio_button_child_wrapper)
      wrap_field(attribute, options.merge(no_wrap: true)) do
        children_wrapper.(labels_and_values.map do |label_and_value|
          child_wrapper.(radio_button(attribute, label_and_value, options.merge(no_errors: true)), attribute)
        end.join.html_safe, attribute)
      end
    end


    def select(attribute, choices = nil, options = {}, html_options = {}, &block)
      wrap_field(attribute, options) { super }
    end


    def wrap_field(attribute, options={})
      no_errors = options.delete(:no_errors)
      no_wrap = options.delete(:no_wrap)

      if (error_html = pick_error(attribute)).present?
        no_errors ? yield : yield + error_html
      else
        no_wrap ? yield : wrapper.(yield, attribute)
      end.html_safe
    end


    private
    def around_proc(label_text)
      ->(tag) {
        %{<label><span class="label">#{label_text}</span><span class="input">#{tag}</span></label>}.html_safe
      }
    end


    def check_box_wrapper
      ->(content, attribute) { content_tag(:ul, content, class: %w(check-boxes).push(attribute)) }
    end


    def check_box_child_wrapper
      ->(content, attribute) { content_tag(:li, content, class: %w(check-boxes-child).push(attribute)) }
    end


    def default_error_wrapper
      ->(content, attribute) { content_tag(:li, content, class: %w(error).push(attribute)) }
    end


    def default_errors_wrapper
      ->(content, attribute) { content_tag(:ul, content, class: %w(errors).push(attribute)) }
    end


    def default_invalid_wrapper
      ->(content, attribute) { content_tag(:div, content, class: %w(invalid-field).push(attribute)) }
    end


    def default_wrapper
      ->(content, attribute) { content_tag(:div, content, class: %w(normal-field).push(attribute)) }
    end


    def radio_button_wrapper
      ->(content, attribute) { content_tag(:ul, content, class: %w(radio-buttons).push(attribute)) }
    end


    def radio_button_child_wrapper
      ->(content, attribute) { content_tag(:li, content, class: %w(radio-buttons-child).push(attribute)) }
    end
  end


  module ::ActionView
    module Helpers
      module ActiveModelInstanceTag
        def content_tag(tag_name, single_or_multiple_records, prefix = nil, options = nil, &block)
          supered = if (around = options.try(:[], 'around')).present?
                      options.delete('around')
                      around.call(super)
                    else
                      super
                    end

          error_wrapping(supered)
        end


        def tag(type, options, *)
          supered = if (around = options.try(:[], 'around')).present?
                      options.delete('around')
                      around.call(super)
                    else
                      super
                    end

          tag_generate_errors?(options) ? error_wrapping(supered) : supered
        end
      end
    end
  end
end
