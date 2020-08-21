# frozen_string_literal: true

require_relative 'load'

use Rack::Reloader
use Rack::Static, urls: ['/assets']
use Rack::Static, urls: %w[/bootstrap /jquery], root: 'node_modules'
use Rack::Session::Cookie, key: 'rack.session',
                           path: '/',
                           expire_after: 2_592_000,
                           secret: 'codebreaker_os_2204',
                           old_secret: 'codebreaker_os'
run Router.new
