#include "shell.h"

#define BACKSPACE (127)
#define ESC        (27)

/* shell command functions declaration */
static void help_menu();

static cmd_t shell_cmds[] = {
    {
        .name = "help",
        .des  = "This menu",
        .handler = help_menu
    }
};

#define CMD_AMOUNT sizeof(shell_cmds)/sizeof(cmd_t)

static void help_menu()
{
    int i = 0;
    printf("System supports Commands:\n\r");

    for (;i < CMD_AMOUNT; i++ ) {
        printf("%s\t\t%s\n\r", shell_cmds[i].name, shell_cmds[i].des);
    }
}

void shell_task( void *pvParameters )
{
    char str[CMD_BUF_SIZE];

    help_menu();

    while (1)
    {
        /* Show prompt */
        //printf("\n\r$ ");

    }
}

