# frozen_string_literal: true

class RegisterGame
  def create_game(request)
    player = CodebreakerOs::Player.new(request.params['player_name'])
    validate(player)

    difficulty = CodebreakerOs::Difficulty.new(request.params['level'])
    @game = CodebreakerOs::Game.new(player, difficulty)
  end

  def error_name
    raise StandardError, "Name #{request.params['player_name']} isn't valid"
  end

  def validate(player)
    error_name unless player.valid?
  end
end
