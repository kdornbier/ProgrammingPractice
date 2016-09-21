# dornbier_gopro
Created by Kaitlyn Dornbier
March 20, 2015

GoPro Summer Software Intern code qualification

Code qualification assignment to parse plain text.

Part 1:

	For the generic word count, I parsed the file line by line, counting each line and
	splitting each line to add to the word count.
	
	The generic word count output uses the tallied line count, word count, file size in
	place of counting individual bytes, and the filename.
	
Part 2:

	For the proper word count, I parsed the file line by line, deleting each of the 
	impropper words. I assumed the listed words were the only improper ones (instead of
	considering We/we, a/A, etc), mostly becuase my regular expression was already
	terribly ugly. From there, I considered line count the same as the generic word
	count, and bytecount the size of the file excluding the improper words.
	
	Final output for the word count was tallied line count, proper word count, and 
	proper word bytes.
	
Part 3:

	Scanning the article line by line, I assumed the largest Article # found would be 
	the total number of articles. Sections had to be tallied, because each article could
	have any number of sections. Final printout for that part was just the totals.
	
	For printing the total sections per article, more disastrous regex's were utilized.
	To avoid having to find the first Article and continue, I just kept track of the 
	highest section number found until stumbling upon another article. When another
	article was reached, I output the final section tally for the last article and 
	renewed the count. Not the most brilliant approach, but I got all excited when it 
	worked anyway!
	
Thank you so, so much for the opportunity to interview with GoPro - I love the product
and I'm certain the animated environment of the company would make for one fantastic
career experience, and some enthusiastic all-night code sessions such as the one I 
just finished with this code qualification!