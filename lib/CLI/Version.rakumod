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
    my sub doit($version, $verbose) {
        my %META; %META := $_ with try DISTRIBUTION.meta;
        my $compiler := Compiler.new;
        say $*PROGRAM.basename
          ~ ' - '
          ~ ($verbose ?? (%META<description> // "") ~ ".\nP" !! 'p')
          ~ 'rovided by '
          ~ (%META<name> // "")
          ~ ' '
          ~ (%META<ver> // "")
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
      ?? my multi sub MAIN(:$version!, :$verbose) {
             doit($version, $verbose)
         }
      !! my multi sub MAIN(:V(:$version)!, :$verbose) {
             doit($version, $verbose)
         }

    BEGIN Map.new   # doesn't actually export anything
}

# vim: expandtab shiftwidth=4
