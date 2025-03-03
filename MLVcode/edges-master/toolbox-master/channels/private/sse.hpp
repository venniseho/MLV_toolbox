/*******************************************************************************
* Piotr's Computer Vision Matlab Toolbox      Version 3.23
* Copyright 2014 Piotr Dollar.
* Licensed under the Simplified BSD License [see external/bsd.txt]
*******************************************************************************/
#ifndef _SSE_HPP_
#define _SSE_HPP_

#include "simde-master/simde/x86/sse2.h" // Include SIMDE SSE2 header
#include "simde-master/simde/x86/sse.h"
#include "simde-master/simde/x86/sse4.1.h"

#define RETf inline simde__m128
#define RETi inline simde__m128i

// set, load and store values
RETf SET( const float &x ) { return simde_mm_set1_ps(x); }
RETf SET( float x, float y, float z, float w ) { return simde_mm_set_ps(x, y, z, w); }
RETi SET( const int &x ) { return simde_mm_set1_epi32(x); }
RETf LD( const float &x ) { return simde_mm_load_ps(&x); }
RETf LDu( const float &x ) { return simde_mm_loadu_ps(&x); }
RETf STR( float &x, const simde__m128 y ) { simde_mm_store_ps(&x, y); return y; }
RETf STR1( float &x, const simde__m128 y ) { simde_mm_store_ss(&x, y); return y; }
RETf STRu( float &x, const simde__m128 y ) { simde_mm_storeu_ps(&x, y); return y; }
RETf STR( float &x, const float y ) { return STR(x, SET(y)); }

// arithmetic operators
RETi ADD( const simde__m128i x, const simde__m128i y ) { return simde_mm_add_epi32(x, y); }
RETf ADD( const simde__m128 x, const simde__m128 y ) { return simde_mm_add_ps(x, y); }
RETf ADD( const simde__m128 x, const simde__m128 y, const simde__m128 z ) {
  return ADD(ADD(x, y), z);
}
RETf ADD( const simde__m128 a, const simde__m128 b, const simde__m128 c, const simde__m128 &d ) {
  return ADD(ADD(ADD(a, b), c), d);
}
RETf SUB( const simde__m128 x, const simde__m128 y ) { return simde_mm_sub_ps(x, y); }
RETf MUL( const simde__m128 x, const simde__m128 y ) { return simde_mm_mul_ps(x, y); }
RETf MUL( const simde__m128 x, const float y ) { return MUL(x, SET(y)); }
RETf MUL( const float x, const simde__m128 y ) { return MUL(SET(x), y); }
RETf INC( simde__m128 &x, const simde__m128 y ) { return x = ADD(x, y); }
RETf INC( float &x, const simde__m128 y ) { simde__m128 t = ADD(LD(x), y); return STR(x, t); }
RETf DEC( simde__m128 &x, const simde__m128 y ) { return x = SUB(x, y); }
RETf DEC( float &x, const simde__m128 y ) { simde__m128 t = SUB(LD(x), y); return STR(x, t); }
RETf MIN( const simde__m128 x, const simde__m128 y ) { return simde_mm_min_ps(x, y); }
RETf RCP( const simde__m128 x ) { return simde_mm_rcp_ps(x); }
RETf RCPSQRT( const simde__m128 x ) { return simde_mm_rsqrt_ps(x); }

// logical operators
RETf AND( const simde__m128 x, const simde__m128 y ) { return simde_mm_and_ps(x, y); }
RETi AND( const simde__m128i x, const simde__m128i y ) { return simde_mm_and_si128(x, y); }
RETf ANDNOT( const simde__m128 x, const simde__m128 y ) { return simde_mm_andnot_ps(x, y); }
RETf OR( const simde__m128 x, const simde__m128 y ) { return simde_mm_or_ps(x, y); }
RETf XOR( const simde__m128 x, const simde__m128 y ) { return simde_mm_xor_ps(x, y); }

// comparison operators
RETf CMPGT( const simde__m128 x, const simde__m128 y ) { return simde_mm_cmpgt_ps(x, y); }
RETf CMPLT( const simde__m128 x, const simde__m128 y ) { return simde_mm_cmplt_ps(x, y); }
RETi CMPGT( const simde__m128i x, const simde__m128i y ) { return simde_mm_cmpgt_epi32(x, y); }
RETi CMPLT( const simde__m128i x, const simde__m128i y ) { return simde_mm_cmplt_epi32(x, y); }

// conversion operators
RETf CVT( const simde__m128i x ) { return simde_mm_cvtepi32_ps(x); }
RETi CVT( const simde__m128 x ) { return simde_mm_cvttps_epi32(x); }

#undef RETf
#undef RETi
#endif
