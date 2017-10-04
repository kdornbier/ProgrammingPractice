#include <stdio.h>

int main(void)
{
	double x = 0; 
	double y = 0;
	double z = 0;
	
	// Prompt for values from user
	printf("Enter a value for x: ");
	scanf("%lf", &x);
	printf("Enter a value for y: ");
	scanf("%lf", &y);
	
	// Basic math output to terminal
	z = x / y;
	printf("z = %f\n", z);
	printf("x / y = %f\n", x / y);
	printf("%f * %f = %f\n", x, y, z);
	
	return 0;
	
}