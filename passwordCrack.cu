#include<iostream>
#include<string>
#include<cstring>
#include<ctime>
#include<cstdlib>
#include<sys/time.h>
#include<stdio.h>
#include<iomanip>

using namespace std;

int a[1000]; //array of all possible password characters
int b[1000]; //array of attempted password cracks
unsigned long long tries = 0;
char alphabet[] = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' };


void serial_passwordCrack(int length){
bool cracked = false;
do{
    b[0]++;
    for(int i =0; i<length; i++){
        if (b[i] >= 26 + alphabet[i]){ 
            b[i] -= 26; 
            b[i+1]++;
        }else break;
    }
    cracked=true;
    for(int k=0; k<length; k++)
        if(b[k]!=a[k]){
            cracked=false;
            break;
        }
    if( (tries & 0x7ffffff) == 0 )
        cout << "\r       \r   ";
    else if( (tries & 0x1ffffff) == 0 )
        cout << ".";
    tries++;
}while(cracked==false);

}


__global__ void parallel_passwordCrack(int length)
{

}


long long start_timer() {
	struct timeval tv;
	gettimeofday(&tv, NULL);
	return tv.tv_sec * 1000000 + tv.tv_usec;
}


// Prints the time elapsed since the specified time
long long stop_timer(long long start_time, std::string name) {
	struct timeval tv;
	gettimeofday(&tv, NULL);
	long long end_time = tv.tv_sec * 1000000 + tv.tv_usec;
        std::cout << std::setprecision(5);	
	std::cout << name << ": " << ((float) (end_time - start_time)) / (1000 * 1000) << " sec\n";
	return end_time - start_time;
}



int main()
{
int length; //length of password
int random; //random password to be generated

cout << "Enter a password length: ";
cin >> length;


srand(time(NULL));
cout << "Random generated password: " << endl;
for (int i =0; i<length; i++){
    
        random = alphabet[(rand()%26)]; 
    
    a[i] = random; //adding random password to array
    cout << char(a[i]);
}cout << "\n" << endl;
cout << "Serial Password Cracked: " << endl;
serial_passwordCrack(length);
cout << "\n";
for(int i=0; i<length; i++){
    cout << char(b[i]);
}cout << "\nNumber of tries: " << tries << endl;

return 0;
}
