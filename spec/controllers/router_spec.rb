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
    before { get Router::PATH[:home] }

    context "when #{Router::PATH[:home]}" do
      it 'renders home page' do
        expect(last_response.header).to eq(render_page('menu.html.haml')[1])
      end

      it 'returns ok status' do
        expect(last_response).to be_ok
      end
    end

    context "when #{Router::PATH[:rules]}" do
      before { get Router::PATH[:rules] }

      it 'renders rules page' do
        expect(last_response.header).to eq(render_page('rules.html.haml')[1])
      end

      it 'returns ok status' do
        expect(last_response).to be_ok
      end
    end

    context "when #{Router::PATH[:take_hint]}" do
      before { get Router::PATH[:take_hint] }

      it 'redirects' do
        expect(last_response).to be_redirect
      end

      it "redirects to #{Router::PATH[:home]}" do
        expect(last_response.header['Location']).to eq(Router::PATH[:home])
      end
    end

    context "when #{Router::PATH[:submit_answer]}" do
      before { get Router::PATH[:submit_answer] }

      it 'redirects' do
        expect(last_response).to be_redirect
      end

      it "redirects to #{Router::PATH[:home]}" do
        expect(last_response.header['Location']).to eq(Router::PATH[:home])
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

    context "when #{Router::PATH[:game]}" do
      before { get Router::PATH[:game] }

      it 'redirects' do
        expect(last_response).to be_redirect
      end

      it "redirects to #{Router::PATH[:home]}" do
        expect(last_response.header['Location']).to eq(Router::PATH[:home])
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

    context 'when redirects to game' do
      before { allow(app.instance_variable_get(:@current_game)).to receive(:take_hint) }

      it "redirects to #{Router::PATH[:game]}" do
        pathes.each do |path|
          get path
          expect(last_response.header['Location']).to eq(Router::PATH[:game])
        end
      end
    end
  end
end
