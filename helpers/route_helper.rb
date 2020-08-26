# frozen_string_literal: true

module Helpers
  module RouteHelper
    private

    def home_page
      render_page('menu.html.haml')
    end

    def wrong_path
      render_page('not_found.html.haml', 404)
    end

    def rules_page
      render_page('rules.html.haml')
    end

    def statistics_page
      render_page('statistics.html.haml')
    end

    def lose_page
      render_page('lose.html.haml')
    end

    def win_page
      render_page('win.html.haml')
    end

    def game_page
      render_page('game.html.haml')
    end

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
