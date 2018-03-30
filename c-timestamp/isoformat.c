#include "erl_nif.h"
#include "timestamp.h"
//#include <string.h>

static ERL_NIF_TERM
isoformat(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
  int64_t microsecs;
  enif_get_int64(env, argv[0], &microsecs);
  timestamp_t t;
  t.sec = microsecs / 1000000; // micro to seconds
  t.nsec = (microsecs % 1000000) * 1000; // micro to nano
  t.offset = 0;
  char isostring[256];
  size_t ret = timestamp_format(isostring, 255, &t);
  //ErlNifBinary ibin;
  //enif_alloc_binary(ret, &ibin);
  //memcpy(ibin.data, isostring, ret);
  //return enif_make_binary(env, &ibin);
  return enif_make_string(env, isostring, ERL_NIF_LATIN1);
}

// Let's define the array of ErlNifFunc beforehand:
static ErlNifFunc nif_funcs[] = {
  // {erl_function_name, erl_function_arity, c_function}
  {"formatiso", 1, isoformat}
};

ERL_NIF_INIT(Elixir.FastIso, nif_funcs, NULL, NULL, NULL, NULL)
