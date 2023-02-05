require "test_helper"

class NasaScrapperControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get nasa_scrapper_index_url
    assert_response :success
  end
end
