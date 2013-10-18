#ifndef __SHELL_H__
#define __SHELL_H__

#define CMD_BUF_SIZE 32
// #define CMD_AMOUNT 4

/* Enumeration of command types */
typedef enum {
    CMD_HELLO = 0,
    CMD_HELP,
    CMD_PS,
    CMD_ECHO
} CMD_TYPE;

/* Structure of Environment variables */
typedef struct {
} evar_entry;


typedef void (*cmd_func_t)(void);
/* Structure of Command type */
typedef struct {
    const char *name;   /* Command name */
    const char *des;    /* Command Description showed when help called */
    cmd_func_t handler; /* Command function handler */
} cmd_t;

void shell_task( void *pvParameters );

#endif
