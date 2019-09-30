require "everscreen/version"
require 'everscreen/configuration'
require 'everscreen/request'

module Everscreen
  class Error < StandardError; end

  def self.configure
    yield(configuration)
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.search(zip_code)
    Request.new.search(zip_code)
  end

  def self.near(location, radius)
    Request.new.near(location, radius)
  end
end
