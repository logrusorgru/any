// machine_size.c

#include <stdio.h>

#include <limits.h>
#include <float.h>

void separator(void);

int main(int argc, char const *argv[])
{

	// sizes
	int so_short, so_int, so_long, so_long_long,
		so_s_short, so_u_short,
		so_s_int, so_u_int,
		so_s_long, so_u_long,
		so_s_long_long, so_u_long_long,
		so_char,
		so_s_char, so_u_char,
		so_float,
		so_double,
		so_l_double;

	// integer
	short _short;
	int   _int;
	long  _long;
	long long _long_long;

	// signed/unsigned integer
	signed short _s_short;
	unsigned short _u_short;

	signed int _s_int;
	unsigned int _u_int;

	signed long _s_long;
	unsigned long _u_long;

	signed long long _s_long_long;
	unsigned long long _u_long_long;

	// symbol
	char   _char;

	// signed/unsigned char
	signed char _s_char;
	unsigned char _u_char;

	// float
	float  _float;
	double _double;

	// long double
	long double _l_double;

	so_short = sizeof(_short);
	so_int = sizeof(_int);
	so_long = sizeof(_long);
	so_long_long = sizeof(_long_long);
	so_s_short = sizeof(_s_short);
	so_u_short = sizeof(_u_short);
	so_s_int = sizeof(_s_int);
	so_u_int = sizeof(_u_int);
	so_s_long = sizeof(_s_long);
	so_u_long = sizeof(_u_long);
	so_s_long_long = sizeof(_s_long_long);
	so_u_long_long = sizeof(_u_long_long);
	so_char = sizeof(_char);
	so_s_char = sizeof(_s_char);
	so_u_char = sizeof(_u_char);
	so_float = sizeof(_float);
	so_double = sizeof(_double);
	so_l_double = sizeof(_l_double);

	puts("");
	puts(" TYPE                  SIZE |       MIN*        MAX");
	separator();
	puts(" INTEGER:");
	separator();
	printf(" short:               %3d\n", so_short);
	printf("  signed short:       %3d   |  %2.3e   %2.3e\n", so_s_short, (double)SHRT_MIN, (double)SHRT_MAX);
	printf("  unsigned short:     %3d   |  %10d   %2.3e\n", so_u_short, 0, (double)USHRT_MAX);
	separator();
	printf(" int:                 %3d\n", so_int);
	printf("  signed int:         %3d   |  %2.3e   %2.3e\n", so_s_int, (double)INT_MIN, (double)INT_MAX);
	printf("  unsigned int:       %3d   |  %10d   %2.3e\n", so_u_int, 0, (double)UINT_MAX);
	separator();
	printf(" long:                %3d\n", so_long);
	printf("  signed long:        %3d   |  %2.3e   %2.3e\n", so_s_long, (double)LONG_MIN, (double)LONG_MAX);
	printf("  unsigned long:      %3d   |  %10d   %2.3e\n", so_u_long, 0, (double)ULONG_MAX);
	separator();
	printf(" long long:           %3d\n", so_long_long);
	printf("  signed  long long:  %3d   |  %2.3e   %2.3e\n", so_s_long_long, (double)LLONG_MIN, (double)LLONG_MAX);
	printf("  unsigned long long: %3d   |  %10d   %2.3e\n", so_u_long_long, 0, (double)ULLONG_MAX);
	separator();
	puts(" CHAR:");
	separator();
	printf(" char:                %3d   |  %2.3e   %2.3e\n", so_char, (double)CHAR_MIN, (double)CHAR_MAX);
	printf("  signed char:        %3d   |  %2.3e   %2.3e\n", so_s_char, (double)SCHAR_MIN, (double)SCHAR_MAX);
	printf("  unsigned char:      %3d   |  %10d   %2.3e\n", so_u_char, 0, (double)UCHAR_MAX);
	separator();
	puts(" FLOAT:");
	separator();
	printf(" float:               %3d   |  %2.3e   %2.3e\n", so_float, (double)FLT_MIN, (double)FLT_MAX);
	printf(" double:              %3d   |  %2.2e   %2.2e\n", so_double, DBL_MIN, DBL_MAX);
	printf(" long double:         %3d   |  %2.1Le   %2.1Le\n", so_l_double, LDBL_MIN, LDBL_MAX);
	puts("");
	puts(" * - MIN is minimum or value closest to zero");
	puts("");

	return 0;
}

void separator(void) {
	puts(" -----------------------------------------------------");
}
