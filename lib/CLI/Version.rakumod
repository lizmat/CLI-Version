my sub meh(str $message) {
    note "CLI::Version: $message.";
    exit 1;
}

multi sub EXPORT() {
    meh q/must specify '$?DISTRIBUTION, &MAIN' as arguments/;
}
multi sub EXPORT($first) {
    meh Callable.ACCEPTS($first)
      ?? 'must specify $?DISTRIBUTION as the first argument'
      !! !$first.can('meta')
        ?? "first argument must provide a 'meta' method"
        !! 'must also specify the &MAIN sub as the second argument';
}
multi sub EXPORT(\DISTRIBUTION, &proto, $long-only = "") {
    meh "script '$*PROGRAM-NAME' does not appear to be part of a distribution"
      if DISTRIBUTION =:= Nil;
    meh "first argument must provide a 'meta' method"
      if DISTRIBUTION.can('meta') == 0;

    my sub doit($version, $verbose) {
        my %meta     := DISTRIBUTION.meta;
        my $compiler := Compiler.new;
        say $*PROGRAM.basename
          ~ ' - '
          ~ ($verbose ?? "%meta<description>.\nP" !! 'p')
          ~ 'rovided by '
          ~ %meta<name>
          ~ ' '
          ~ %meta<ver>
          ~ ', running '
          ~ $*RAKU.name
          ~ ' '
          ~ $*RAKU.version
          ~ ' with '
          ~ $compiler.name.tc
          ~ ' '
          ~ $compiler.version.Str.subst(/ '.' g .+/)
          ~ '.'
        ;
        exit;
    }

    &proto.add_dispatchee: $long-only
      ?? my multi sub MAIN(Bool:D :$version!, Bool :$verbose) {
             doit($version, $verbose)
         }
      !! my multi sub MAIN(Bool:D :V(:$version)!, Bool :$verbose) {
             doit($version, $verbose)
         }

    BEGIN Map.new   # doesn't actually export anything
}

=begin pod

=head1 NAME

CLI::Version - add -V / --version parameters to your script

=head1 SYNOPSIS

=begin code :lang<raku>

proto sub MAIN(|) {*}
use CLI::Version $?DISTRIBUTION, &MAIN;

# alternately:
use CLI::Version $?DISTRIBUTION, proto sub MAIN(|) {*}

# only allow --version
use CLI::Version $?DISTRIBUTION, proto sub MAIN(|) {*}, "long-only";

=end code

=head1 DESCRIPTION

CLI::Version adds a C<multi sub> candidate to the C<&MAIN> function in
your script, that will trigger if the script is called with C<-V> or
C<--version> arguments B<only>.

For instance, in the L<App::Rak|https://raku.land/zef:lizmat/App::Rak>
distribution, which provides a C<rak> CLI, calling C<rak -V> will
result in something like:

=begin code :lang<bash>

    $ rak -V
    rak - provided by App::Rak 0.0.3, running Raku 6.d on Rakudo 2022.06.

=end code

If the candidate is triggered, it will exit with the default value for
C<exit> (which is usually B<0>).

If you would also like to see the description of the module, you can add
C<--verbose> as an argument: then you get something like:

=begin code :lang<bash>

    $ rak -V --verbose
    rak - a CLI for searching strings in files.
    Provided by App::Rak 0.0.3, running Raku 6.d with Rakudo 2022.06.27.

=end code

By specifying a true value as the 3rd argument in the C<use>
statement, will cause only C<--version> to trigger the candidate.

=head1 IMPLEMENTATION NOTES

Due to the fact that the C<$?DISTRIBUTION> and C<&MAIN> of the code that
uses this module, can B<not> be obtained by a public API, it is necessary
to provide them in the C<use> statement.  This need may disappear in
future versions of the Raku Programming Language.

=head1 AUTHOR

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/CLI-Version .
Comments and Pull Requests are welcome.

If you like this module, or what I’m doing more generally, committing to a
L<small sponsorship|https://github.com/sponsors/lizmat/>  would mean a great
deal to me!

=head1 COPYRIGHT AND LICENSE

Copyright 2022 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
