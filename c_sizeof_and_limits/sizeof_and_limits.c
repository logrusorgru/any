// machine_size.c

/*
intmax_t, uintmax_t
INTMAX_MIN
INTMAX_MAX
UINTMAX_MAX
*/


// #include <stdio.h>

#include <fenv.h>
#include <setjmp.h>
#include <signal.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <wchar.h>
#include <wctype.h>

#include <limits.h>
#include <float.h>

#define so_type(t) \
	printf(" %-20s %3lu\n", #t, sizeof(t));

#define so_type_mm(t, min, max) \
	printf(" %-20s %3lu   |  %2.3e   %2.3e\n", #t, sizeof(t), (double) min,(double) max);

#define so_type_m(t, max) \
	printf(" %-20s %3lu   |  %10d   %2.3e\n", #t, sizeof(t), 0,(double) max);

/* nested */

#define so_type_mm_nested(t, min, max) \
	printf("  %-19s %3lu   |  %2.3e   %2.3e\n", #t, sizeof(t), (double) min,(double) max);

#define so_type_m_nested(t, max) \
	printf("  %-19s %3lu   |  %10d   %2.3e\n", #t, sizeof(t), 0,(double) max);

/* sep */
#define separator \
	puts(" -----------------------------------------------------");

/* let's go */

int main(int argc, char const *argv[]) {

	puts("");
	puts(" TYPE                  SIZE |       MIN*        MAX");
	separator;
	puts(" INTEGER:");
	separator;
	so_type(short);
	so_type_mm_nested(signed short, SHRT_MIN, SHRT_MAX);
	so_type_m_nested(unsigned short, USHRT_MAX);
	separator;
	so_type(int);
	so_type_mm_nested(signed int, INT_MIN, INT_MAX);
	so_type_m_nested(unsigned int, UINT_MAX);
	separator;
	so_type(long);
	so_type_mm_nested(signed long, LONG_MIN, LONG_MAX);
	so_type_m_nested(unsigned long, ULONG_MAX);
	separator;
	so_type(long long);
	so_type_mm_nested(signed long long, LLONG_MIN, LLONG_MAX);
	so_type_m_nested(unsigned long long, ULLONG_MAX);
	separator;
	puts(" CHAR:");
	separator;
	so_type_mm(char, CHAR_MIN, CHAR_MAX);
	so_type_mm_nested(signed char, CHAR_MIN, CHAR_MAX);
	so_type_m_nested(unsigned char, UCHAR_MAX);
	separator;
	puts(" FLOAT:");
	separator;
	so_type_mm(float, FLT_MIN, FLT_MAX);
	printf(" %-20s %3lu   |  %2.2e   %2.2e\n", "double", sizeof(double), DBL_MIN, DBL_MAX);
	printf(" %-20s %3lu   |  %2.1Le   %2.1Le\n", "long double", sizeof(long double), LDBL_MIN, LDBL_MAX);
	separator;
	puts(" POINTER:");
	separator;
	printf(" %-20s %3lu\n", "pointer", sizeof(void *) );
	separator;
	puts("                       STDL");
	separator;
	puts("  <fenv.h>");
	separator;
	so_type(fenv_t);
	so_type(fexcept_t);
	separator;
	puts("  <setjmp.h>");
	separator;
	so_type(jmp_buf);
	separator;
	puts("  <signal.h>");
	separator;
	so_type_mm(sig_atomic_t, SIG_ATOMIC_MIN, SIG_ATOMIC_MAX);
	separator;
	puts("  <stdarg.h>");
	separator;
	so_type(va_list);
	separator;
	puts("  <stdbool.h>");
	separator;
	so_type(bool);
	separator;
	puts("  <stddef.h>");
	separator;
	so_type_mm(ptrdiff_t, PTRDIFF_MIN, PTRDIFF_MAX);
	so_type_mm(wchar_t, WCHAR_MIN, WCHAR_MAX);
	so_type_m(size_t, SIZE_MAX);
	separator;
	puts("  <stdint.h>");
	separator;
	so_type_mm(int8_t, INT8_MIN, INT8_MAX);
	so_type_mm(int16_t, INT16_MIN, INT16_MAX);
	so_type_mm(int32_t, INT32_MIN, INT32_MAX);
	so_type_mm(int64_t, INT64_MIN, INT64_MAX);
	so_type_m(uint8_t, UINT8_MAX);
	so_type_m(uint16_t, UINT16_MAX);
	so_type_m(uint32_t, UINT32_MAX);
	so_type_m(uint64_t, UINT64_MAX);
	so_type_mm(int_least8_t, INT_LEAST8_MIN, INT_LEAST8_MAX);
	so_type_mm(int_least16_t, INT_LEAST16_MIN, INT_LEAST16_MAX);
	so_type_mm(int_least32_t, INT_LEAST32_MIN, INT_LEAST32_MAX);
	so_type_mm(int_least64_t, INT_LEAST64_MIN, INT_LEAST64_MAX);
	so_type_m(uint_least8_t, UINT_LEAST8_MAX);
	so_type_m(uint_least16_t, UINT_LEAST16_MAX);
	so_type_m(uint_least32_t, UINT_LEAST32_MAX);
	so_type_m(uint_least64_t, UINT_LEAST64_MAX);
	so_type_mm(int_fast8_t, INT_FAST8_MIN, INT_FAST8_MAX);
	so_type_mm(int_fast16_t, INT_FAST16_MIN, INT_FAST16_MAX);
	so_type_mm(int_fast32_t, INT_FAST32_MIN, INT_FAST32_MAX);
	so_type_mm(int_fast64_t, INT_FAST64_MIN, INT_FAST64_MAX);
	so_type_m(uint_fast8_t, UINT_FAST8_MAX);
	so_type_m(uint_fast16_t, UINT_FAST16_MAX);
	so_type_m(uint_fast32_t, UINT_FAST32_MAX);
	so_type_m(uint_fast64_t, UINT_FAST64_MAX);
	so_type_mm(intptr_t, INTPTR_MIN, INTPTR_MAX);
	so_type_m(uintptr_t, UINTPTR_MAX);
	separator;
	puts("  <stdio.h>");
	separator;
	so_type(FILE);
	so_type(fpos_t);
	separator;
	puts("  <stdlib.h>");
	separator;
	so_type(div_t);
	so_type(ldiv_t);
	separator;
	puts("  <time.h>");
	separator;
	so_type(clock_t);
	so_type(time_t);
	separator;
	puts("  <wchar.h>");
	separator;
	so_type(wint_t);
	so_type(mbstate_t);
	separator;
	puts("  <wctype.h>");
	separator;
	so_type(wctype_t);
	separator;
	puts("");
	puts(" * - MIN is minimum or value closest to zero");
	puts("");

	return 0;
}
