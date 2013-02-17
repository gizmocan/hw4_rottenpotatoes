require 'spec_helper'

describe Movie do
  describe 'find movies with same director' do
    it 'has a valid factory' do
      FactoryGirl.create(:movie).should be_valid
    end

    context 'with valid director information' do
      it 'return all database entries with the same director' do
        aliens = FactoryGirl.create(:movie, id: 1, title: "Aliens", director: "James Cameron")
        avatar = FactoryGirl.create(:movie, id: 2, title: "Avatar", director: "James Cameron")
        other1 = FactoryGirl.create(:movie, id: 3)
        other2 = FactoryGirl.create(:movie, id: 4)
        Movie.find_similar(aliens.id).should == [aliens, avatar]
      end
    end

    context 'without valid director information' do
      it 'returns nil' do
        no_director = FactoryGirl.create(:movie, director: nil)
        Movie.find_similar(no_director.id).should be_nil
      end
    end
  end
end
