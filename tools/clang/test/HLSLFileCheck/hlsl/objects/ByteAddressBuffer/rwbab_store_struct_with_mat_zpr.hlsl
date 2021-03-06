// RUN: %dxc -E main -Zpr -T vs_6_5 /DTEST1=1 %s | FileCheck %s -check-prefix=CHK_TEST1
// RUN: %dxc -E main -Zpr -T vs_6_5 %s | FileCheck %s -check-prefix=CHK_TEST2

// Regression test for github issue# #3226


#ifdef TEST1
struct S
{
  float1x1 mat;    
};
#else
struct S
{
  float2x2 mat;
  float f1; 
  int i1; 
  struct S1 {
      float1x1 mat1; // nested struct
  } s1;
};
#endif

RWByteAddressBuffer buf;

void main(S a : IN0)
{
    S t = a;
    
    // CHK_TEST1: dx.op.rawBufferStore.f32
    
    // CHK_TEST2: dx.op.rawBufferStore.f32
    // CHK_TEST2: dx.op.rawBufferStore.f32
    // CHK_TEST2: dx.op.rawBufferStore.i32
    // CHK_TEST2: dx.op.rawBufferStore.f32
    buf.Store(0, t);
}