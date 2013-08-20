module Sonic
  class ResultsController < ApplicationController

    def index
      json = File.read('public/sonic/results.json')
      @results = JSON.parse(json)

      respond_to do |format|
        format.html # index.html.erb
        format.json  { render :json => json }
      end
    end

  end
end
