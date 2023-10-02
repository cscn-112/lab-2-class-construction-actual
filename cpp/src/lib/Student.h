#pragma once

#include <string>

class StudentType
{
public:
    std::string last_name;

    StudentType();
    StudentType(std::string student_first_name);

    std::string get_first_name();
    void set_first_name(std::string spaghetti);

    void display_first_name();

private:
    std::string first_name;
};
