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
package Lucy::Build::Binding::Docs;

sub bind_all {
    my $class = shift;
    $class->bind_devguide;
    $class->bind_filelocking;
}

sub bind_devguide {
    Clownfish::CFC::Binding::Perl::Class->register(
        parcel     => "Lucy",
        class_name => "Lucy::Docs::DevGuide",
        make_pod   => {},
    );

}

sub bind_filelocking {
    my $synopsis = <<'END_SYNOPSIS';
    use Sys::Hostname qw( hostname );
    my $hostname = hostname() or die "Can't get unique hostname";
    my $manager = Lucy::Index::IndexManager->new( host => $hostname );

    # Index time:
    my $indexer = Lucy::Index::Indexer->new(
        index   => '/path/to/index',
        manager => $manager,
    );

    # Search time:
    my $reader = Lucy::Index::IndexReader->open(
        index   => '/path/to/index',
        manager => $manager,
    );
    my $searcher = Lucy::Search::IndexSearcher->new( index => $reader );
END_SYNOPSIS

    Clownfish::CFC::Binding::Perl::Class->register(
        parcel     => "Lucy",
        class_name => "Lucy::Docs::FileLocking",
        make_pod   => { synopsis => $synopsis, },
    );

}

1;