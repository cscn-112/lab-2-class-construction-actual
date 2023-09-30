#include <iostream>
#include "Student.h"

int main()
{
    StudentType liberty_student;

    liberty_student.set_first_name("Benjamin");
    liberty_student.last_name = "Laird";

    liberty_student.display_first_name();
    std::cout << " ";
    std::cout << liberty_student.last_name;

    return 0;
}
