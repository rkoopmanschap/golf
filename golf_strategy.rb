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

	def get_opposite_card(player_cards, player_card_number)
		case player_card_number
		when 0 then player_cards[3]
		when 1 then player_cards[4]
		when 2 then player_cards[5]
		when 3 then player_cards[0]
		when 4 then player_cards[1]
		when 5 then player_cards[2]
		else 
			raise "error in opposite_card #{player_card_number}, player_cards: #{player_cards}"
		end
	end

	def calculate_board_facts
		player_cards = @table.all_player_cards[@player_number]

		@cards_opened = 0
		@swap_card_value = @table.swap_card_value
		@swap_card = @table.swap_card
		@first_closed_card = nil

		@best_swap_point_gain = nil
		@best_swap_card = nil
		@best_estimated_swap_value = nil
		@best_estimated_swap = nil
		@points_lead = nil

		player_cards.each_with_index do |player_card, index|
			@cards_opened += 1 if player_card[:opened]
			@first_closed_card = player_card if @first_closed_card.nil? && !player_card[:opened]

			opposite_card = get_opposite_card(player_cards, player_card[:number])

			swap = player_card
			swap_value = nil
			estimated_swap_value = nil

			if(opposite_card[:card] == @swap_card && opposite_card[:opened] && player_card[:opened])
				swap_value = -@table.get_card_score(opposite_card[:card]) - @table.get_card_score(player_card[:card])
			elsif(player_card[:opened])
				swap_value = @table.get_card_score(@swap_card) - @table.get_card_score(player_card[:card])
			end
				
			if(!player_card[:opened])
				estimated_value = 5
				estimated_swap_value = @table.get_card_score(@swap_card) - estimated_value
			end

			if(swap_value)
				if(@best_swap_point_gain.nil? || swap_value < @best_swap_point_gain)
					@best_swap_point_gain = swap_value
					@best_swap_card = swap
				end
			else
				if(@best_estimated_swap_value.nil? || estimated_swap_value < @best_estimated_swap_value)
					@best_estimated_swap_value = estimated_swap_value
					@best_estimated_swap = swap
				end
			end
		end
		
		# points = @table.number_of_players.times do |player_number|
		# 	score = @table.calculate_score(player_number)
		# 	puts "score = #{score}"
		# end
	end

end
