# frozen_string_literal: true

RSpec.describe GameFinisher do
  include Rack::Test::Methods
  include Helpers::Renderer

  let(:finisher) { described_class.new }
  let(:game_adapter) { GameAdapter.new }
  let(:game) { CodebreakerOs::Game.new(CodebreakerOs::Player.new('User'), CodebreakerOs::Difficulty.new('hell')) }

  before do
    game_adapter.instance_variable_set(:@finished_game, game)
  end

  describe '#lose' do
    it 'redirects to lose page when game is lost' do
      allow(game_adapter).to receive(:lost?).and_return(true)
      expect(finisher).to receive(:lose_page)
      finisher.lose(game_adapter)
    end

    it 'redirects to home_page when game is not lost' do
      allow(game_adapter).to receive(:lost?).and_return(false)
      expect(finisher).to receive(:back_home)
      finisher.lose(game_adapter)
    end
  end

  describe '#win' do
    before { stub_const('StatisticController::STORAGE_FILE', 'statistics.yml') }

    it 'redirects to win page when game is won' do
      allow(game_adapter).to receive(:won?).and_return(true)
      expect(finisher).to receive(:win_page)
      finisher.win(game_adapter)
    end

    it 'redirects to home page when game is not won' do
      allow(game_adapter).to receive(:won?).and_return(false)
      expect(finisher).to receive(:back_home)
      finisher.lose(game_adapter)
    end
  end
end
