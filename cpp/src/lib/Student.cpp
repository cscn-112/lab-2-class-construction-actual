#include <string>
#include <iostream>

#include "Student.h"

StudentType::StudentType()
{
    first_name = "";
    last_name = "";
}
StudentType::StudentType(std::string student_first_name)
{
    first_name = student_first_name;
}

std::string StudentType::get_first_name()
{
    return first_name;
}
void StudentType::set_first_name(std::string spaghetti)
{
    first_name = spaghetti;
}

void StudentType::display_first_name()
{
    std::cout << get_first_name();
}
