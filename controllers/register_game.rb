# frozen_string_literal: true

class RegisterGame
  include Validator

  def create_game(request)
    player = CodebreakerOs::Player.new(request.params['player_name'])
    validate(player)

    difficulty = CodebreakerOs::Difficulty.new(request.params['level'])
    @game = CodebreakerOs::Game.new(player, difficulty)
  end
end
