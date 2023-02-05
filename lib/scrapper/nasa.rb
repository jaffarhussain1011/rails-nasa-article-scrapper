module Scrapper
    class Nasa
        attr_accessor :url ,:conn,:article_no,:article

        def initialize()
            @url = "https://www.nasa.gov"
            @conn = Faraday.new(:url => @url) do |faraday|
                faraday.use FaradayMiddleware::FollowRedirects
                faraday.ssl.verify = false
            end
        end
        # '/press-release/nasa-industry-to-collaborate-on-space-communications-by-2025'
        def fetch(uri)
            @response = @conn.get(uri)
            if(@response.status == 200)
                self.parseArticleNumber
                if(@article_no)
                    @response = conn.get("/api/2/ubernode/#{@article_no}")
                    self.parseArticle
                end
            end

            @article
        end

        def parseArticleNumber
            document = Nokogiri::HTML(@response.body)
            body_attributes = document.at("body").to_h
            @article_no = nil
            body_attributes['class'].split('page-node-').map do |attr|
                article_no = attr.gsub(/\D/, '').strip
                if(article_no)
                    @article_no = article_no
                end
            end
        end

        def parseArticle
            parsed_json = JSON.parse(@response.body)["_source"]
            @article = {
                title: parsed_json["title"],
                date: Date.parse(parsed_json["promo-date-time"]).strftime('%Y-%m-%d'),
                release_no: parsed_json["release-id"],
                article: parsed_json["body"]
            }
        end
    end
    
end