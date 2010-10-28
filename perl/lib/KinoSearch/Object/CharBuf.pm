# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

package KinoSearch::Object::CharBuf;
use KinoSearch;

1;

__END__

__BINDING__

my $xs_code = <<'END_XS_CODE';
MODULE = KinoSearch     PACKAGE = KinoSearch::Object::CharBuf

SV*
new(either_sv, sv)
    SV *either_sv;
    SV *sv;
CODE:
{
    STRLEN size;
    char *ptr = SvPVutf8(sv, size);
    kino_CharBuf *self = (kino_CharBuf*)XSBind_new_blank_obj(either_sv);
    kino_CB_init(self, size);
    Kino_CB_Cat_Trusted_Str(self, ptr, size);
    RETVAL = KINO_OBJ_TO_SV_NOINC(self);
}
OUTPUT: RETVAL

SV*
_clone(self)
    kino_CharBuf *self;
CODE:
    RETVAL = KINO_OBJ_TO_SV_NOINC(kino_CB_clone(self));
OUTPUT: RETVAL

SV*
_deserialize(either_sv, instream)
    SV *either_sv;
    kino_InStream *instream;
CODE:
    CHY_UNUSED_VAR(either_sv);
    RETVAL = KINO_OBJ_TO_SV_NOINC(kino_CB_deserialize(NULL, instream));
OUTPUT: RETVAL

SV*
to_perl(self)
    kino_CharBuf *self;
CODE:
    RETVAL = XSBind_cb_to_sv(self);
OUTPUT: RETVAL

MODULE = KinoSearch     PACKAGE = KinoSearch::Object::ViewCharBuf

SV*
_new(unused, sv)
    SV *unused;
    SV *sv;
CODE:
{
    STRLEN size;
    char *ptr = SvPVutf8(sv, size);
    kino_ViewCharBuf *self 
        = kino_ViewCB_new_from_trusted_utf8(ptr, size);
    CHY_UNUSED_VAR(unused);
    RETVAL = KINO_OBJ_TO_SV_NOINC(self);
}
OUTPUT: RETVAL
END_XS_CODE

Clownfish::Binding::Perl::Class->register(
    parcel       => "KinoSearch",
    class_name   => "KinoSearch::Object::CharBuf",
    xs_code      => $xs_code,
);

