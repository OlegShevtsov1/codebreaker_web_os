# frozen_string_literal: true

module Helpers
  module RouteHelper
    private

    def redirect_to(route)
      Rack::Response.new { |response| response.redirect(route) }.finish
    end

    def render_page(template, status = 200)
      Rack::Response.new(render(template), status).finish
    end

    def render(template)
      path = File.expand_path("#{Router::VIEWS}#{template}", __FILE__)
      Haml::Engine.new(File.read(path)).render(binding)
    end
  end
end
