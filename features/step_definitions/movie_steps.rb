# Add a declarative step here for populating the DB with movies.

Given /^the following movies exist:$/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    @movie = Movie.new
    @movie.title = movie["title"]
    @movie.rating = movie["rating"]
    @movie.release_date = movie["release_date"]
    @movie.save
  end
  #assert false, "Unimplmemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  assert !page.body.index(e1).nil?, "Not found: "+e1
  assert !page.body.index(e2).nil?, "Not found: "+e2
  assert page.body.index(e1) < page.body.index(e2), "Failed: "+e1+" ("+page.body.index(e1).to_s+"),  "+e2+" ("+page.body.index(e2).to_s+")"
  #assert false, "Unimplmemented"
end

Then /I should see all of the movies/ do
  movies = Movie.all
  movies_count = movies.count
  page_count = page.all(:xpath,"//table/tbody/tr").count
  assert movies_count == page_count, "There is "+movies_count.to_s+" movie(s) in DB, but only "+page_count.to_s+" is visible"
  movies.each do |movie|
    movie_title = movie["title"]
    assert !page.body.index(movie_title).nil?, "Movie \""+movie_title+"\" not found!"
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(/,\s*/)
  ratings.each do |rating|
    if (uncheck)
      uncheck("ratings_"+rating)
    else
      check("ratings_"+rating)
    end
  end
end

When /I (un)?check all of the ratings/ do |uncheck|
  ratings = Movie.all_ratings
  ratings.each do |rating|
    if (uncheck)
      uncheck("ratings_"+rating)
    else
      check("ratings_"+rating)
    end
  end
end
