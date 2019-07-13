class TurnUntilLast < GolfStrategy
	def initialize(player_number, table)
		super(player_number, table)
		# draw_card
		# open_card
		# swap_card
		@intended_target = nil
		@move = nil
	end

	def pick_move
		calculate_board_facts
		@intended_target = nil
		@move = nil

		if(@cards_opened < 5)
			@move = :open_card
			return @move
		end

		if(@swap_point_gain > 5)
			@intended_target = @best_swap_card
			@move = :swap
			return @move
		end

		if(@points_lead > 5 && @swap_card_value < 6)
			@intended_target = @first_closed_card
			@move = :swap
			return @move
		end

		@move = :draw_card
		return @move
	end

	def pick_target_card
		if @move == :swap
			return @intended_target
		elsif(@move == :open_card)
			return nil
		elsif(@move == :draw_card)
			calculate_board_facts
			if(@swap_point_gain > 0)
				@intended_target = @best_swap_card
				return @intended_target
			else
				@intended_target = nil
				return @intended_target
			end
		end
	end
end
