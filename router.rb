# frozen_string_literal: true

class Router
  include Helpers::Renderer
  include Helpers::RouteHelper

  def initialize
    @pathes = {'/': method(:home), '/rules': method(:rules), '/statistics': method(:statistics),
               '/game': method(:game), '/take_hint': method(:take_hint),
               '/submit_answer': method(:submit_answer), '/lose': method(:lose), '/win': method(:win)}
    @registrator = GameRegistrator.new
    @game_adapter = GameAdapter.new
    @game_finisher = GameFinisher.new
    @statistic_controller = StatisticController.new
  end

  def call(env)
    @request = Rack::Request.new(env)
    @pathes.key?(@request.path.to_sym) ? @pathes[@request.path.to_sym].call : wrong_path
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

    @game_adapter.reset_game_state
    home_page
  end

  def statistics
    return back_to_active_game if active_game?

    @statistic_controller.show_stats
  end

  def active_game?
    @request.session[:game]
  end

  def game
    return back_home if @request.get? && !active_game?

    @request.session[:game] ||= @registrator.create_game(@request)
    @game_adapter.play(@request)
  rescue StandardError => e
    @registrate_error = [] << e.message
    back_home
  end

  def take_hint
    if active_game?
      @game_adapter.take_hint(@request)
      back_to_active_game
    else
      back_home
    end
  rescue StandardError => _e
    back_to_active_game
  end

  def submit_answer
    return back_home unless active_game?

    @game_adapter.check_input(@request)
  end

  def win
    return back_to_active_game if active_game?

    @game_finisher.win(@game_adapter)
  end

  def lose
    return back_to_active_game if active_game?

    @game_finisher.lose(@game_adapter)
  end
end
