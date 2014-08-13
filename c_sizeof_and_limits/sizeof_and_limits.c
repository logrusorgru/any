// machine_size.c

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

void separator(void);

int main(int argc, char const *argv[]) {

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
		so_l_double,
		so_pointer;

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
	so_pointer = sizeof(&_int);

	// =============   STDL   =============

	int so_fenv_t, so_fexcept_t;

	// fenv.h
	fenv_t _fenv_t;
	fexcept_t _fexcept_t;

	so_fenv_t = sizeof(_fenv_t);
	so_fexcept_t = sizeof(so_fexcept_t);
	//-------------------------------------

	int so_jmp_buf;

	// setjmp.h
	jmp_buf _jmp_buf;

	so_jmp_buf = sizeof(_jmp_buf);
	//-------------------------------------

	int so_sig_atomic_t;

	// signal.h
	sig_atomic_t _sig_atomic_t; // SIG_ATOMIC_MIN, SIG_ATOMIC_MAX

	so_sig_atomic_t = sizeof(_sig_atomic_t);
	//-------------------------------------

	int so_va_list;

	// stdarg.h
	va_list _va_list;

	so_va_list = sizeof(_va_list);
	//-------------------------------------

	int so_bool;

	// stdbool.h
	bool _bool;

	so_bool = sizeof(_bool);
	//-------------------------------------

	int so_ptrdiff_t, so_wchar_t, so_size_t;

	// stddef.h
	ptrdiff_t _ptrdiff_t; // PTRDIFF_MIN, PTRDIFF_MAX
	wchar_t _wchar_t; // WCHAR_MIN, WCHAR_MAX
	size_t _size_t; // SIZE_MAX

	so_ptrdiff_t = sizeof(_ptrdiff_t);
	so_wchar_t = sizeof(_wchar_t);
	so_size_t = sizeof(_size_t);
	//-------------------------------------

	// stdint.h

	int so_int8_t, so_int16_t, so_int32_t, so_int64_t,
	so_uint8_t, so_uint16_t, so_uint32_t, so_uint64_t;

	int8_t _int8_t; // INT8_MIN, INT8_MAX
	int16_t _int16_t; // INT16_MIN, INT16_MAX
	int32_t _int32_t; // INT32_MIN, INT32_MAX
	int64_t _int64_t; // INT64_MIN, INT64_MAX
	uint8_t _uint8_t; // UINT8_MAX
	uint16_t _uint16_t; // UINT16_MAX
	uint32_t _uint32_t; // UINT32_MAX
	uint64_t _uint64_t; // UINT64_MAX

	so_int8_t = sizeof(_int8_t);
	so_int16_t = sizeof(_int16_t);
	so_int32_t = sizeof(_int32_t);
	so_int64_t = sizeof(_int64_t);
	so_uint8_t = sizeof(_uint8_t);
	so_uint16_t = sizeof(_uint16_t);
	so_uint32_t = sizeof(_uint32_t);
	so_uint64_t = sizeof(_uint64_t);

	int so_int_least8_t, so_int_least16_t, so_int_least32_t, so_int_least64_t,
	so_uint_least8_t, so_uint_least16_t, so_uint_least32_t, so_uint_least64_t;

	int_least8_t _int_least8_t; // INT_LEAST8_MIN, INT_LEAST8_MAX
	int_least16_t _int_least16_t; // INT_LEAST16_MIN, INT_LEAST16_MAX
	int_least32_t _int_least32_t; // INT_LEAST32_MIN, INT_LEAST32_MAX
	int_least64_t _int_least64_t; // INT_LEAST64_MIN, INT_LEAST64_MAX
	uint_least8_t _uint_least8_t; // UINT_LEAST8_MAX
	uint_least16_t _uint_least16_t; // UINT_LEAST16_MAX
	uint_least32_t _uint_least32_t; // UINT_LEAST32_MAX
	uint_least64_t _uint_least64_t; // UINT_LEAST64_MAX

	so_int_least8_t = sizeof(_int_least8_t);
	so_int_least16_t = sizeof(_int_least16_t);
	so_int_least32_t = sizeof(_int_least32_t);
	so_int_least64_t = sizeof(_int_least64_t);
	so_uint_least8_t = sizeof(_uint_least8_t);
	so_uint_least16_t = sizeof(_uint_least16_t);
	so_uint_least32_t = sizeof(_uint_least32_t);
	so_uint_least64_t = sizeof(_uint_least64_t);

	int so_int_fast8_t, so_int_fast16_t, so_int_fast32_t, so_int_fast64_t,
	so_uint_fast8_t, so_uint_fast16_t, so_uint_fast32_t, so_uint_fast64_t;

	int_fast8_t _int_fast8_t; // INT_FAST8_MIN, INT_FAST8_MAX
	int_fast16_t _int_fast16_t; // INT_FAST16_MIN, INT_FAST16_MAX
	int_fast32_t _int_fast32_t; // INT_FAST32_MIN, INT_FAST32_MAX
	int_fast64_t _int_fast64_t; // INT_FAST64_MIN, INT_FAST64_MAX
	uint_fast8_t _uint_fast8_t; // UINT_FAST8_MAX
	uint_fast16_t _uint_fast16_t; // UINT_FAST16_MAX
	uint_fast32_t _uint_fast32_t; // UINT_FAST32_MAX
	uint_fast64_t _uint_fast64_t; // UINT_FAST64_MAX

	so_int_fast8_t = sizeof(_int_fast8_t);
	so_int_fast16_t = sizeof(_int_fast16_t);
	so_int_fast32_t = sizeof(_int_fast32_t);
	so_int_fast64_t = sizeof(_int_fast64_t);
	so_uint_fast8_t = sizeof(_uint_fast8_t);
	so_uint_fast16_t = sizeof(_uint_fast16_t);
	so_uint_fast32_t = sizeof(_uint_fast32_t);
	so_uint_fast64_t = sizeof(_uint_fast64_t);

	int so_intptr_t, so_uintptr_t;

	intptr_t _intptr_t; // INT_PTR_MIN, INT_PTR_MAX
	uintptr_t _uintptr_t; // UINTPTR_MAX

	so_intptr_t = sizeof(_intptr_t);
	so_uintptr_t = sizeof(_uintptr_t);
	//-------------------------------------

	// stdio.h

	int so_file, so_fpos_t;

	FILE _file;
	fpos_t _fpos_t;
	//size_t _size_t;

	so_file = sizeof(_file);
	so_fpos_t = sizeof(_fpos_t);
	//-------------------------------------

	// stdlib.h

	int so_div_t, so_ldiv_t;

	//size_t
	div_t _div_t;
	ldiv_t _ldiv_t;

	so_div_t = sizeof(_div_t);
	so_ldiv_t = sizeof(_ldiv_t);
	//-------------------------------------

	// time.h

	int so_clock_t, so_time_t;

	clock_t _clock_t;
	time_t _time_t;

	so_clock_t = sizeof(_clock_t);
	so_time_t = sizeof(_time_t);
	//-------------------------------------

	// wchar.h

	int so_wint_t, so_mbstate_t;

	//wchar_t _wchar_t; // WCHAR_MAX, WCHAR_MIN
	wint_t _wint_t;
	mbstate_t _mbstate_t;

	so_wint_t = sizeof(_wint_t);
	so_mbstate_t = sizeof(_mbstate_t);
	//-------------------------------------

	// wctype.h

	int so_wctype_t;

	wctype_t _wctype_t;
	//wctrans_t

	so_wctype_t = sizeof(_wctype_t);
	//-------------------------------------

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
	separator();
	puts(" POINTER:");
	separator();
	printf(" pointer:             %3d\n", so_pointer);
	separator();
	puts("                       STDL");
	separator();
	puts("  <fenv.h>");
	separator();
	printf(" so_fenv_t            %3d\n", so_fenv_t);
	printf(" so_fexcept_t         %3d\n", so_fexcept_t);
	separator();
	puts("  <setjmp.h>");
	separator();
	printf(" so_jmp_buf           %3d\n", so_jmp_buf);
	separator();
	puts("  <signal.h>");
	separator();
	printf(" so_sig_atomic_t      %3d   |  %2.3e   %2.3e\n", so_sig_atomic_t, (double)SIG_ATOMIC_MIN, (double)SIG_ATOMIC_MAX);
	separator();
	puts("  <stdarg.h>");
	separator();
	printf(" so_va_list           %3d\n", so_va_list);
	separator();
	puts("  <stdbool.h>");
	separator();
	printf(" so_bool              %3d\n", so_bool);
	separator();
	puts("  <stddef.h>");
	separator();
	printf(" so_ptrdiff_t         %3d   |  %2.3e   %2.3e\n", so_ptrdiff_t, (double)PTRDIFF_MIN, (double)PTRDIFF_MAX);
	printf(" so_wchar_t           %3d   |  %2.3e   %2.3e\n", so_wchar_t, (double)WCHAR_MIN, (double)WCHAR_MAX);
	printf(" so_size_t            %3d   |  %10d   %2.3e\n", so_size_t, 0, (double)SIZE_MAX);
	separator();
	puts("  <stdint.h>");
	separator();
	printf(" so_int8_t            %3d   |  %2.3e   %2.3e\n", so_int8_t, (double)INT8_MIN, (double)INT8_MAX);
	printf(" so_int16_t           %3d   |  %2.3e   %2.3e\n", so_int16_t, (double)INT16_MIN, (double)INT16_MAX);
	printf(" so_int32_t           %3d   |  %2.3e   %2.3e\n", so_int32_t, (double)INT32_MIN, (double)INT32_MAX);
	printf(" so_int64_t           %3d   |  %2.3e   %2.3e\n", so_int64_t, (double)INT64_MIN, (double)INT64_MAX);
	printf(" so_uint8_t           %3d   |  %10d   %2.3e\n", so_uint8_t, 0, (double)UINT8_MAX);
	printf(" so_uint16_t          %3d   |  %10d   %2.3e\n", so_uint16_t, 0, (double)UINT16_MAX);
	printf(" so_uint32_t          %3d   |  %10d   %2.3e\n", so_uint32_t, 0, (double)UINT32_MAX);
	printf(" so_uint64_t          %3d   |  %10d   %2.3e\n", so_uint64_t, 0, (double)UINT64_MAX);
	printf(" so_int_least8_t      %3d   |  %2.3e   %2.3e\n", so_int_least8_t, (double)INT_LEAST8_MIN, (double)INT_LEAST8_MAX);
	printf(" so_int_least16_t     %3d   |  %2.3e   %2.3e\n", so_int_least16_t, (double)INT_LEAST16_MIN, (double)INT_LEAST16_MAX);
	printf(" so_int_least32_t     %3d   |  %2.3e   %2.3e\n", so_int_least32_t, (double)INT_LEAST32_MIN, (double)INT_LEAST32_MAX);
	printf(" so_int_least64_t     %3d   |  %2.3e   %2.3e\n", so_int_least64_t, (double)INT_LEAST64_MIN, (double)INT_LEAST64_MAX);
	printf(" so_uint_least8_t     %3d   |  %10d   %2.3e\n", so_uint_least8_t, 0, (double)UINT_LEAST8_MAX);
	printf(" so_uint_least16_t    %3d   |  %10d   %2.3e\n", so_uint_least16_t, 0, (double)UINT_LEAST16_MAX);
	printf(" so_uint_least32_t    %3d   |  %10d   %2.3e\n", so_uint_least32_t, 0, (double)UINT_LEAST32_MAX);
	printf(" so_uint_least64_t    %3d   |  %10d   %2.3e\n", so_uint_least64_t, 0, (double)UINT_LEAST64_MAX);
	printf(" so_int_fast8_t       %3d   |  %2.3e   %2.3e\n", so_int_fast8_t, (double)INT_FAST8_MIN, (double)INT_FAST8_MAX);
	printf(" so_int_fast16_t      %3d   |  %2.3e   %2.3e\n", so_int_fast16_t, (double)INT_FAST16_MIN, (double)INT_FAST16_MAX);
	printf(" so_int_fast32_t      %3d   |  %2.3e   %2.3e\n", so_int_fast32_t, (double)INT_FAST32_MIN, (double)INT_FAST32_MAX);
	printf(" so_int_fast64_t      %3d   |  %2.3e   %2.3e\n", so_int_fast64_t, (double)INT_FAST64_MIN, (double)INT_FAST64_MAX);
	printf(" so_uint_fast8_t      %3d   |  %10d   %2.3e\n", so_uint_fast8_t, 0, (double)UINT_FAST8_MAX);
	printf(" so_uint_fast16_t     %3d   |  %10d   %2.3e\n", so_uint_fast16_t, 0, (double)UINT_FAST16_MAX);
	printf(" so_uint_fast32_t     %3d   |  %10d   %2.3e\n", so_uint_fast32_t, 0, (double)UINT_FAST32_MAX);
	printf(" so_uint_fast64_t     %3d   |  %10d   %2.3e\n", so_uint_fast64_t, 0, (double)UINT_FAST64_MAX);
	printf(" so_intptr_t          %3d   |  %2.3e   %2.3e\n", so_intptr_t, (double)INTPTR_MIN, (double)INTPTR_MAX);
	printf(" so_uintptr_t         %3d   |  %10d   %2.3e\n", so_uintptr_t, 0, (double)UINTPTR_MAX);
	separator();
	puts("  <stdio.h>");
	separator();
	printf(" so_file              %3d\n", so_file);
	printf(" so_fpos_t            %3d\n", so_fpos_t);
	separator();
	puts("  <stdlib.h>");
	separator();
	printf(" so_div_t             %3d\n", so_div_t);
	printf(" so_ldiv_t            %3d\n", so_ldiv_t);
	separator();
	puts("  <time.h>");
	separator();
	printf(" so_clock_t           %3d\n", so_clock_t);
	printf(" so_time_t            %3d\n", so_time_t);
	separator();
	puts("  <wchar.h>");
	separator();
	printf(" so_wint_t            %3d\n", so_wint_t);
	printf(" so_mbstate_t         %3d\n", so_mbstate_t);
	separator();
	puts("  <wctype.h>");
	separator();
	printf(" so_wctype_t          %3d\n", so_wctype_t);
	separator();
	puts("");
	puts(" * - MIN is minimum or value closest to zero");
	puts("");

	return 0;
}

inline void separator(void) {
	puts(" -----------------------------------------------------");
}
