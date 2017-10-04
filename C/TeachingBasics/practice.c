/* 
	ASCII Print to Screen Example
*/

#include <stdio.h>

int main(void)
{
	char example = '\\';
	
	// Examples of using tabs and newlines in print statements
	printf("   _____ ______ _   _ _____\n");
	
	printf("  / ___|  _____| \\ | |  ___ \\");
    printf("\n  | (_ | |__   |  \\| | |  | | \n");
	// Even if both %c's have same variable, have to have twice
	// Will explain special characters eventually, example will be one backslash
	printf("  %c__ %c|  __|  | . ` | |  | |", example, example);
	// Sometimes finding out what characters to 'escape' just takes trial and error
	printf("\n   __) | |_____| |\\  | |__| |\n");
	printf(" |____/|_______|_| \\_|_____/");
	
	printf("\n _   _ _    _ _____  ______  _____ \n");
	// It's good practice to break up long print lines into shorter text
	// Both for the code and the printout
	printf(" |\\ | | |  | |  __ \\|  ____|/ ____|\n");
	//Note: An empty printout, like below wont print anything
	printf("");
	printf(" | \\| | |  | | |  | | |__  | (___  ");
	// Sometimes JUST printing a newline makes the printout easier to read
	printf("\n");
	// Instead of this really long, hard-to-read-line
	printf(" | .` | |  | | |  | |  __|  %c___ \\ \n | |\\ | |__| | |__| | |____ ____) |\n |_| \\|\\____/|_____/|______|_____/\n", example);
	
	
	return 0;
}