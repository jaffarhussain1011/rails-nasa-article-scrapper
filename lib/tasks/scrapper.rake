require 'faraday_middleware'
require 'scrapper/nasa'
namespace :scrapper do
    @url = "https://www.nasa.gov"
    desc "Scrap Article"
    task :nasa do
        uri = '/press-release/nasa-industry-to-collaborate-on-space-communications-by-2025'
        article = Scrapper::Nasa.new.fetch(uri)
        pp article
    end
end
