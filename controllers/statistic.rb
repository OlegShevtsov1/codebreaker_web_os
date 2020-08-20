# frozen_string_literal: true

class Statistic
  include Helpers::RouteHelper
  STORAGE_FILE = 'statistics.yml'

  NO_RESULTS = 'There are no winners yet! Be the first!'

  def show_stats
    winners = YAML.load_file(STORAGE_FILE)[:winners]
    @stats = CodebreakerOs::Statistic.sorted_winners(winners)

    statistics_page
  end
end
