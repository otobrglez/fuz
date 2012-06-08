# By Oto Brglez - <oto.brglez@opalab.com>

require "clockwork"
require "./lib/fuz"

Mongoid.logger=Logger.new('/dev/null');

module Clockwork
  
  handler do |job|
    if job =~ /import_feeds/
      number = Source.import_feeds
      puts "Added #{number} of new PIMs." if number > 0
    end
  end


  every(5.minutes, 'import_feeds')
end