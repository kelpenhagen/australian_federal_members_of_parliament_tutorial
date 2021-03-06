# This is a template for a Ruby scraper on morph.io (https://morph.io)
# including some code snippets below that you should find helpful

require 'scraperwiki'
require 'mechanize'

agent = Mechanize.new

# Read in a page
base_url = "http://www.aph.gov.au/Senators_and_Members/Parliamentarian_Search_Results?q=&mem=1&sen=1&par=-1&gen=0&ps=100&st=1&page="

["1", "2", "3"].each do |number|
  page = agent.get(base_url + number)

  page.at(".search-filter-results").search(:li).each do |li|
    dts = li.at(:dl).search(:dt)

    record = {
      name: li.at(".title").inner_text,
      party: dts.select { |dt| dt.inner_text == "Party" }.first.next.inner_text,
      electorate: dts.select { |dt| dt.inner_text =~ /for/ }.first.next.next.inner_text
    }

    puts "Saving record for #{record[:name]}..."
    ScraperWiki.save_sqlite([:name], record)
  end
end

puts "Done."

# # Find somehing on the page using css selectors
# p page.at('div.content')

# # Write out to the sqlite database using scraperwiki library
# ScraperWiki.save_sqlite(["name"], {"name" => "susan", "occupation" => "software developer"})

# # An arbitrary query against the database
# ScraperWiki.select("* from data where 'name'='peter'")

# # You don't have to do things with the Mechanize or ScraperWiki libraries.
# # You can use whatever gems you want: https://morph.io/documentation/ruby
# # All that matters is that your final data is written to an SQLite database
# # called "data.sqlite" in the current working directory which has at least a table
# # called "data".
