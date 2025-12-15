#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <string.h>
#include <getopt.h>

#define SERIAL_PORT "/dev/ttyUSB2"
#define BAUDRATE    B115200

#define FRAC_BITS   7
#define SCALE       (1 << FRAC_BITS)
#define MAX_VAL     255.992f
#define MIN_VAL    -256.0f

#define OP_NOP   0
#define OP_ADD   1
#define OP_SUB   2
#define OP_MUL   3
#define OP_AND   4
#define OP_OR    5
#define OP_NOT   6
#define OP_XOR   7

static int setup_serial(const char *device) {
    int fd = open(device, O_RDWR | O_NOCTTY);
    if (fd < 0) { perror("open"); return -1; }

    struct termios options;
    tcgetattr(fd, &options);
    options.c_cflag = BAUDRATE | CS8 | CLOCAL | CREAD;
    options.c_iflag = IGNPAR;
    options.c_oflag = 0;
    options.c_lflag = 0;
    tcflush(fd, TCIFLUSH);
    tcsetattr(fd, TCSANOW, &options);
    return fd;
}

uint16_t float_to_fixed16(float x) {
    if (x > MAX_VAL) x = MAX_VAL;
    if (x < MIN_VAL) x = MIN_VAL;
    int32_t fixed = (int32_t)(x * SCALE + (x >= 0 ? 0.5f : -0.5f));
    return (uint16_t)fixed;
}

float fixed16_to_float(uint16_t val) {
    return ((int16_t)val) / (float)SCALE;
}

int ASM(uint8_t Opcode, uint16_t a, uint16_t b, int fd) {
    uint8_t txbuf[5] = {
        Opcode,
        (a >> 8) & 0xFF, a & 0xFF,
        (b >> 8) & 0xFF, b & 0xFF
    };
    return !(write(fd, txbuf, 5) == 5);
}

int main(int argc, char *argv[]) {
    int opcode = -1;
    char *a_str = NULL, *b_str = NULL;

    int opt;
    while ((opt = getopt(argc, argv, "o:a:b:")) != -1) {
        switch(opt) {
            case 'o': opcode = atoi(optarg); break;
            case 'a': a_str = optarg; break;
            case 'b': b_str = optarg; break;
        }
    }

    if (opcode < 0 || !a_str) {
        fprintf(stderr, "Usage: ./main -o <opcode> -a <value> -b <value>\n");
        return 1;
    }

    uint16_t a_fixed = 0, b_fixed = 0;

    if (opcode >= OP_ADD && opcode <= OP_MUL) {
        float a = atof(a_str);
        float b = atof(b_str);
        a_fixed = float_to_fixed16(a);
        b_fixed = float_to_fixed16(b);

    } else if (opcode >= OP_AND && opcode <= OP_XOR) {
        a_fixed = (uint16_t)strtol(a_str, NULL, 16);
        b_fixed = b_str ? (uint16_t)strtol(b_str, NULL, 16) : 0;
    }

    int fd = setup_serial(SERIAL_PORT);
    if (fd < 0) return 1;

    int status = ASM(opcode, a_fixed, b_fixed, fd);
    if (status) return 1;

    uint8_t c_hi, c_lo;
    if (read(fd, &c_hi, 1) != 1) return 1;
    if (read(fd, &c_lo, 1) != 1) return 1;

    uint16_t c_fixed = (c_hi << 8) | c_lo;

    if (opcode >= OP_ADD && opcode <= OP_MUL)
        printf("%.3f\n", fixed16_to_float(c_fixed));
    else
        printf("0x%04X\n", c_fixed);
	// Add binary output for Web UI
	printf("BINARY16=%016b\n", c_fixed);

    close(fd);
    return 0;
}
