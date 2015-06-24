class SamplesController < ApplicationController
  def new
    @sample = Sample.new
  end


  def create
    Sample.create!(sample_params)
    redirect_to new_path
  rescue ActiveRecord::RecordInvalid => e
    @sample = e.record
    render :new
  end


  private
  def sample_params
    params.fetch(:sample, {}).permit(:text, :password, :textarea, :select, :radio, checkbox: [])
  end

end
