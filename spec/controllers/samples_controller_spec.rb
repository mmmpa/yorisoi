require 'rails_helper'

RSpec.describe SamplesController, :type => :controller do
  render_views

  describe "GET new" do
    it "no error message" do
      get :new
      expect(response.body).not_to include('.error-message')
    end
  end

  describe "POST create" do
    it 'valid params NOT render error message' do
      post :create, sample: attributes_for(:valid_sample)
      expect(response.body).not_to have_tag('ul.errors.text')
      expect(response.body).not_to have_tag('ul.errors.password')
      expect(response.body).not_to have_tag('ul.errors.textarea')
      expect(response.body).not_to have_tag('ul.errors.select')
      expect(response.body).not_to have_tag('ul.errors.radio')
      expect(response.body).not_to have_tag('ul.errors.checkbox')
    end

    context 'invalid params render error message' do
      it 'html class with attribute' do
        post :create, sample: attributes_for(:sample)
        expect(response.body).to have_tag('ul.errors.text')
        expect(response.body).to have_tag('ul.errors.password')
        expect(response.body).to have_tag('ul.errors.textarea')
        expect(response.body).to have_tag('ul.errors.select')
        expect(response.body).to have_tag('ul.errors.radio')
        expect(response.body).to have_tag('ul.errors.checkbox')
      end

      it 'error message with html class with attribute' do
        post :create, sample: attributes_for(:sample)
        expect(response.body).to have_tag('li.text', text: 'presence')
        expect(response.body).to have_tag('li.password', text: 'presence')
        expect(response.body).to have_tag('li.textarea', text: 'presence')
        expect(response.body).to have_tag('li.select', text: 'presence')
        expect(response.body).to have_tag('li.radio', text: 'presence')
        expect(response.body).to have_tag('li.checkbox', text: 'presence')
      end

      it 'multi error render multi message' do
        post :create, sample: attributes_for(:valid_sample, text: 'あ' * 40)
        expect(response.body).to have_tag('li.text', text: 'format')
        expect(response.body).to have_tag('li.text', text: 'too_long')
      end
    end
  end
end