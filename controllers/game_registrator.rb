# frozen_string_literal: true

  class GameRegistrator
    def create_game(request)
      player = CodebreakerOs::Player.new(request.params['player_name'])
      raise StandardError, "Name #{request.params['player_name']} isn't valid" unless player.valid?

      player = CodebreakerOs::Player.new(request.params['player_name'])
      difficulty = CodebreakerOs::Difficulty.new(request.params['level'])
      @game = CodebreakerOs::Game.new(player, difficulty)
    end
  end
