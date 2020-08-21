# frozen_string_literal: true

RSpec.describe Router do
  include Rack::Test::Methods
  include Helpers::RouteHelper
  let(:router) { described_class.new }
  let(:game) { CodebreakerOs::Game.new(CodebreakerOs::Player.new('User'), 'hell') }
  let(:current_game) { app.instance_variable_get(:@current_game) }
  let(:pathes) { %w[/ /rules /lose /win /statistics /take_hint] }

  def app
    router
  end

  def error
    nil
  end

  context 'when no active game' do
    context 'when /' do
      it 'renders home page' do
        get '/'
        expect(last_response.header).to eq(home_page[1])
      end

      it 'returns ok status' do
        get '/'
        expect(last_response).to be_ok
      end
    end

    context 'when /rules' do
      it 'renders rules page' do
        get '/rules'
        expect(last_response.header).to eq(rules_page[1])
      end

      it 'returns ok status' do
        get '/'
        expect(last_response).to be_ok
      end
    end

    context 'when /take_hint' do
      it 'redirects' do
        get '/take_hint'
        expect(last_response).to be_redirect
      end

      it 'redirects to /' do
        get '/take_hint'
        expect(last_response.header['Location']).to eq('/')
      end
    end

    context 'when /submit_answer' do
      before { get '/submit_answer' }

      it 'redirects' do
        expect(last_response).to be_redirect
      end

      it 'redirects to /' do
        expect(last_response.header['Location']).to eq('/')
      end
    end

    context 'when url is unknown' do
      before { get '/unknown' }

      it 'render not found page' do
        expect(last_response.body).to include('NOT FOUND')
      end

      it 'returns 404 status' do
        expect(last_response.status).to eq(404)
      end
    end

    context 'when /game' do
      before { get '/game' }

      it 'redirects' do
        expect(last_response).to be_redirect
      end

      it 'redirects to /' do
        expect(last_response.header['Location']).to eq('/')
      end
    end
  end

  context 'when active game' do
    before { allow(app).to receive(:active_game?).and_return(true) }

    it 'redirects' do
      pathes.each do |path|
        get path
        expect(last_response).to be_redirect
      end
    end

    it 'redirects to /game' do
      pathes.each do |path|
        allow(app.instance_variable_get(:@current_game)).to receive(:take_hint)
        get path
        expect(last_response.header['Location']).to eq('/game')
      end
    end
  end
end
