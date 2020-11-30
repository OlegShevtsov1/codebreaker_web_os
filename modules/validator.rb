# frozen_string_literal: true

module Validator
  def validate(player)
    error_name unless player.valid?
  end

  def error_name
    raise StandardError, I18n(:name_not_valid, player_name: request.params['player_name'])
  end
end
