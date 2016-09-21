# Kaitlyn Dornbier    GoPro coding qualification
# parsing.rb          March 20th, 2015

# Initially, make sure file available for parsing
if(ARGV[0] != nil)
    
    # Part 1: wc in Ruby
    # Output: newline_count word_count byte_coute filename
    
    # Open file for initial word count
    file = File.open(ARGV[0])

    linecount = 0
    wordcount = 0

    # For each line, increase line count and find number of words
    file.readlines.each do |line|
        linecount += 1
        wordcount += line.split.count
    end

    # Output linecount, wordcount, bytecount (file size), and filename
    printf("all: %d %d %d %s\n", linecount, wordcount, file.size, ARGV[0])

    file.rewind
    
    # Part 2: proper wc in Ruby
    # Output: proper newline_count word_count byte_coute
    
    # For Part 2, assume improper words do not include changes to capitalization
    
    # Reinitialize variables for proper count
    # Assume proper linecount will not change
    # Assume bytecount means bytes excluding improper words

    wordcount = 0
    bytecount = 0
    
    # I know my regex's are just...so gross, but I'm shaking the dust off
    file.readlines.each do |line|
        # Delete improper words in word and byte count
        line.gsub!(/(\bI\b|\bWe\b|\bYou\b|\bThey\b|\ba\b|\band\b|\bthe\b|\bthat\b|\bof\b|\bfor\b|\bwith\b)/,'')
        wordcount += line.split.count
        bytecount += line.length
    end

    printf("proper: %d %d %d\n", linecount, wordcount, bytecount)

    file.rewind

    # Part 3: Total Articles and Sections per articles
    # Totals of each first
    
    sectioncount = 0
    articlecount = 0
    file.readlines.each do |line|
        
        # Highest article number will be total count
        if( line.scan(/\bArticle\b\s(\d+)/).size > 0 )
            articlecount = line.match(/\bArticle\b\s(\d+)/)[1]
        end
        
        # Must manually count up sections from different articles
        if( line.scan(/\bSection\b\s(\d+)/).size > 0 )
            sectioncount += 1
        end
        
    end
    
    printf("Total Articles: %d\n", articlecount)
    printf("Total Sections: %d\n", sectioncount)
    
    file.rewind
    
    printf("Total Sections per Article:\n")
    
    sectioncount = 0
    # Again, just the ugliest regex ever - I'm sure there's an easier way
    line = file.readline
    while !file.eof?
        
        # For every new article found, print the last section count
        if( line.scan(/\bArticle\b\s(\d+)/).size > 0 )
            # Don't print the section count if we've just reached 1st Article
            if(line.match(/\bArticle\b\s(\d+)/)[1].to_i > 1)
                puts sectioncount
            end
            
            printf("%s: ", line.match(/\bArticle\b\s(\d+)/))
            sectioncount = 0
        end
        
        # Keep track of section count
        if( line.scan(/\bSection\b\s(\d+)/).size > 0 )
            sectioncount = line.match(/\bSection\b\s(\d+)/)[1]
        end
        
        line = file.readline
        
    end
    
    # Poor Article 7 (or any further articles) would need a section count
    puts sectioncount
        
    file.close

else
    puts "Error: No file input for parsing"
end