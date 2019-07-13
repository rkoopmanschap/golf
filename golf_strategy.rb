class GolfStrategy

	def initialize(player_number, table)
		@cards_opened = nil
		@swap_point_gain = nil
		@points_lead = nil
		@player_number = player_number
		@table = table
	end

	# =====================
			public
	# =====================

	def pick_move
		raise NotImplementedError
	end	

	def pick_target_card
		raise NotImplementedError
	end

	# =====================
			private
	# =====================

	def calculate_board_facts
		
		
		cards_opened
		swap_point_gain
		best_swap_card
		swap_card_value
		first_closed_card
	end

end
