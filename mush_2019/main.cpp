/*
  main.cpp

  Programme principal d'un exemple d'utilisation de parse_line()

  μsh --- un micro-shell
  Mini-projet de travaux pratiques pour le module "Systèmes d'exploitations" (X22I030)
  2018/2019, Université de Nantes.  
 */

#include <iostream>
#include <vector>
#include <unistd.h>
#include <string>
#include <cstring>
#include <sys/types.h>
#include <sys/wait.h>
#include <thread>
#include <mutex>
#include "parsing.hpp"

using namespace std;
mutex mut;


void *execCommandChar(char ** ch){
	mut.lock();
	execvp(ch[0],ch);
	mut.unlock();
}

void execCommand(command_t command){
	int i=0;
	char ** ch = new char*[command.front().size()+1];
		for (auto param : command) {
			strcpy(ch[i],command.front().c_str());
			i++;
		}
	thread t1 (execCommandChar, ch);
	t1.join();
}

int main(int argc, char *argv[])
{
	vector<compound_command_t> commands;
	parse_line("ls -l; rm * // touch toto; mkdir titi",commands);
	string text= "ls";
	//char ** ch = new char*[text.size()+1];
	//strcpy(ch[0],text.c_str());
	//cout << ch[0] << endl;
	execCommand(commands[0][0]);

/*
	for (auto compound_command : commands) {
		for (auto simple_command : compound_command) {
			for (auto param : simple_command) {
				cout << param;
			}
			cout << " // ";
		}
		cout << endl;
	}
*/
  return EXIT_SUCCESS;
}
