class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  include Authenticable

  protected
    def paginate(options={})
      {
        pagination: {
          per_page: options[:per_page],
          total_pages: options[:resource].total_pages,
          total_objects: options[:resource].total_count
        }
      }
    end
end
