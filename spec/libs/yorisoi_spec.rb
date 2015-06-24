require 'rails_helper'

class TestHelper < ActionView::Base;
end

RSpec.describe Yorisoi::Builder do
  before :each do
    @sample = build(:sample)
    @df = ActionView::Helpers::FormBuilder.new(:sample, @sample, TestHelper.new, {})
    @f = Yorisoi::Builder.new(:sample, @sample, TestHelper.new, {})
  end

  context 'change use tag' do
    before :each do
      @sample.valid?
    end

    it 'change error child' do
      changed = Yorisoi::Builder.new(:sample, @sample, TestHelper.new, {
              builder_tag: {
                  errors_wrapper: ->(error_children, attribute) { %{<div class="error-messages #{attribute}">#{error_children}</div>}.html_safe },
                  error_wrapper: ->(error, attribute) { %{<p class="error-message #{attribute}">#{error}</p>}.html_safe }
              }})
      expect(changed.text_field(:text)).to have_tag('div.error-messages.text p.error-message.text')
    end
  end


  context 'default use' do
    context 'text_field' do
      it 'not validated no error' do
        expect(@f.text_field(:text)).not_to have_tag('ul.errors.text')
      end

      it 'validated get error' do
        @sample.valid?
        expect(@f.text_field(:text)).to have_tag('ul.errors.text')
      end
    end
  end

  context 'remnant errors' do
    before :each do
      @sample.valid?
      @count = @sample.errors.count
      @fr = Yorisoi::Builder.new(:sample, @sample, TestHelper.new, {})
    end

    it do
      @fr.write_error(:text)

      p @fr.remnant
      expect(@fr.remnant).to have_tag('li.error', count: 11)
    end

    it do
      @fr.text_field(:text)

      expect(@fr.remnant).to have_tag('li.error', count: 11)
    end
  end

  context 'with label expanded' do
    let(:label_and_value) do
      %w(label_name value_name)
    end

    context 'no error' do
      context 'checkbox' do
        before :each do
          @html = @f.check_box(:text, {}, label_and_value, nil)
        end

        it 'wrapped' do
          expect(@html).to have_tag('div.normal-field')
        end

        it 'has label text' do
          expect(@html).to include(label_and_value.last)
        end

        it 'has value' do
          expect(@html).to have_tag('input[type="checkbox"]', value: label_and_value.first)
        end
      end

      context 'radio button' do
        before :each do
          @html = @f.radio_button(:text, label_and_value)
        end

        it 'wrapped' do
          expect(@html).to have_tag('div.normal-field')
        end

        it 'has label text' do
          expect(@html).to include(label_and_value.last)
        end

        it 'has value' do
          expect(@html).to have_tag('input[type="radio"]', value: label_and_value.first)
        end
      end
    end

    context 'has error' do
      context 'checkbox' do
        before :each do
          @sample.valid?
          @html = @f.check_box(:text, {}, label_and_value, nil)
        end

        it 'wrapped' do
          expect(@html).to have_tag('div.field_with_errors')
        end

        it 'has label text' do
          expect(@html).to include(label_and_value.last)
        end

        it 'has value' do
          expect(@html).to have_tag('input[type="checkbox"]', value: label_and_value.first)
        end
      end

      context 'radio button' do
        before :each do
          @sample.valid?
          @html = @f.radio_button(:text, label_and_value)
        end

        it 'wrapped' do
          expect(@html).to have_tag('div.field_with_errors')
        end

        it 'has label text' do
          expect(@html).to include(label_and_value.last)
        end

        it 'has value' do
          expect(@html).to have_tag('input[type="radio"]', value: label_and_value.first)
        end
      end
    end

  end

  context 'multi button expanded' do
    let(:labels_and_values) do
      (1..10).to_a.collect do |n|
        ["label name #{n}", "value name #{n}"]
      end
    end

    context 'no error' do
      context 'checkboxes' do
        before :each do
          @html = @f.check_boxes(:text, {}, labels_and_values)
        end

        it 'wrapped' do
          expect(@html).to have_tag('div.normal-field', count: 10)
        end

        it 'has label text' do
          labels_and_values.each do |label_and_value|
            expect(@html).to include(label_and_value.last)
          end
        end

        it 'has value' do
          labels_and_values.each do |label_and_value|
            expect(@html).to have_tag('input[type="checkbox"]', value: label_and_value.first)
          end
        end
      end

      context 'radio_buttons' do
        before :each do
          @html = @f.radio_buttons(:text, {}, labels_and_values)
        end

        it 'wrapped' do
          expect(@html).to have_tag('div.normal-field', count: 10)
        end

        it 'has label text' do
          labels_and_values.each do |label_and_value|
            expect(@html).to include(label_and_value.last)
          end
        end

        it 'has value' do
          labels_and_values.each do |label_and_value|
            expect(@html).to have_tag('input[type="radio"]', value: label_and_value.first)
          end
        end
      end
    end

    context 'has error' do
      context 'checkboxes' do
        before :each do
          @sample.valid?
          @html = @f.check_boxes(:text, {}, labels_and_values)
        end

        it 'wrapped' do
          expect(@html).to have_tag('div.field_with_errors', count: 10)
        end

        it 'has 1 error message' do
          expect(@html).to have_tag('ul.errors.text', count: 1)
        end

        it 'has label text' do
          labels_and_values.each do |label_and_value|
            expect(@html).to include(label_and_value.last)
          end
        end

        it 'has value' do
          labels_and_values.each do |label_and_value|
            expect(@html).to have_tag('input[type="checkbox"]', value: label_and_value.first)
          end
        end
      end

      context 'radio_buttons' do
        before :each do
          @sample.valid?
          @html = @f.radio_buttons(:text, {}, labels_and_values)
        end

        it 'wrapped' do
          @html
          expect(@html).to have_tag('div.field_with_errors', count: 10)
        end

        it 'has 1 error message' do
          expect(@html).to have_tag('ul.errors.text', count: 1)
        end

        it 'has label text' do
          labels_and_values.each do |label_and_value|
            expect(@html).to include(label_and_value.last)
          end
        end

        it 'has value' do
          labels_and_values.each do |label_and_value|
            expect(@html).to have_tag('input[type="radio"]', value: label_and_value.first)
          end
        end
      end
    end
  end
end