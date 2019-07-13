class Table

	attr_accessor :closed_card_stack, :open_card_stack, :all_player_cards

	def initialize(number_of_players=3)
		@all_cards = [
			:two, :two, :two, :two,
			:three, :three, :three, :three,
			:four, :four, :four, :four,
			:five, :five, :five, :five,
			:six, :six, :six, :six,
			:seven, :seven, :seven, :seven,
			:eight, :eight, :eight, :eight,
			:nine, :nine, :nine, :nine,
			:ten, :ten, :ten, :ten,
			:jack, :jack, :jack, :jack,
			:queen, :queen, :queen, :queen,
			:king, :king, :king, :king,
			:ace, :ace, :ace, :ace
		]
		@number_of_players = number_of_players
		@closed_card_stack = []
		@open_card_stack = []
		@all_player_cards = []
		@number_of_players.times do |player_number|
			@all_player_cards.push([
				{ number: 0, position: :top_left, card: nil, opened: false, player_number: player_number },
				{ number: 1, position: :top_middle, card: nil, opened: false, player_number: player_number },
				{ number: 2, position: :top_right, card: nil, opened: false, player_number: player_number },
				{ number: 3, position: :bottom_left, card: nil, opened: false, player_number: player_number },
				{ number: 4, position: :bottom_middle, card: nil, opened: false, player_number: player_number },
				{ number: 5, position: :bottom_right, card: nil, opened: false, player_number: player_number }
			 ])
		end

		@game_over_timer = nil
	end

	def shuffle
		@closed_card_stack = @all_cards.dup.shuffle
	end

	def give_cards(player_number)
		this_player_cards = @all_player_cards[player_number]

		number_of_cards = 6
		number_of_cards.times do |card_number|
			card = @closed_card_stack.pop
			current_card = this_player_cards[card_number]
			current_card[:card] = card
			current_card[:opened] = false
		end
	end

	def open_first_card
		card = @closed_card_stack.pop
		@open_card_stack.push(card)
	end

	def open_first_player_card(player_number)
		this_player_cards = @all_player_cards[player_number]
		first_card = this_player_cards[0]
		first_card[:opened] = true
	end

	def process_move(move)
		if(move == :draw_card)
			card = @closed_card_stack.pop
			@open_card_stack.push(card)
		elsif(move == :open_card)
			# do nothing
		elsif(move == :swap_card)
			# do nothing
		else
			raise "Move not recognized: #{move}"
		end
	end

	def process_target_card(move, target_card, player_number)
		if(move == :draw_card)
			return if target_card.nil?
			swap_card(target_card, player_number)
		elsif(move == :open_card)
			puts "target_card = #{target_card}"
			player_card = @all_player_cards[player_number][target_card]
			raise "invalid move: #{move}, card: #{target_card}, player_number: #{player_number}" if(player_card[:opened] == true)
			player_card[:opened] = true
		elsif(move == :swap_card)
			raise "invalid move: #{move}, card: #{target_card}, player_number: #{player_number}" if target_card == nil
			swap_card(target_card, player_number)	
		end
	end

	def swap_card(target_card, player_number)
		card = @open_card_stack.pop(card)
		player_card = @all_player_cards[player_number][target_card]
		@open_card_stack.push(player_card[:card])
		player_card[:card] = card
		player_card[:opened] = true
	end

	def process_turn_end(player_number)
		if(!@game_over_timer.nil?)
			@game_over_timer -= 1 
			return
		end

		@all_player_cards[player_number].each do |card|
			if !card[:opened]
				return false
			end
		end
		@game_over_timer = @all_player_cards.size - 1
		return true
	end

	def game_over?
		return (@game_over_timer == 0) ? true : false
	end

	def print_table
		puts "closed_card_stack: #{@closed_card_stack.size}"
		puts "open_card_stack: #{@open_card_stack.size}, #{@open_card_stack.last}"
		puts "all_player_cards"
		@number_of_players.times do |player_number|
			print_player_cards(player_number)
		end
		puts "scores"
		@all_player_cards.size.times do |player_number| 
			puts "player_number #{player_number}: score: #{calculate_score(player_number)}"
		end
	end

	def print_player_cards(player_number)
		player_cards = @all_player_cards[player_number]
		puts "=== Player #{player_number} ==="
		puts "#{print_card(player_cards[0])} #{print_card(player_cards[1])} #{print_card(player_cards[2])}"
		puts "#{print_card(player_cards[3])} #{print_card(player_cards[4])} #{print_card(player_cards[5])}"
	end

	def print_card(player_card)
		if(player_card[:opened])
			return player_card[:card].to_s.rjust(10)
		else 
			return "*#{player_card[:card]}*".rjust(10)
		end
	end

	def calculate_score(player_number)
		player_cards = @all_player_cards[player_number]

		top_left_card = nil
		top_middle_card = nil
		top_right_card = nil
		bottom_left_card = nil
		bottom_middle_card = nil
		bottom_right_card = nil

		player_cards.each do |player_card|
			top_left_card 		= player_card if player_card[:position] == :top_left
			top_middle_card 	= player_card if player_card[:position] == :top_middle
			top_right_card 		= player_card if player_card[:position] == :top_right

			bottom_left_card 	= player_card if player_card[:position] == :bottom_left
			bottom_middle_card 	= player_card if player_card[:position] == :bottom_middle
			bottom_right_card 	= player_card if player_card[:position] == :bottom_right
		end

		ignore_left 	= (top_left_card[:card] == bottom_left_card[:card])
		ignore_center 	= (top_middle_card[:card] == bottom_middle_card[:card])
		ignore_right 	= (top_right_card[:card] == bottom_right_card[:card])

		left_score = get_card_score(top_left_card[:card]) + get_card_score(bottom_left_card[:card])
		middle_score = get_card_score(top_middle_card[:card]) + get_card_score(bottom_middle_card[:card])
		right_score = get_card_score(top_right_card[:card]) + get_card_score(bottom_right_card[:card])
		
		left_score = 0 if(top_left_card[:card] == bottom_left_card[:card])
		middle_score = 0 if(top_middle_card[:card] == bottom_middle_card[:card])
		right_score = 0 if(top_right_card[:card] == bottom_right_card[:card])

		score = left_score + middle_score + right_score

		return score
	end

	def get_card_score(card)
		return case card
		when :two 	then 2
		when :three then 3
		when :four 	then 4
		when :five 	then 5
		when :six 	then 6
		when :seven then 7
		when :eight then 8
		when :nine 	then 9
		when :ten 	then 10
		when :jack 	then 10
		when :queen then 10
		when :king 	then 0
		when :ace 	then -2
		when nil 	then 0
		end
	end

end
