#include "fio.h"
#include "string.h"
#include "util.h"
#include "unit_test.h"

void unit_test_task(void *pvParameters)
{
    char msg1[] = "Start Unit Testing\n\r";
    char msg2[128] = "Start String testing\n\r";
    /* test file system */
    fio_write(1, msg1, strlen(msg1));
    /* test puts() */
    puts(msg2);
    /* test strcmp */
    if ( strcmp(msg1,msg2)) {
        puts("[Ok] msg1 ~= msg2\n\r");
    } else {
        puts("strcpy result is not match\n\r");
    }
    /* test printf */
    printf("test htoi(255):%s\n\r", htoa(255));
    printf("test atoi(100):%s\n\r", itoa(100));
    printf("\n");
}
