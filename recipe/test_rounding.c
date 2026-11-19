#include <math.h>
#include "config.h"

int main(void)
{
    return rint(0.75) != 1.0 || rint(-0.75) != -1.0;
}
