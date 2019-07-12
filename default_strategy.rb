class DefaultStrategy
	def initialize

	end

	def pick_move(table, player_number)
		return :open_card
	end	

	def pick_target_card(move, table, player_number)
		player_cards = table.all_player_cards[player_number]
		player_cards.each do |card|
			return card[:number] if(!card[:opened])
		end
		raise "no more cards to turn"
	end
end
