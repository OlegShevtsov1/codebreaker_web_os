# frozen_string_literal: true

RSpec.describe CurrentGame do
  include Rack::Test::Methods
  include Helpers::RouteHelper

  def app
    Router.new
  end

  def error
    nil
  end

  def set_params_number(request, number)
    request.instance_variable_set(:@params, { 'number' => number })
  end

  let(:current_game) { described_class.new }
  let(:game) { CodebreakerOs::Game.new(CodebreakerOs::Player.new('User'), CodebreakerOs::Difficulty.new('easy')) }

  describe '#reset_game_state' do
    it 'sets lose_state to false' do
      current_game.reset_game_state
      expect(current_game.instance_variable_get(:@lose_state)).to be false
    end

    it 'sets win_state to false' do
      current_game.reset_game_state
      expect(current_game.instance_variable_get(:@win_state)).to be false
    end

    it 'sets game_over to nil' do
      current_game.reset_game_state
      expect(current_game.instance_variable_get(:@game_over)).to be nil
    end
  end

  describe '#won?' do
    it 'returns true when game is won' do
      current_game.instance_variable_set(:@win_state, true)
      expect(current_game.won?).to be true
    end

    it 'returns false when game is not won' do
      current_game.instance_variable_set(:@win_state, false)
      expect(current_game.won?).to be false
    end
  end

  describe '#lost?' do
    it 'returns true when game is lost' do
      current_game.instance_variable_set(:@lose_state, true)
      expect(current_game.lost?).to be true
    end

    it 'returns false when game is not lost' do
      current_game.instance_variable_set(:@lose_state, false)
      expect(current_game.lost?).to be false
    end
  end

  describe '#error' do
    it 'returns nil when no errors' do
      expect(current_game.error).to be nil
    end

    it 'returns string when error presents' do
      current_game.instance_variable_set(:@input_error, ['Your name is too short'])
      expect(current_game.error.class).to eq(String)
    end
  end

  describe '#play' do
    before do
      get '/game'
      get '/take_hint'
    end

    it 'returns game_page' do
      last_request.env['rack.session'] = { game: game }
      @game = game
      @hints = []
      expect(current_game.play(last_request)[1]).to eq(game_page[1])
    end

    it 'redirects to lose_page when 0 attempts left' do
      game.instance_variable_set(:@attempts_used, 15)
      get '/take_hint'
      last_request.env['rack.session'] = { game: game }
      expect(current_game).to receive(:redirect_to).with(Router::PATH[:lose])
      current_game.play(last_request)
    end
  end

  describe '#take_hint' do
    before { get '/take_hint' }

    it 'returns array' do
      last_request.env['rack.session'] = { game: game }
      expect(current_game.take_hint(last_request).class).to eq(Array)
    end
  end

  describe '#check_input' do
    context 'when input is invalid' do
      before { get '/submit_answer' }

      it 'returns to active game' do
        last_request.env['rack.session'] = { game: game }
        set_params_number(last_request, '11111')
        expect(current_game).to receive(:redirect_to).with(Router::PATH[:game])
        current_game.check_input(last_request)
      end

      it 'doesnt change game attempts' do
        last_request.env['rack.session'] = { game: game }
        set_params_number(last_request, '11111')
        expect { current_game.check_input(last_request) }.not_to change(last_request.session[:game], :attempts_used)
      end
    end

    context 'when input is valid' do
      before { get '/submit_answer' }

      it 'returns to active game' do
        last_request.env['rack.session'] = { game: game }
        set_params_number(last_request, '1111')
        expect(current_game).to receive(:redirect_to).with(Router::PATH[:game])
        current_game.check_input(last_request)
      end

      it 'sets String to session[:user_code]' do
        last_request.env['rack.session'] = { game: game }
        set_params_number(last_request, '1111')
        current_game.check_input(last_request)
        expect(last_request.session[:user_code].class).to eq(String)
      end

      it 'wins the game when input is equal to secret_code' do
        last_request.env['rack.session'] = { game: game }
        set_params_number(last_request, game.secret_number.to_s)
        expect(current_game).to receive(:redirect_to).with(Router::PATH[:win])
        current_game.check_input(last_request)
      end
    end
  end
end
