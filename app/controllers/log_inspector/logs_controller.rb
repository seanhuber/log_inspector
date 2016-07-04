module LogInspector
  class LogsController < ApplicationController

    def index
      @directory = Rails.application.root.join('log')
    end
  end
end
