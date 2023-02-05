require 'faraday_middleware'
require 'scrapper/nasa'
require 'scrapper/judgement'


namespace :scrapper do
    desc "Scrap Article"
    task :nasa do
        uri = '/press-release/nasa-industry-to-collaborate-on-space-communications-by-2025'
        article = Scrapper::Nasa.new.fetch(uri)
        pp article
    end

    desc "Scrap Judgement"
    task :judgements do
        # file_path = File.join(Rails.root, 'lib','tasks', 'judgements', "17423_2019-07-08_N11.pdf")
        files = Dir.glob('lib/tasks/judgements/**/*').select { |e| File.file? e }
        files.each do |file_path|
            # puts file_path
            judgement = Scrapper::Judgement.new(file_path).parse
            puts judgement if judgement
        end
        # puts file_path
        # judgement = Scrapper::Judgement.new(file_path).parse
        # puts judgement
    end
end
