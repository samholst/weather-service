class PagesController < ApplicationController

  # For the search purpose, I'm not adding in user verification,
  # rather I'm making a public access page to view all weather
  # with no authentication or authorization.
  def home
  end
end
