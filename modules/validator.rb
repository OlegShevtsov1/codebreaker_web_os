# frozen_string_literal: true

module Validator
  def validate(player, request)
    error_name(request) unless player.valid?
  end

  def error_name(request)
    raise StandardError, I18n.t(:name_not_valid, player_name: request.params['player_name'])
  end
end
