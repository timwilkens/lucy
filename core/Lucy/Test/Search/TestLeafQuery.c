/* Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define C_LUCY_TESTLEAFQUERY
#include "Lucy/Util/ToolSet.h"
#include <math.h>

#include "Lucy/Test.h"
#include "Lucy/Test/Search/TestLeafQuery.h"
#include "Lucy/Test/TestUtils.h"
#include "Lucy/Search/LeafQuery.h"

static void
test_Dump_Load_and_Equals(TestBatch *batch) {
    LeafQuery *query         = TestUtils_make_leaf_query("content", "foo");
    LeafQuery *field_differs = TestUtils_make_leaf_query("stuff", "foo");
    LeafQuery *null_field    = TestUtils_make_leaf_query(NULL, "foo");
    LeafQuery *term_differs  = TestUtils_make_leaf_query("content", "bar");
    LeafQuery *boost_differs = TestUtils_make_leaf_query("content", "foo");
    Obj       *dump          = (Obj*)LeafQuery_Dump(query);
    LeafQuery *clone         = (LeafQuery*)LeafQuery_Load(term_differs, dump);

    TEST_FALSE(batch, LeafQuery_Equals(query, (Obj*)field_differs),
               "Equals() false with different field");
    TEST_FALSE(batch, LeafQuery_Equals(query, (Obj*)null_field),
               "Equals() false with null field");
    TEST_FALSE(batch, LeafQuery_Equals(query, (Obj*)term_differs),
               "Equals() false with different term");
    LeafQuery_Set_Boost(boost_differs, 0.5);
    TEST_FALSE(batch, LeafQuery_Equals(query, (Obj*)boost_differs),
               "Equals() false with different boost");
    TEST_TRUE(batch, LeafQuery_Equals(query, (Obj*)clone),
              "Dump => Load round trip");

    DECREF(query);
    DECREF(term_differs);
    DECREF(field_differs);
    DECREF(null_field);
    DECREF(boost_differs);
    DECREF(dump);
    DECREF(clone);
}

void
TestLeafQuery_run_tests() {
    TestBatch *batch = TestBatch_new(5);
    TestBatch_Plan(batch);
    test_Dump_Load_and_Equals(batch);
    DECREF(batch);
}


