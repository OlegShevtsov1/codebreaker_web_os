# frozen_string_literal: true

class Statistic
  include Helpers::RouteHelper
  STORAGE_FILE = 'statistics.yml'

  NO_RESULTS = 'There are no winners yet! Be the first!'

  def show_stats
    storage = CodebreakerOs::StorageWrapper.new(STORAGE_FILE)
    winners = YAML.load_file(storage.storage_file)[:winners]
    @stats = CodebreakerOs::Statistic.sorted_winners(winners)

    statistics_page
  end
end
