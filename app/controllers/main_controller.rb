class MainController < ApplicationController
  def index
    @phrases = Phrase.all
  end
end
