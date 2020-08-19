# frozen_string_literal: true

module Helpers
  module Renderer
    private

    def render(template)
      path = File.expand_path("../../views/#{template}", __FILE__)
      Haml::Engine.new(File.read(path)).render(binding)
    end

    def home_page
      Rack::Response.new(render('menu.html.haml')).finish
    end


    def wrong_path
      Rack::Response.new(render('not_found.html.haml'), 404).finish
    end

    def rules_page
      Rack::Response.new(render('rules.html.haml')).finish
    end

    def statistics_page
      Rack::Response.new(render('statistics.html.haml')).finish
    end


    def lose_page
      Rack::Response.new(render('lose.html.haml')).finish
    end

    def win_page
      Rack::Response.new(render('win.html.haml')).finish
    end

    def game_page
      Rack::Response.new(render('game.html.haml')).finish
    end
  end
end
