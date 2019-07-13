# always turns a card, no matter what
# used as a simple basic strategy

class DefaultStrategy < GolfStrategy
	def initialize(player_number, table)
		super(player_number, table)

	end

	def pick_move
		return :open_card
	end	

	def pick_target_card
		player_cards = @table.all_player_cards[@player_number]
		player_cards.each do |card|
			return card[:number] if(!card[:opened])
		end
		raise "no more cards to turn"
	end
end
