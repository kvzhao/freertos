#include "fio.h"
#include "unit_test.h"
void unit_test_task(void *pvParameters)
{
    char *msg = "\n\rStart Testing\n";
    fio_write(1, msg, sizeof(msg));
}
