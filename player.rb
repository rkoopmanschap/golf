class Player

	attr_accessor :player_number

	def initialize(player_number, strategy)
		@player_number = player_number
		@strategy = strategy
	end

	def pick_move(table)
		return @strategy.pick_move(table, @player_number)
	end

	def pick_target_card(move, table)
		return @strategy.pick_target_card(move, table, @player_number)
	end

end
