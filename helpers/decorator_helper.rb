# frozen_string_literal: true

module Helpers
  module DecoratorHelper
    def self.hints_left(game)
      game.difficulty[:hints].to_i - game.hints_used
    end

    def self.attempts_left(game)
      game.difficulty[:attempts].to_i - game.attempts_used
    end

    def self.hints_total_left(game)
      game.hints_total - game.hints_used
    end

    def self.attempts_total_left(game)
      game.attempts_total - game.attempts_used
    end

    def self.easy_level
      CodebreakerOs::Difficulty::LEVELS.keys[0].capitalize
    end

    def self.medium_level
      CodebreakerOs::Difficulty::LEVELS.keys[1].capitalize
    end

    def self.hell_level
      CodebreakerOs::Difficulty::LEVELS.keys[2].capitalize
    end
  end
end
