#include <format>
#include <iostream>
#include <string>
#include <string_view>
#include <queue>
#include <thread>
#include <mutex>
#include <stdlib.h>
#define SYSTEMS 3
#define LINES 5

using namespace std;
class Logger {
public:
	void log_one_line(int tsk, string s) {
		locks[tsk].lock();
		logs[tsk].push(s);
		locks[tsk].unlock();
		for (int i=0; i<SYSTEMS; i++) {
			locks[i].lock();
			if (logs[i].size() == 0) {
				for (int j=0; j<=i; j++) 
					locks[j].unlock();
				return;
			}
		}
		for (int i=0; i<SYSTEMS; i++) {
			cout << logs[i].front();
			logs[i].pop();
			locks[i].unlock();
		}
	}
private:
		queue<string> logs[SYSTEMS];
		mutex locks[SYSTEMS];
};
void task(int tsk, Logger *logger) {
	for (int i=0; i<LINES; i++) {
		sleep(random() % 2);
		logger->log_one_line(tsk, std::format("Task Id: {}, Line: {}\n", tsk, i));
	}
}
int main() {
	Logger *logger = new Logger();
	thread *thrd[3];
	for (int i=0; i<SYSTEMS; i++) {
		thrd[i] = new thread(task, i, logger);
	}
	for (int i=0; i<SYSTEMS; i++) {
		thrd[i]->join();
		delete thrd[i];
	}
	delete logger;
	return 0;
}
