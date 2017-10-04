/* 
    Friend Test!
    
    1. Compile and run to understand how it works
    2. Change the current questions
    3. Add at least one more 'nested if' question
       (Similar to Question 2)
    4. Add at least one more question with more than
       two answers
    5. Make sure your final score calculation reflects results

*/

#include <stdio.h>

int main(void)
{
    int score = 0;
    int answer = 0;
    
    printf("Would we be friends?\n");
    printf("Answer the following\n\n");
    
    //Question 1
    printf("Do you like dessert? (1. Yes, 2. No): ");
    scanf("%d", &answer);
    
    if( answer == 1)
    {
        score = score + 10;
    } else {
        score = score - 2;
    }
    
    //Question 2
    printf("Are you an active person? (1. Yes, 2. No): ");
    scanf("%d", &answer);
    
    if( answer == 1)
    {
        score = score + 5;
        
        //Question 2a
        printf("Do you like being active outdoors? (1. Yes, 2. No)\n");
        scanf("%d", &answer);
        
        if( answer == 1)
        {
            score = score + 5;
        }
        
    } else {
        score = score - 5;
    }
    
    //Question 3
    printf("Which of these is your favorite?\n");
    printf("1. Dogs\n");
    printf("2. Cats\n");
    printf("3. I don't care for animals\n");
    scanf("%d", &answer);
    
    if( answer == 1)
    {
        score = score + 10;
    } else if(answer == 2) {
        score = score +2;
    } else {
        score = score - 50;
    }
    
    // Results
    printf("Your score is %d\n", score);
    
    if(score == 30)
    {
        printf("Woooo! We would be great friends!\n\n");
    } else if(score > 0)
    {
        printf("You're alright, I guess.\n\n");
    } else {
        printf("Never speak to me again.\n\n");
    }
    
    return 0;
}