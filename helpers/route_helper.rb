# frozen_string_literal: true

module Helpers
  module RouteHelper
    private

    def back_to_active_game
      Rack::Response.new { |response| response.redirect('/game') }.finish
    end

    def back_home
      Rack::Response.new { |response| response.redirect('/') }.finish
    end

    def redirect_to_win_page
      Rack::Response.new { |response| response.redirect('/win') }.finish
    end

    def redirect_to_lose_page
      Rack::Response.new { |response| response.redirect('/lose') }.finish
    end
  end
end
