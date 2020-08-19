# frozen_string_literal: true

  class GameAdapter
    include Helpers::Renderer
    include Helpers::RouteHelper

    attr_reader :finished_game

    def reset_game_state
      @lose_state = false
      @win_state = false
      @finished_game = nil
    end

    def won?
      @win_state
    end

    def lost?
      @lose_state
    end

    def error
      @input_error&.delete_at(0)
    end

    def play(request)
      # binding.pry
      @game = request.session[:game]
      @user_code = request.session[:user_code]
      @hints = request.session[:hints] || []
      @game.attempts_available? ?  game_page : lose_the_game(request)
    end

    def take_hint(request)
      request.session[:hints] = [] unless request.session[:hints]
      request.session[:hints] << request.session[:game].hint
    end

    def check_input(request)
      guess = CodebreakerOs::Guess.new(request.params['number'])
      if guess.valid?
        return win_the_game(request) if request.session[:game].win?(request.params['number'])

        request.session[:user_code] = CodebreakerOs::Guess.decorate(request.session[:game].compare(request.params['number']))
      else
        @input_error = [].push(request.params['number'] ? e.message : 'Input your guess!')
      end
      back_to_active_game
    end

    private

    def convert_input(request)
      request.session[:user_code] = request.session[:game].check_the_guess(request.params['number'])
    end

    def lose_the_game(request)
      @finished_game = request.session[:game]
      reset_game_session(request)
      @lose_state = true
      redirect_to_lose_page
    end

    def win_the_game(request)
      @finished_game = request.session[:game]
      reset_game_session(request)
      @win_state = true
      redirect_to_win_page
    end

    def validate_input(request)
      CodebreakerOs::Game.validate_input(request.params['number'])
    end

    def reset_game_session(request)
      request.session.clear
    end
  end
