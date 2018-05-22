require 'airbrake'
Dir[File.expand_path('../../lib/**/*.rb', __FILE__)].each do |f|
  require f
end

# Prepend the original Airbrake module
module Airbrake
  class << self
    prepend Blinkist::Airbrake::Scrubber
  end
end

# Set up the namespace and run every scrubber listed in SCRUBBERS
module Blinkist::Airbrake::Scrubber
  FILTERED  = '[Filtered]'
  SCRUBBERS = [ MessageEmail ]

  # Override original Airbrake.configure
  def configure(*args, &block)
    super
  ensure
    Blinkist::Airbrake::Scrubber.run!
  end

  # Run scrubbers
  def self.run!
    SCRUBBERS.each { |scrubber| scrubber::scrub! }
  end
end
