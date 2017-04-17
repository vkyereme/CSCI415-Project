#include<iostream>
#include<cstring>
#include<ctime>
#include<cstdlib>
using namespace std;

int a[1000]; //array of all possible password characters
int b[1000]; //array of attempted password cracks
unsigned long long tries = 0;
int length; //length of password
char alphabet[] = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' };


void serial_passwordCrack(){
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


__global__ void parallel_passwordCrack()
{

}

int main()
{
int random; //random password to be generated

cout << "Enter a password length: ";
cin >> length;


srand(time(NULL));
for (int i =0; i<length; i++){
    
        random = alphabet[(rand()%26)]; 
    
    a[i] = random; //adding random password to array
    cout << char(a[i]);
}cout << endl;
serial_passwordCrack();
cout << "\n";
for(int i=0; i<length; i++)
    cout << char (b[i]);
cout << "\nNumber of tries: " << tries << endl;

return 0;
}
