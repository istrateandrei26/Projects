#pragma once

#include "ILog.h"
#include <string>


class  Log : public ILog{

public:
	Log(const char* filename = "Log.txt");
	virtual ~Log() { ; }

	LOGLIBRARY_API virtual void SetLevel(Levels level) override;

protected:
	Levels m_level;
	std::string m_filename;

	int m_index_col1 = 0;
	int m_index_col2 = 50;
	int m_index_col3 = 100;
};
