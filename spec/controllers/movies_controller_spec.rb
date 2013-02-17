require 'spec_helper'

describe MoviesController do
  describe 'provide basic movies website navigation features' do
    it 'create a new movie entry' do
      movie_params = FactoryGirl.attributes_for(:movie)
      expect { post :create, :movie => movie_params }.to change(Movie, :count).by(1) 
      response.should redirect_to movies_path      
    end
  end

  describe 'find movies with same director' do
    context 'with valid director information' do
      it 'should call the model method to find movies with the same director' do
        Movie.should_receive(:find_similar).with("1").and_return(mock('Movie'))
        Movie.stub(:find)
        get :similar, {:id => 1}
      end 

      it 'should render the similar movies results page' do
        Movie.stub(:find_similar).and_return(mock('Movie'))
        Movie.stub(:find)
        get :similar, {:id => 1}
        response.should render_template('similar')
      end

      it 'should make the movie that was used to search available to the template' do
        fake_movie = mock('Movie')
        Movie.stub(:find_similar).and_return(fake_movie)
        Movie.stub(:find).and_return(fake_movie)
        get :similar, {:id => 1}
        assigns(:match_movie).should == fake_movie
      end

      it 'should make the search results available to the template' do
        fake_list = [mock('Movie'), mock('Movie')]
        Movie.stub(:find_similar).and_return(fake_list)
        Movie.stub(:find)
        get :similar, {:id => 1}
        assigns(:movies).should == fake_list
      end
    end

    context 'without valid director information' do
      it 'should render the index page' do
        alien = FactoryGirl.create(:movie, title: "Alien")
        Movie.stub(:find).and_return(alien)
        Movie.stub(:find_similar).and_return(nil)
        get :similar, {:id => 1}
        response.should redirect_to movies_path
      end
      
      it 'should provide an error message to the user' do
        alien = FactoryGirl.create(:movie, title: "Alien")
        Movie.stub(:find).and_return(alien)
        Movie.stub(:find_similar).and_return(nil)
        get :similar, {:id => 1}
        flash[:warning].should include("Alien")
      end
    end
  end
end
