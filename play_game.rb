require_relative 'default_strategy'
require_relative 'golf'
require_relative 'player'
require_relative 'table'

golf = Golf.new
golf.shuffle
golf.play_game
