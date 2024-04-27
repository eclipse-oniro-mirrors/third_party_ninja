#!/bin/bash
# Copyright 2020 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

set -eu
cmake -Bbuild-cmake -H.
cmake --build build-cmake

cd $SRC/ninja/misc

$CXX $CXXFLAGS -fdiagnostics-color -I/src/ninja/src -o fuzzer.o -c manifest_fuzzer.cc

find .. -name "*.o" -exec ar rcs fuzz_lib.a {} \;

$CXX $CXXFLAGS $LIB_FUZZING_ENGINE fuzzer.o -o $OUT/fuzzer fuzz_lib.a

zip $OUT/fuzzer_seed_corpus.zip $SRC/sample_ninja_build