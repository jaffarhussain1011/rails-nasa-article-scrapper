module Scrapper
    class Judgement
        attr_accessor :pdf_reader, :raw_content

        def initialize(file_path)
            @pdf_reader = PDF::Reader.new(file_path)
            @raw_content = @pdf_reader.pages.first.text
        end
        
        def valid?
            @raw_content.index('Judgment for Cost') and @raw_content.index('Appointed Attorney')
        end

        def petitioner
            start=state
            endd=","
            @raw_content[/#{start}(.*?)#{endd}/m, 1].strip
        end

        def state
            supreme_court = @raw_content.split("\n").first.strip
            supreme_court.split("of the").last.strip
        end

        def amount
            currency = "$"
            start="\\#{currency}"
            endd=" "
            amount = @raw_content[/#{start}(.*?)#{endd}/m, 1].strip
            amount = amount.chop if amount[-1]==','
            ["#{currency}",amount].join
        end

        def date
            start=': '
            endd="\n"
            text = @raw_content[/#{start}(.*?)#{endd}/m, 1].strip.split(" ").first 
            date = Date.strptime(text, "%m/%d/%y") rescue nil
            unless date
                date = Date.strptime(text, "%m/%d/%Y") rescue nil
            end
            date = date.strftime('%Y-%m-%d')  if date
        end
        
        def parse
            if valid?
                {
                    petitioner: petitioner,
                    state: state,
                    amount: amount,
                    date: date
                }
            end
        end
    end
    
end