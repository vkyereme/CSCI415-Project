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
size_t result = 1000 * sizeof(float);

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


__global__ void parallel_passwordCrack(int length,int*d_output,int* a, long attempts)
{	
	int idx = blockDim.x * blockIdx.x + threadIdx.x;
	bool cracked = false;
	int mark=0;
        char alphabetTable[] = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' };        
	int newB[1000]; 
 
char alph;	
 
while(!cracked){

	alph = alphabetTable[rand()%26];
	d_output[idx] = int(alph);
	__syncthreads();
	for(int i = 0; i<length; i++){
		if(d_output[i] != a[i])
		{
			cracked = false;
		}
		else{
		cracked = true;
		}

	}

  }
    

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
long attempts; //number of attempts to crack the password
int *d_input = (int *) malloc(result);

cout << "Enter a password length: ";
cin >> length;
int *h_gpu_result = (int*)malloc(1000*sizeof(int));

srand(time(NULL));
cout << "Random generated password: " << endl;
for (int i =0; i<length; i++){
    
        random = alphabet[(rand()%26)]; 
    
    a[i] = random; //adding random password to array
    cout << char(a[i]);
}cout << "\n" << endl;

//declare GPU memory pointers
  int *d_output;
//allocate GPU memory
  cudaMalloc((void **) &d_output,1000*sizeof(int));
  cudaMalloc((void **) &d_input, result);

cudaError_t err = cudaSuccess;
//transfer the array to the GP
err = cudaMemcpy(d_input, a, result,cudaMemcpyHostToDevice);
 if(err != cudaSuccess)
  {
    fprintf(stderr, "Failed to copy d_S from host to device (error code %s)!\n", cudaGetErrorString(err));
      exit(EXIT_FAILURE);
  }

//launch the kernel
int threads =1;
parallel_passwordCrack<<<1,threads>>>(length,d_output,d_input,attempts);
//copy back the result array to the CPU
cudaMemcpy(h_gpu_result,d_output,1000*sizeof(int),cudaMemcpyDeviceToHost);

cout << "Serial Password Cracked: " << endl;
serial_passwordCrack(length);
cout << "\n";
for(int i=0; i<length; i++){
    cout << char(b[i]);
}
cout << "\nNumber of tries: " << tries << endl;

cout << "\nParallel Password Cracked: " << endl;
for(int i=0; i<length; i++){
	printf("%c\n", char(h_gpu_result[i]));
}
cout << "\nNumber of attempts: " << attempts << endl;

cudaFree(d_output);
cudaFree(d_input);
free(h_gpu_result);

return 0;
}
