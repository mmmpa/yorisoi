require 'rails_helper'

RSpec.describe Sample, :type => :model do
  it 'check factory' do
    expect(create(:valid_sample)).to be_a(Sample)
    expect{create(:sample)}.to raise_exception
  end

  context 'presence' do
    [:text, :password, :textarea, :select, :radio, :checkbox].each do |attribute_name|
      it "blank #{attribute_name} get invalid" do
        model = build(:valid_sample)
        model[attribute_name] = nil
        expect(model.has_error_on(attribute_name, :presence)).to be_truthy
      end

      it "input #{attribute_name} get valid" do
        model = build(:valid_sample)
        expect(model.has_error_on(attribute_name, :presence)).to be_falsey
      end
    end
  end

  context 'inclusion' do
    [:select, :radio].each do |attribute_name|
      it "out of selector #{attribute_name} get invalid" do
        model = build(:valid_sample)
        model[attribute_name] = :a
        expect(model.has_error_on(attribute_name, :inclusion)).to be_truthy
      end

      it "in selector #{attribute_name} get valid" do
        model = build(:valid_sample)
        expect(model.has_error_on(attribute_name, :inclusion)).to be_falsey
      end
    end
  end
end
