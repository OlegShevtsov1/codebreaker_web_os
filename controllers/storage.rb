# frozen_string_literal: true

class Storage
  STORAGE_FILE = 'statistics.yml'
  include Helpers::RouteHelper

  attr_reader :decorator

  def initialize
    @decorator = Helpers::DecoratorHelper.new
  end

  def win(current_game)
    @game_over = current_game.game_over
    save if @game_over
    current_game.won? ? render_page('win.html.haml') : redirect_to(Router::PATH[:home])
  end

  def lose(current_game)
    @game_over = current_game.game_over
    current_game.lost? ? render_page('lose.html.haml') : redirect_to(Router::PATH[:home])
  end

  def save_storage
    @yml_store.transaction { @yml_store[:winners] = @winners || [] }
  end

  def synchronize_storage
    @yml_store.transaction(true) { @winners = @yml_store[:winners] }
  end

  def save
    @storage_wrapper = CodebreakerOs::StorageWrapper.new(STORAGE_FILE)
    @yml_store = @storage_wrapper.new_store
    save_storage unless @storage_wrapper.storage_exists?
    synchronize_storage
    @winners << @game_over
    save_storage
  end
end
