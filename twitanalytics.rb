#
# twitanalytics.rb
#
#command line ruby script to provide basic Twitter analytics 
#(using one of the existing ruby Twitter libraries to do the heavy lifting behind the scenes). 
#This would take as parameters a Twitter search string (e.g. "rails magazine") and will output:
#- the number of times the search string was mentioned
#- the number of people mentioning it
#- the sum of followers for the people who mentioned it
#The intent is to write this in a cron job (daily?) to be able to track our popularity over time. 
#Right now go to this page regularly: http://search.twitter.com/search?q=((ruby+OR+rails)+(magazine+OR+mag))+OR+railsmagazine
#but it would be nice if we had a way to generate these numbers automatically.  
#Then we can use the output to generate some graphs to gain a better insight in how we're doing on Twitter 
#(for traditional web analytics, Google Analytics does a good job).
#As long as we keep the query search as a parameter or in a config file, I can see this as a useful tool for other projects too - 
#and we can publish the script with some derived graphs in a future issue.  
# 
# PreRequisites:
# gem install twitter     - help at http://twitter.rubyforge.org/rdoc/
# gem install sparklines  - help at http://sparklines.rubyforge.org/

require "twitter"
require 'rubygems'
require 'sparklines'

# constants and parameters
twitter_username = ""  ## get this via console input
twitter_password = ""  ## get this via console input

# twitter search method
def twitter_search(skeyword, rec_per_page)
    recs_found = 0
    
    Twitter::Search.new(skeyword).per_page(rec_per_page).each do |r|
      #puts r.inspect
      #puts "@" + r.from_user + ": " + r.text
      #puts "at " + r.created_at
      #puts "......................................................................"
      #puts
      recs_found = recs_found + 1
    end
    recs_found
end

def generate_graph(pOutputfile, graphType, arrData)
  # plot the graph and write out to a file   
  Sparklines.plot_to_file(pOutputfile, arrData,
                          :type => graphType, 
                          :height => 50)  
end

def chart_twits(no_of_days, pGraphType)
  search_keyword = "((ruby OR rails) (magazine OR mag)) OR railsmagazine"
  sinceDate = (DateTime::now() - no_of_days)
  records_per_page = 100
  total_found = 0
  pGraphfile = "c:\\users\\rupak\\pictures\\twitgraph-" + pGraphType + ".jpg"
  
  week_recs = [0,0,0,0,0,0,0]  # init an array to 7 items to represent 7 days' data
  
  no_of_days.times { |i|
    total_found = 0
    # move the date range 1 day ahead to calculate the no. of hits for that day
    untilDate = sinceDate
    
    dateCriteria = " since:" + sinceDate.strftime('%Y-%m-%d').to_s + " until:" + untilDate.strftime('%Y-%m-%d').to_s
    skeyword_withdate = search_keyword + dateCriteria 
    puts "~~~~~~~ Keyword: " + skeyword_withdate + " ~~~~~~~~"
    
    # do the search and get the hits
    total_found = twitter_search(skeyword_withdate, records_per_page)
    week_recs[i] = total_found
    puts "~~~~~~~ Total hits: " + total_found.to_s + ", records per page: " + records_per_page.to_s + " ~~~~~~~~"
    
    # increment the day
    sinceDate = sinceDate + 1
  
  }
  puts
  puts "Generating a " + pGraphType + " chart for past " + no_of_days.to_s + " day till today..."
  generate_graph(pGraphfile, pGraphType, week_recs)
  puts "Graph image saved at " + pGraphfile
end

#############################################################################################################
# main program
chart_types = ['area', 'discrete', 'pie', 'smooth', 'bar', 'whisker']
chart_types.each { |ct|
  # generate chart for past 30 days till today
  chart_twits(30, ct)
}