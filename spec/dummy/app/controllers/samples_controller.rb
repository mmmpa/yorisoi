class SamplesController < ApplicationController
  def new
    @sample = Sample.new
  end

  def remnant
    @sample = Sample.new
  end

  def create
    Sample.create!(sample_params)
    redirect_to params[:remnant] ? remnant_path : new_path
  rescue ActiveRecord::RecordInvalid => e
    @sample = e.record
    render params[:remnant] ? :remnant : :new
  end


  private
  def sample_params
    params.fetch(:sample, {}).permit(:text, :password, :textarea, :select, :radio, checkbox: [])
  end

end
class String
  alias :gsub_not_safety! :gsub!
end