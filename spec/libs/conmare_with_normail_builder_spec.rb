require 'rails_helper'

class TestHelper < ActionView::Base;
end

RSpec.describe Yorisoi::Builder do
  before :each do
    @sample = build(:sample)
    @df = ActionView::Helpers::FormBuilder.new(:sample, @sample, TestHelper.new, {})
    @f = Yorisoi::Builder.new(:sample, @sample, TestHelper.new, {})
  end

  let(:for_select) do
    (1..4).to_a.zip(('a'..'d').to_a)
  end

  context 'wrapping' do
    context 'wrapped' do
      context 'yet valid or no error' do
        # check_box(object_name, method, options = {}, checked_value = "1", unchecked_value = "0")
        it 'include normal check_box' do
          args = [:text, {class: :test}, nil, nil]
          expect(@f.check_box(*args)).to have_tag('div.normal-field', content: @df.check_box(*args))
        end

        # radio_button(method, tag_value, options = {})
        it 'include normal radio button' do
          args = [:text, nil, class: :test]
          expect(@f.radio_button(*args)).to have_tag('div.normal-field', content: @df.radio_button(*args))
        end

        it 'include normal select' do
          args = [:text, for_select, class: :test]
          expect(@f.select(*args)).to have_tag('div.normal-field', content: @df.select(*args))
        end
      end

      context 'when has error' do
        context 'check_box' do
          before :each do
            @sample.valid?
            @args = [:text, {class: :test}, nil, nil]
            @html = @f.check_box(*@args)
          end

          it 'has error wrapper' do
            expect(@html).to have_tag('div.field_with_errors', content: @df.check_box(*@args))
          end

          it 'has error message' do
            expect(@html).to have_tag('ul.errors.text li.error.text')
          end
        end

        context 'radio button' do
          before :each do
            @sample.valid?
            @args = [:text, nil, class: :test]
            @html = @f.radio_button(*@args)
          end

          it 'has error wrapper' do
            expect(@html).to have_tag('div.field_with_errors', content: @df.radio_button(*@args))
          end

          it 'has error message' do
            expect(@html).to have_tag('ul.errors.text li.error.text')
          end
        end

        context 'select' do
          before :each do
            @sample.valid?
            @args = [:text, for_select, class: :test]
            @html = @f.select(*@args)
          end

          it 'has error wrapper' do
            expect(@html).to have_tag('div.field_with_errors', content: @df.select(*@args))
          end

          it 'has error message' do
            expect(@html).to have_tag('ul.errors.text li.error.text')
          end
        end
      end

      context 'when has error with no error option' do
        context 'check_box' do
          before :each do
            @sample.valid?
            @args = [:text, {class: :test, no_errors: true}, nil, nil]
            @html = @f.check_box(*@args)
          end

          it 'has error wrapper' do
            expect(@html).to have_tag('div.field_with_errors', content: @df.check_box(*@args))
          end

          it 'has no error message' do
            expect(@html).not_to have_tag('ul.errors.text li.error.text')
          end
        end

        # radio_button(method, tag_value, options = {})
        context 'radio button' do
          before :each do
            @sample.valid?
            @args = [:text, nil, class: :test, no_errors: true]
            @html = @f.radio_button(*@args)
          end

          it 'has error wrapper' do
            expect(@html).to have_tag('div.field_with_errors', content: @df.radio_button(*@args))
          end

          it 'has no error message' do
            expect(@html).not_to have_tag('ul.errors.text li.error.text')
          end
        end

        context 'select' do
          before :each do
            @sample.valid?
            @args = [:text, for_select, class: :test, no_errors: true]
            @html = @f.select(*@args)
          end

          it 'has error wrapper' do
            expect(@html).to have_tag('div.field_with_errors', content: @df.select(*@args))
          end

          it 'has no error message' do
            expect(@html).not_to have_tag('ul.errors.text li.error.text')
          end
        end
      end

      [:text_field, :password_field, :text_area,
        :color_field, :search_field, :file_field,
        :telephone_field, :phone_field, :url_field, :email_field,
        :date_field, :time_field, :datetime_field, :datetime_local_field, :month_field, :week_field,
        :number_field, :range_field].each do |selector|

        context "raw #{selector}" do
          before :each do
            @args = [:text, class: :test]
            @html = @f.send(selector, *@args)
          end

          it 'has wrapper' do
            expect(@html).to have_tag('div.normal-field', content: @df.send(selector, *@args))
          end

          it 'has no error message' do
            expect(@html).not_to have_tag('ul.errors.text li.error.text')
          end
        end

        context "on error #{selector}" do
          before :each do
            @sample.valid?
            @args = [:text, class: :test]
            @html = @f.send(selector, *@args)
          end

          it 'has error wrapper' do
            expect(@html).to have_tag('div.field_with_errors', content: @df.send(selector, *@args))
          end

          it 'has error message' do
            expect(@html).to have_tag('ul.errors.text li.error.text')
          end
        end

        context "with no error option, #{selector}" do
          before :each do
            @sample.valid?
            @args = [:text, class: :test, no_errors: true]
            @html = @f.send(selector, *@args)
          end

          it 'has error wrapper' do
            expect(@html).to have_tag('div.field_with_errors', content: @df.send(selector, *@args))
          end

          it 'has no error message' do
            expect(@html).not_to have_tag('ul.errors.text li.error.text')
          end
        end
      end
    end

    context 'wrapping and no error' do
      context "raw label" do
        before :each do
          @args = [:text, class: :test]
          @html = @f.send(:label, *@args)
        end

        it 'has wrapper' do
          expect(@html).to have_tag('div.normal-field', content: @df.send(:label, *@args))
        end

        it 'has no error message' do
          expect(@html).not_to have_tag('ul.errors.text li.error.text')
        end
      end

      context "on error label" do
        before :each do
          @sample.valid?
          @args = [:text, class: :test]
          @html = @f.send(:label, *@args)
        end

        it 'has error wrapper' do
          expect(@html).to have_tag('div.field_with_errors', content: @df.send(:label, *@args))
        end

        it 'has no error message' do
          expect(@html).not_to have_tag('ul.errors.text li.error.text')
        end
      end
    end

    context 'no wrapping no error' do
      context 'raw hidden_field' do
        it 'equal plane' do
          @args = [:text, class: :test]
          expect(@f.hidden_field *@args).to eq(@df.hidden_field *@args)
        end
      end

      context 'on error hidden_field' do
        it 'equal plane' do
          @sample.valid?
          @args = [:text, class: :test]
          expect(@f.hidden_field *@args).to eq(@df.hidden_field *@args)
        end
      end
    end
  end
end