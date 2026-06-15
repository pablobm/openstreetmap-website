# frozen_string_literal: true

class WebConsolesController < ApplicationController
  layout :site_layout

  before_action :authorize_web
  before_action :set_locale
  before_action :check_database_readable

  authorize_resource :class => :web_console

  before_action :check_database_writable

  def show; end
end
