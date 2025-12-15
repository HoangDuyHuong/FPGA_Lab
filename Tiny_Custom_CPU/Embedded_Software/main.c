#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>

#define SERIAL_PORT "/dev/ttyUSB2"
#define BAUDRATE    B115200

// Fixed-point 16-bit: 1 sign, 8 integer, 7 fractional
#define FRAC_BITS   7
#define SCALE       (1 << FRAC_BITS)
#define MAX_VAL     255.992f
#define MIN_VAL    -256.0f

#define OP_NOP		    0
#define OP_ADD		    1
#define OP_SUB		    2
#define OP_MUL		    3
#define OP_AND		    4
#define OP_OR		    5
#define OP_NOT		    6
#define OP_XOR		    7

int fd;

static int setup_serial(const char *device) {
    int fd = open(device, O_RDWR | O_NOCTTY);
    if (fd < 0) {
        perror("open");
        return -1;
    }

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

// Print 16-bit binary
void print_binary16(uint16_t val) {
    for (int i = 15; i >= 0; i--)
        printf("%d", (val >> i) & 1);
}

// float → fixed16 (signed 16-bit)
uint16_t float_to_fixed16(float x) {
    if (x > MAX_VAL) x = MAX_VAL;
    if (x < MIN_VAL) x = MIN_VAL;

    int32_t fixed = (int32_t)(x * SCALE + (x >= 0 ? 0.5f : -0.5f));
    return (uint16_t)fixed;
}

// fixed16 → float
float fixed16_to_float(uint16_t val) {
    int16_t s = (int16_t)val;   // sign-extend
    return (float)s / SCALE;
}

// ASM Declaration

int NOP(uint16_t a) {
    
	uint8_t a_hi = (a >> 8) & 0xFF;
    uint8_t a_lo = a & 0xFF;

    uint8_t b_hi = 0;
    uint8_t b_lo = 0;

    uint8_t txbuf[5] = {OP_NOP, a_hi, a_lo, b_hi, b_lo};
    if (write(fd, txbuf, 5) != 5) {
        perror("write");
        close(fd);
        return 1;
    }
}

int ADD(uint16_t a, uint16_t b) {
    
	uint8_t a_hi = (a >> 8) & 0xFF;
    uint8_t a_lo = a & 0xFF;

    uint8_t b_hi = (b >> 8) & 0xFF;
    uint8_t b_lo = b & 0xFF;

    uint8_t txbuf[5] = {OP_ADD, a_hi, a_lo, b_hi, b_lo};
    if (write(fd, txbuf, 5) != 5) {
        perror("write");
        close(fd);
        return 1;
    }
}

int SUB(uint16_t a, uint16_t b) {
    
	uint8_t a_hi = (a >> 8) & 0xFF;
    uint8_t a_lo = a & 0xFF;

    uint8_t b_hi = (b >> 8) & 0xFF;
    uint8_t b_lo = b & 0xFF;

    uint8_t txbuf[5] = {OP_SUB, a_hi, a_lo, b_hi, b_lo};
    if (write(fd, txbuf, 5) != 5) {
        perror("write");
        close(fd);
        return 1;
    }
}

int MUL(uint16_t a, uint16_t b) {
    
	uint8_t a_hi = (a >> 8) & 0xFF;
    uint8_t a_lo = a & 0xFF;

    uint8_t b_hi = (b >> 8) & 0xFF;
    uint8_t b_lo = b & 0xFF;

    uint8_t txbuf[5] = {OP_MUL, a_hi, a_lo, b_hi, b_lo};
    if (write(fd, txbuf, 5) != 5) {
        perror("write");
        close(fd);
        return 1;
    }
}

int AND(uint16_t a, uint16_t b) {
    
	uint8_t a_hi = (a >> 8) & 0xFF;
    uint8_t a_lo = a & 0xFF;

    uint8_t b_hi = (b >> 8) & 0xFF;
    uint8_t b_lo = b & 0xFF;

    uint8_t txbuf[5] = {OP_AND, a_hi, a_lo, b_hi, b_lo};
    if (write(fd, txbuf, 5) != 5) {
        perror("write");
        close(fd);
        return 1;
    }
}

int OR(uint16_t a, uint16_t b) {
    
	uint8_t a_hi = (a >> 8) & 0xFF;
    uint8_t a_lo = a & 0xFF;

    uint8_t b_hi = (b >> 8) & 0xFF;
    uint8_t b_lo = b & 0xFF;

    uint8_t txbuf[5] = {OP_OR, a_hi, a_lo, b_hi, b_lo};
    if (write(fd, txbuf, 5) != 5) {
        perror("write");
        close(fd);
        return 1;
    }
}

int NOT(uint16_t a) {
    
	uint8_t a_hi = (a >> 8) & 0xFF;
    uint8_t a_lo = a & 0xFF;

    uint8_t b_hi = 0;
    uint8_t b_lo = 0;

    uint8_t txbuf[5] = {OP_NOT, a_hi, a_lo, b_hi, b_lo};
    if (write(fd, txbuf, 5) != 5) {
        perror("write");
        close(fd);
        return 1;
    }
}

int XOR(uint16_t a, uint16_t b) {
    
	uint8_t a_hi = (a >> 8) & 0xFF;
    uint8_t a_lo = a & 0xFF;

    uint8_t b_hi = (b >> 8) & 0xFF;
    uint8_t b_lo = b & 0xFF;

    uint8_t txbuf[5] = {OP_XOR, a_hi, a_lo, b_hi, b_lo};
    if (write(fd, txbuf, 5) != 5) {
        perror("write");
        close(fd);
        return 1;
    }
}

int ASM(uint8_t Opcode, uint16_t a, uint16_t b) {
    
	uint8_t a_hi = (a >> 8) & 0xFF;
    uint8_t a_lo = a & 0xFF;

    uint8_t b_hi = (b >> 8) & 0xFF;
    uint8_t b_lo = b & 0xFF;

    // Gửi lần lượt Opcode, A_hi, A_lo, B_hi, B_lo
    uint8_t txbuf[5] = {Opcode, a_hi, a_lo, b_hi, b_lo};
    if (write(fd, txbuf, 5) != 5) {
        perror("write");
        close(fd);
        return 1;
    }
}
////

int main(void) {
	uint8_t opcode;
    float a, b;
	int valid;
	while(1){
		printf("Enter Opcode ");
		if (scanf("%hhd", &opcode) != 1) { printf("Invalid a\n"); return 1; }
		
		// if (opcode > OP_XOR || a < OP_NOP) {
			// fprintf(stderr, "Error: Opcode values must be between %d and %d\n", OP_NOP, OP_XOR);
			// return 1;
		// }
		
		printf("Enter a (-256 to 255.992): ");
		if (scanf("%f", &a) != 1) { printf("Invalid a\n"); return 1; }
	
		printf("Enter b (-256 to 255.992): ");
		if (scanf("%f", &b) != 1) { printf("Invalid b\n"); return 1; }
	
		if (a > MAX_VAL || a < MIN_VAL || b > MAX_VAL || b < MIN_VAL) {
			fprintf(stderr, "Error: values must be between %.3f and %.3f\n", MIN_VAL, MAX_VAL);
			return 1;
		}
	
		uint16_t a_fixed = float_to_fixed16(a);
		uint16_t b_fixed = float_to_fixed16(b);
		
		printf("\n Opcode: %d\n", opcode);
		
		printf("\nEncoded fixed-point values (16-bit):\n");
	
		printf("a = %.3f → 0x%04X → ", a, a_fixed);
		print_binary16(a_fixed);
		printf("\n");
	
		printf("b = %.3f → 0x%04X → ", b, b_fixed);
		print_binary16(b_fixed);
		printf("\n");
	
		fd = setup_serial(SERIAL_PORT);
		if (fd < 0) return 1;
	
		// // Split into High-byte / Low-byte
		// uint8_t a_hi = (a_fixed >> 8) & 0xFF;
		// uint8_t a_lo = a_fixed & 0xFF;
	
		// uint8_t b_hi = (b_fixed >> 8) & 0xFF;
		// uint8_t b_lo = b_fixed & 0xFF;
	
		// // Gửi lần lượt A_hi, A_lo, B_hi, B_lo
		// uint8_t txbuf[4] = {a_hi, a_lo, b_hi, b_lo};
		// if (write(fd, txbuf, 4) != 4) {
			// perror("write");
			// close(fd);
			// return 1;
		// }
		// valid = ADD(a_fixed, b_fixed);
		valid = ASM(opcode, a_fixed, b_fixed);
		
		if(valid)
			printf("\nSuccess: Sent 4 bytes via UART (A_hi, A_lo, B_hi, B_lo)...\n");
		else	
			printf("\nFailed: Sent 4 bytes via UART (A_hi, A_lo, B_hi, B_lo)...\n");
	
		// Nhận lại C_hi và C_lo
		uint8_t c_hi, c_lo;
	
		if (read(fd, &c_hi, 1) != 1) { perror("read"); close(fd); return 1; }
		if (read(fd, &c_lo, 1) != 1) { perror("read"); close(fd); return 1; }
	
		uint16_t c_fixed = ((uint16_t)c_hi << 8) | c_lo;
		float c = fixed16_to_float(c_fixed);
	
		printf("\nReceived C (16-bit):\n");
		printf("c = %.3f → 0x%04X → ", c, c_fixed);
		print_binary16(c_fixed);
		printf("\n");
	}

    close(fd);
    return 0;
}
