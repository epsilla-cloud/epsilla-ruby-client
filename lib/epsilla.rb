# frozen_string_literal: true

require_relative "epsilla/version"

module Epsilla
  autoload :Base, "epsilla/base"
  autoload :Client, "epsilla/client"
  autoload :DataBase, "epsilla/database"
  autoload :Health, "epsilla/health"
  autoload :Error, "epsilla/error"
end
