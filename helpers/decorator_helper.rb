# frozen_string_literal: true

module Helpers
  class DecoratorHelper
    def hints_left(game)
      game.difficulty[:hints].to_i - game.hints_used
    end

    def attempts_left(game)
      game.difficulty[:attempts].to_i - game.attempts_used
    end

    def hints_total_left(game)
      game.hints_total - game.hints_used
    end

    def attempts_total_left(game)
      game.attempts_total - game.attempts_used
    end

    def difficulty_name(game)
      game.difficulty[:name].to_s.capitalize
    end
  end
end
