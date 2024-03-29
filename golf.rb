class Golf

	def initialize
		@table = Table.new
		@players = []
		@players.push(Player.new(0, DefaultStrategy, @table))
		@players.push(Player.new(1, DefaultStrategy, @table))
		@players.push(Player.new(2, TurnUntilLast, @table))
		@current_turn = 0
	end

	def shuffle
		@table.shuffle
		@players.each do |player|
			@table.give_cards(player.player_number)
		end
		@table.open_first_card
		@players.each do |player|
			@table.open_first_player_card(player.player_number)
		end
		@table.print_table
	end

	def play_game
		turn = 0
		while(!@table.game_over?)
			puts "================="
			puts "   Turn #{turn}  "
			puts "================="
			player = next_player
			play_turn(player)
			@table.print_table
			turn += 1
		end
	end

	def next_player
		if(@current_turn >= @players.size)
			@current_turn = 0
		end
		chosen_player = @players[@current_turn]
		@current_turn += 1
		return chosen_player
	end

	def play_turn(player)
		move = player.pick_move
		@table.process_move(move)
		target_card = player.pick_target_card
		puts "target_card = #{target_card}"
		@table.process_target_card(move, target_card, player.player_number)
		@table.process_turn_end(player.player_number)
	end

end
