class Player

	attr_accessor :player_number

	def initialize(player_number, strategy_class, table)
		@player_number = player_number
		@table = table
		@strategy = strategy_class.new(player_number, table)
	end

	def pick_move
		return @strategy.pick_move
	end

	def pick_target_card
		return @strategy.pick_target_card
	end

end
