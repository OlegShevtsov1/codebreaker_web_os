# frozen_string_literal: true

class GameFinisher
  STORAGE_FILE = 'statistics.yml'
  include Helpers::Renderer
  include Helpers::RouteHelper

  def win(game_adapter)
    @finished_game = game_adapter.finished_game
    if @finished_game
      @storage_wrapper = CodebreakerOs::StorageWrapper.new(STORAGE_FILE)
      @yml_store = @storage_wrapper.new_store
      save_storage unless @storage_wrapper.storage_exists?
      synchronize_storage
      @winners << @finished_game
      save_storage
    end
    game_adapter.won? ? win_page : back_home
  end

  def lose(game_adapter)
    @finished_game = game_adapter.finished_game
    game_adapter.lost? ? lose_page : back_home
  end

  def save_storage
    @yml_store.transaction { @yml_store[:winners] = @winners || [] }
  end

  def synchronize_storage
    @yml_store.transaction(true) { @winners = @yml_store[:winners] }
  end
end
