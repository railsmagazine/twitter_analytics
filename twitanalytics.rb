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
# gem install twitter

require "twitter"

# constants and parameters
twitter_username = ""  ## get this via console input
twitter_password = ""  ## get this via console input
search_keyword = "((ruby OR rails) (magazine OR mag)) OR railsmagazine"  ## get this via console input
total_found = 0

# twitter search method
def twitter_search(skeyword)
  recs_found = 0
  
  Twitter::Search.new(skeyword).each do |r|
    #puts r.inspect
    #puts "* " + r.text + " | by [" + r.from_user + "] at [" + r.created_at + "]"
    puts "@" + r.from_user + ": " + r.text
    #puts "about " + (DateTime::now() - DateTime.new(r.created_at.to_date)).to_s() + " ago from " + r.source
    puts "at " + r.created_at
    puts "......................................................................"
    puts
    recs_found = recs_found + 1
  end
  recs_found
end

#############################################################################################################
# main program
puts "~~~~~~~~~~~~~~~~~~~~~~~~~ Keyword: " + search_keyword + " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
puts
total_found = twitter_search(search_keyword)
puts
puts "~~~~~~~~~~~~~~~~~~~~~~~~~ Total tweets: " + total_found.to_s + " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"


