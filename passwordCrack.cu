#include<iostream>
#include<cstring>
#include<ctime>
#include<cstdlib>
using namespace std;

int main()
{
int a[1000]; //array of all possible password characters
int length; //length of password
int random; //random password to be generated
int b[1000] = { 48 }; //array of attempted password cracks
unsigned long long tries = 0;
bool cracked = false;

cout << "Enter a password length: ";
cin >> length;

srand(time(NULL));
for (int i =0; i<length; i++){
    
        random = (rand()%75)+48; //whatever the random number is 
        //when mod 94(printable characters), the result is never more 
        //than adding 33 non-printing characters to get 
        //128 total characters on the ASCII table
        //rand() gives an integer from 0 to max (32767)
    
    a[i] = random; //adding random password to array
    cout << char(a[i]);
}cout << endl;

do{
    b[0]++;
    for(int i =0; i<length; i++){
        if (b[i] >= 75 + 48){ //if the index in b array is more than 127 characters
            b[i] -= 75; //then decrement it so that the index in b array can be less than 94
                  //printable characters
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

cout << "\r       \n";
for(int i=0; i<length; i++)
    cout << char (b[i]);
cout << "\nNumber of tries: " << tries << endl;

return 0;
}
