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

package KinoSearch::Search::Collector;
use KinoSearch;

1;

__END__

__BINDING__

my $constructor = <<'END_CONSTRUCTOR';
    package MyCollector;
    use base qw( KinoSearch::Search::Collector );
    our %foo;
    sub new {
        my $self = shift->SUPER::new;
        my %args = @_;
        $foo{$$self} = $args{foo};
        return $self;
    }
END_CONSTRUCTOR

Clownfish::Binding::Perl::Class->register(
    parcel       => "KinoSearch",
    class_name   => "KinoSearch::Search::Collector",
    bind_methods => [
        qw(
            Collect
            Set_Reader
            Set_Base
            Set_Matcher
            Need_Score
            )
    ],
    bind_constructors => ["new"],
    make_pod          => {
        synopsis    => "    # Abstract base class.\n",
        constructor => { sample => $constructor },
        methods     => [qw( collect )],
    },
);
Clownfish::Binding::Perl::Class->register(
    parcel            => "KinoSearch",
    class_name        => "KinoSearch::Search::Collector::OffsetCollector",
    bind_constructors => ["new"],
);

