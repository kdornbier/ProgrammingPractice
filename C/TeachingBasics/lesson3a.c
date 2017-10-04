/*
   Learning if statements
  
    == is equal to
    != is NOT equal to
    >  is greater than
    <  is less than
    >= is greater than OR equal to
    <= is less than OR equal to
    && and
    || or
  
    - The importance of brackets {}
      and parenthesis ()
      
    Important notes:
       1. NO semicolor after if(....) 
       2. Open AND close brackets for if/else
*/
#include <stdio.h>

int main(void)
{
    
    int num1 = 0;
    int num2 = 0;
    
    printf("Enter number 1: ");
    scanf("%d", &num1);
    printf("Enter number 2: ");
    scanf("%d", &num2);
    
    // Basic if
    // Equals
    if(num1 == num2)
    {
        printf("The numbers are equal.\n");
    } 
    
    // Does not equal
    // Else 
    if(num1 != 2)
    {
        printf("Number 1 does not equal 2.\n");
    } else 
    {
        printf("Number 1 is equal to 2.\n");
    }
    

    // Greater than and less than
    // Else if
    if(num1 > num2)
    {
        printf("Number 1 is greater than number 2.\n");
    } else if (num1 < num2) {
        printf("Number 1 is less than number 2.\n");
    } else {
        printf("The numbers are equal.\n");
    }
    
    // Using math in if statements
    // Importance of parenthesis
    if(num1 < (2 * num2))
    {
        printf("Number 1 is less than twice number 2.\n");
    } else if ((num1 * num2) != 0)
    {
        // If num1 is zero, the first statement is true
        // and we wont know if either number is zero
        printf("Neither number is zero.\n");
    }
    
    // And statements
    if((num1 > 0) && (num2 > 0))
    {
        printf("Both numbers are positive.\n");
    } else {
        printf("At least one number is negative.\n");
    }
    
    // Or statements
    // Nonsense logic
    if((num1 == 2) || (num2 > 5))
    {
        printf("Number 1 is two, or number two is greater than 5.\n");
    }
    
    /*int sports = 1; // 1 is yes, 0 is no
    int basketball = 0;
    int soccer = 0;
    
    if (sports == 1)
    {
        if ( basketball == 1)
        {
            //likes sports and basektball
            printf("My favorite team is the bulls!");
        } else if ( soccer == 1)
        {
            //likes sports and soccer
            printf("My favorite team is the Fire");
        } 
        
        // Likes sports, not neccessarily bball or soccer
        printf("Go sports!");
    }*/
    
    
    // Mod operator - remainder of two numbers divided
    // Math logic 
    // 4 % 3 = 1
    // 5 % 2 = 1
    // 2 % 2 = 0
    // 5 % 3 = 2
    // 10 % 5 = 0
    // x % 2 == 0 means x is even
    // x % 2 == 1     x % 2 != 0 means x is odd
    
    if ( (num1 % num2) == 0 )
    {
        printf("Number 1 is a multiple of number 2.\n");
    }
    
    
/* */
}