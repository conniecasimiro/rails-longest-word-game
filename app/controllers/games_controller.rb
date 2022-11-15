require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @start_time = Time.now
    array = ("A".."Z").to_a + ("A".."Z").to_a
    @letters = array.sample(10)
    session[:letters] = @letters
    session[:start_time] = @start_time
  end

  def score
    @end_time = Time.now
    @word = params[:word].to_s
    @run_game = run_game(@word, session[:letters], session[:start_time].to_datetime, @end_time)
    # @run_game = run_game(@word, session[:letters])
    @score = @run_game[:score]
    @message = @run_game[:message]
    @time = (@end_time - session[:start_time].to_datetime).round(2)
  end

  # def run_game(attempt, grid)
  #   # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
  #   word_serialized = URI.open("https://wagon-dictionary.herokuapp.com/#{attempt}").read
  #   if attempt.upcase.chars.all? { |e| attempt.upcase.chars.count(e) <= grid.count(e) }
  #     if JSON.parse(word_serialized)["found"] == false
  #       { score: 0, message: "Not an english word!" }
  #     else
  #       { score: attempt.size, message: "Well done!" }
  #     end
  #   else
  #     { score: 0, message: "Not in the grid!" }
  #   end
  # end

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    word_serialized = URI.open("https://wagon-dictionary.herokuapp.com/#{attempt}").read
    if attempt.upcase.chars.all? { |e| attempt.upcase.chars.count(e) <= grid.count(e) }
      if JSON.parse(word_serialized)["found"] == false
        { score: 0, message: "Not an english word!", time: end_time - start_time }
      else
        { score: (attempt.size - ((end_time - start_time) * 0.01)).round(2), message: "Well done!", time: end_time - start_time }
      end
    else
      { score: 0, message: "Not in the grid!", time: end_time - start_time }
    end
  end
end

#   def compute_score(attempt, time_taken)
#     time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
#   end

#   def score_and_message(attempt, grid, time)
#     if included?(attempt.upcase, grid)
#       if english_word?(attempt)
#         score = compute_score(attempt, time)
#         [score, "well done"]
#       else
#         [0, "not an english word"]
#       end
#     else
#       [0, "not in the grid"]
#     end
#   end

#   def run_game(attempt, grid, start_time, end_time)
#     # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
#     result = { time: end_time - start_time }

#     score_and_message = score_and_message(attempt, grid, result[:time])
#     result[:score] = score_and_message.first
#     result[:message] = score_and_message.last

#     result
#   end

# end

# puts "What's your best shot?"
# start_time = Time.now
# attempt = gets.chomp
# end_time = Time.now

# puts "******** Now your result ********"

# result = run_game(attempt, grid, start_time, end_time)

# puts "Your word: #{attempt}"
# puts "Time Taken to answer: #{result[:time]}"
# puts "Your score: #{result[:score]}"
# puts "Message: #{result[:message]}"

# puts "*****************************************************"
