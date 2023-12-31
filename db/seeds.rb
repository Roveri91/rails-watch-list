# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
p "destroying all"
List.destroy_all
Bookmark.destroy_all
Movie.destroy_all


# SCREAPING

require "open-uri"
require "nokogiri"

genres = ["comedy", "action", "horror", "drama"]

genres.each do |genre|
  url = "https://www.imdb.com/search/title/?genres=#{genre}"

  html_file = URI.open(url).read
  html_doc = Nokogiri::HTML.parse(html_file)

  html_doc.search(".lister-item").first(5).each do |element|
    image_class = element.search(".loadlate")
    image_element = image_class.at('img')
    loadlate_value = image_element['loadlate']
    # puts loadlate_value

    container = element.search(".lister-item-content")
    title_h3 = container.search(".lister-item-header")
    # Find the anchor tag within the selected element
    title = title_h3.at('a').text
    # puts title
    overview = element.search(".text-muted")[2].text
    # puts overview
    rating = element.search(".ratings-imdb-rating").at('[data-value]')
    rating = rating['data-value']
    unless Movie.where(title: title).exists?
      if Movie.create!(title: title, overview: overview, rating: rating, poster_url: loadlate_value)
        puts "create #{title}"
      end
    end
      # puts element.attribute("href").value
  end
end

# ----------------------

p "crating list"
drama = List.create(name: "Drama")
p "creating movies"
Movie.create(title: "Wonder Woman 1984", overview: "Wonder Woman comes into conflict with the Soviet Union during the Cold War in the 1980s", poster_url: "https://image.tmdb.org/t/p/original/8UlWHLMpgZm9bx6QYh0NFoq67TZ.jpg", rating: 6.9)
Movie.create(title: "The Shawshank Redemption", overview: "Framed in the 1940s for double murder, upstanding banker Andy Dufresne begins a new life at the Shawshank prison", poster_url: "https://image.tmdb.org/t/p/original/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg", rating: 8.7)
titanic = Movie.create(title: "Titanic", overview: "101-year-old Rose DeWitt Bukater tells the story of her life aboard the Titanic.", poster_url: "https://image.tmdb.org/t/p/original/9xjZS2rlVxm8SFx8kPC3aIGCOYQ.jpg", rating: 7.9)
Movie.create(title: "Ocean's Eight", overview: "Debbie Ocean, a criminal mastermind, gathers a crew of female thieves to pull off the heist of the century.", poster_url: "https://image.tmdb.org/t/p/original/MvYpKlpFukTivnlBhizGbkAe3v.jpg", rating: 7.0)

Bookmark.create(comment: "Recommended by John", movie: titanic, list: drama)
