# frozen_string_literal: true

class CurrentGame
  include Helpers::RouteHelper

  attr_reader :lose_state, :win_state, :game_over

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
    @game.attempts_available? ? game_page : lose_the_game(request)
  end

  def take_hint(request)
    request.session[:hints] = [] unless request.session[:hints]
    request.session[:hints] << request.session[:game].hint
  end

  def check_input(request)
    guess = CodebreakerOs::Guess.new(request.params['number'])
    if guess.valid?
      return win_the_game(request) if win?(request)

      decorate(request)
    end
    redirect_to(Router::PATH[:game])
  rescue StandardError => e
    errors = []
    @input_error = errors.push(request.params['number'] ? e.message : I18n(:guess))
  end

  private

  def lose_the_game(request)
    finish(request)
    @lose_state = true
    redirect_to(Router::PATH[:lose])
  end

  def win_the_game(request)
    finish(request)
    @win_state = true
    redirect_to(Router::PATH[:win])
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
