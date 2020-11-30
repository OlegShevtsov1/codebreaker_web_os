# frozen_string_literal: true

class CurrentGame
  include Helpers::RouteHelper
  MINUS = '-'
  PLUS = '+'

  attr_reader :lose_state, :win_state, :game_over, :decorator

  def initialize
    @decorator = Helpers::DecoratorHelper.new
  end

  def reset_game_state
    @lose_state = false
    @win_state = false
    @game_over = nil
  end

  def won?
    win_state
  end

  def lost?
    lose_state
  end

  def error
    @input_error&.shift
  end

  def play(request)
    @game = request.session[:game]
    @user_code = request.session[:user_code]
    @hints = request.session[:hints] || []
    @game.attempts_available? ? render_page('game.html.haml') : lose_the_game(request)
  end

  def take_hint(request)
    request.session[:hints] = [] unless request.session[:hints]
    request.session[:hints] << request.session[:game].hint
  end

  def check_input(request)
    guess = CodebreakerOs::Guess.new(request.params['number'])
    return win_the_game(request) if win?(request) && guess.valid?

    decorate(request) if guess.valid?
    redirect_to(Router::PATH[:game])
  rescue StandardError => e
    errors = []
    @input_error = errors.push(request.params['number'] ? e.message : I18n(:guess))
  end

  private

  def lose_the_game(request)
    @lose_state = true
    finish_game(request, :lose)
  end

  def win_the_game(request)
    @win_state = true
    finish_game(request, :win)
  end

  def finish_game(request, path)
    finish(request)
    redirect_to(Router::PATH[path])
  end

  def validate_input(request)
    CodebreakerOs::Game.validate_input(request.params['number'])
  end

  def reset_game_session(request)
    request.session.clear
  end

  def decorate(request)
    game = request.session[:game].compare(request.params['number'])
    request.session[:user_code] = CodebreakerOs::Guess.decorate(game)
  end

  def win?(request)
    request.session[:game].win?(request.params['number'])
  end

  def finish(request)
    @game_over = request.session[:game]
    reset_game_session(request)
  end
end
