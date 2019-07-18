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
			@intended_target = @first_closed_card
			return @move
		end

		puts "@best_swap_point_gain = #{@best_swap_point_gain}"
		if(@best_swap_point_gain > 5)
			@intended_target = @best_swap_card
			@move = :swap
			return @move
		end

		# if(@swap_card_value < 6)
		# # if(@points_lead > 5 && @swap_card_value < 6)
		# 	@intended_target = @first_closed_card
		# 	@move = :swap
		# 	return @move
		# end

		@move = :draw_card
		return @move
	end

	def pick_target_card
		puts "@move = #{@move}"
		puts "@swap_point_game = #{@swap_point_game}"
		puts "@intended_target = #{@intended_target}"
		puts "@best_swap_card = #{@best_swap_card}"
		if @move == :swap
			return @intended_target[:number]
		elsif(@move == :open_card)
			return @intended_target[:number]
		elsif(@move == :draw_card)
			calculate_board_facts
			if(@best_swap_point_gain > 0)
				@intended_target = @best_swap_card
				return @intended_target[:number]
			else
				@intended_target = nil
				return @intended_target
			end
		end
	end
end
