# frozen_string_literal: true

class Router
  include Helpers::RouteHelper
  PATH = { home: '/',
           game: '/game',
           rules: '/rules',
           statistics: '/statistics',
           take_hint: '/take_hint',
           submit_answer: '/submit_answer',
           lose: '/lose',
           win: '/win' }.freeze

  def initialize
    @register_game = RegisterGame.new
    @current_game = CurrentGame.new
    @storage = Storage.new
    @statistic = Statistic.new
  end

  def call(env)
    @request = Rack::Request.new(env)
    PATH.value?(@request.path) ? method(PATH.key(@request.path)).call : wrong_path
  end

  def error
    @registrate_error&.delete_at(0)
  end

  private

  def rules
    return back_to_active_game if active_game?

    rules_page
  end

  def home
    @request.session.clear
    return back_to_active_game if active_game?

    @current_game.reset_game_state
    home_page
  end

  def statistics
    return back_to_active_game if active_game?

    @statistic.show_stats
  end

  def active_game?
    @request.session[:game]
  end

  def game
    return back_home if @request.get? && !active_game?

    @request.session[:game] ||= @register_game.create_game(@request)
    @current_game.play(@request)
  rescue StandardError => e
    @registrate_error = [] << e.message
    back_home
  end

  def take_hint
    if active_game?
      @current_game.take_hint(@request)
      back_to_active_game
    else
      back_home
    end
  rescue StandardError => _e
    back_to_active_game
  end

  def submit_answer
    return back_home unless active_game?

    @current_game.check_input(@request)
  end

  def win
    return back_to_active_game if active_game?

    @storage.win(@current_game)
  end

  def lose
    return back_to_active_game if active_game?

    @storage.lose(@current_game)
  end
end
