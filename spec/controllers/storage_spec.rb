# frozen_string_literal: true

RSpec.describe Storage do
  include Rack::Test::Methods
  include Helpers::RouteHelper

  let(:finisher) { described_class.new }
  let(:current_game) { CurrentGame.new }
  let(:game) { CodebreakerOs::Game.new(CodebreakerOs::Player.new('User'), CodebreakerOs::Difficulty.new('hell')) }

  before do
    current_game.instance_variable_set(:@game_over, game)
  end

  describe '#lose' do
    it 'redirects to lose page when game is lost' do
      allow(current_game).to receive(:lost?).and_return(true)
      expect(finisher).to receive(:lose_page)
      finisher.lose(current_game)
    end

    it 'redirects to home_page when game is not lost' do
      allow(current_game).to receive(:lost?).and_return(false)
      expect(finisher).to receive(:back_home)
      finisher.lose(current_game)
    end
  end

  describe '#win' do
    before { stub_const('Statistic::STORAGE_FILE', 'spec/fixtures/test_statistics.yml') }

    it 'redirects to win page when game is won' do
      allow(current_game).to receive(:won?).and_return(true)
      expect(finisher).to receive(:win_page)
      finisher.win(current_game)
    end

    it 'redirects to home page when game is not won' do
      allow(current_game).to receive(:won?).and_return(false)
      expect(finisher).to receive(:back_home)
      finisher.lose(current_game)
    end
  end
end
