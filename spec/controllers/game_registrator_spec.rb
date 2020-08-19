# frozen_string_literal: true

RSpec.describe GameRegistrator do
  include Rack::Test::Methods
  def app
    Rack::Builder.parse_file('config.ru').first
  end

  let(:registrator) { described_class.new }

  describe '#create_game' do
    context 'when input is valid' do
      it 'creates game instance' do
        post '/game'
        last_request.instance_variable_set(:@params, { 'player_name' => 'User', 'level' => 'hell' })
        expect(registrator.create_game(last_request).class).to eq(CodebreakerOs::Game)
      end
    end
  end
end
