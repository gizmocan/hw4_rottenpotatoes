# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  page.body is the entire content of the page as a string.
  /#{e1}[\w\W]*#{e2}/.should match(page.body)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_array = rating_list.split(',')
  rating_array.each do |rating|
    rating.strip!
    if uncheck
      uncheck("ratings_#{rating}")
    else
      check("ratings_#{rating}")
    end
  end
end

Then /I should see all of the movies/ do
  db_rows = Movie.count('title')
  db_rows.should == page.all("table tr").count - 1 # Don't count table header row
end

Then /I should not see any movies/ do
  0.should == page.all("table tr").count - 1 # Don't count table header row
end

Then /I should( not)? see movies with the following ratings: (.*)/ do |not_shown, rating_list|
  rating_array = rating_list.split(',')
  rating_array.each do |rating|
    rating.strip!
    title_list = Movie.where(:rating => rating).map(&:title)
    title_list.each do |title|
      if not_shown == " not"
        page.body.should_not include(title)
      else 
        page.body.should include(title)
      end
    end
  end
end

# New content for HW4
Then /^the director of "(.*)" should be "(.*)"$/ do |movie, director|
  Movie.find_by_title(movie).director.should == director
end




