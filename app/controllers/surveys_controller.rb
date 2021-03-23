class SurveysController < ApplicationController
  before_action :set_survey, only: [:show, :edit, :update, :destroy]
end
