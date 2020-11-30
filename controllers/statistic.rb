# frozen_string_literal: true

class Statistic
  include Helpers::RouteHelper

  attr_reader :decorator

  def initialize
    @decorator = Helpers::DecoratorHelper.new
  end

  def show_stats
    if FileTest.file?(Storage::STORAGE_FILE)
      winners = YAML.load_file(Storage::STORAGE_FILE)[:winners]
      @stats = CodebreakerOs::Statistic.sorted_winners(winners)
    end

    render_page('statistics.html.haml')
  end
end
