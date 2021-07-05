#pragma once

#include <iostream>

class Time_Provider
{
private:
	Time_Provider() = delete;
	~Time_Provider() = delete;
	Time_Provider(const Time_Provider& other) = delete;
public:
	static time_t Get_Current_Time() { return time(NULL); }
};