class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  def self.find_similar(movie_id)
    director = find(movie_id).director
    if director == nil or director == ""
      return nil
    end

    return find_all_by_director(director)
  end
end
