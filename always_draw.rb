class AlwaysDraw  < GolfStrategy
	def initialize(player_number, table)
		super(player_number, table)
	end

	def pick_move
		# trek altijd
		# als een swap heel voordelig is, doe een swap met open kaart
		# anders, als swap met gesloten kaart een win is, swap
		# anders, als < 5 kaarten zichtbaar, swap met gesloten kaart, als kaart lager is dan 7
		# zo niet, laat hem liggen
	end	

	def pick_target_card
		
	end
end
