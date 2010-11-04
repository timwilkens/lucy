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

package KinoSearch::Analysis::Stemmer;
use KinoSearch;

1;

__END__

__BINDING__

my $xs = <<'END_XS';
MODULE = KinoSearch    PACKAGE = KinoSearch::Analysis::Stemmer

void
_copy_snowball_symbols()
PPCODE:
{
    SV **const new_sv_ptr = hv_fetch(PL_modglobal,
        "Lingua::Stem::Snowball::sb_stemmer_new", 38, 0);
    SV **const delete_sv_ptr = hv_fetch(PL_modglobal,
        "Lingua::Stem::Snowball::sb_stemmer_delete", 41, 0);
    SV **const stem_sv_ptr = hv_fetch(PL_modglobal,
        "Lingua::Stem::Snowball::sb_stemmer_stem", 39, 0);
    SV **const length_sv_ptr = hv_fetch(PL_modglobal,
        "Lingua::Stem::Snowball::sb_stemmer_length", 41, 0);
    if (!new_sv_ptr || !delete_sv_ptr || !stem_sv_ptr || !length_sv_ptr) {
        THROW(LUCY_ERR, "Failed to retrieve one or more Snowball symbols");
    }
    lucy_Stemmer_sb_stemmer_new 
        = (lucy_Stemmer_sb_stemmer_new_t)SvIV(*new_sv_ptr);
    lucy_Stemmer_sb_stemmer_delete 
        = (lucy_Stemmer_sb_stemmer_delete_t)SvIV(*delete_sv_ptr);
    lucy_Stemmer_sb_stemmer_stem 
        = (lucy_Stemmer_sb_stemmer_stem_t)SvIV(*stem_sv_ptr);
    lucy_Stemmer_sb_stemmer_length 
        = (lucy_Stemmer_sb_stemmer_length_t)SvIV(*length_sv_ptr);
}
END_XS

my $synopsis = <<'END_SYNOPSIS';
    my $stemmer = Lucy::Analysis::Stemmer->new( language => 'es' );
    
    my $polyanalyzer = Lucy::Analysis::PolyAnalyzer->new(
        analyzers => [ $case_folder, $tokenizer, $stemmer ],
    );

This class is a wrapper around L<Lingua::Stem::Snowball>, so it supports the
same languages.  
END_SYNOPSIS

my $constructor = <<'END_CONSTRUCTOR';
    my $stemmer = Lucy::Analysis::Stemmer->new( language => 'es' );
END_CONSTRUCTOR

Clownfish::Binding::Perl::Class->register(
    parcel            => "Lucy",
    class_name        => "KinoSearch::Analysis::Stemmer",
    bind_constructors => ["new"],
    xs_code           => $xs,
    make_pod          => {
        synopsis    => $synopsis,
        constructor => { sample => $constructor }
    },
);


