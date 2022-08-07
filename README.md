[![Actions Status](https://github.com/lizmat/CLI-Version/actions/workflows/test.yml/badge.svg)](https://github.com/lizmat/CLI-Version/actions)

NAME
====

CLI::Version - add -V / --version parameters to your script

SYNOPSIS
========

```raku
proto sub MAIN(|) {*}
use CLI::Version $?DISTRIBUTION, &MAIN;

# alternately:
use CLI::Version $?DISTRIBUTION, proto sub MAIN(|) {*}

# only allow --version
use CLI::Version $?DISTRIBUTION, proto sub MAIN(|) {*}, "long-only";
```

DESCRIPTION
===========

CLI::Version adds a `multi sub` candidate to the `&MAIN` function in your script, that will trigger if the script is called with `-V` or `--version` arguments **only**.

For instance, in the [App::Rak](https://raku.land/zef:lizmat/App::Rak) distribution, which provides a `rak` CLI, calling `rak -V` will result in something like:

```bash
    $ rak -V
    rak - provided by App::Rak 0.0.3, running Raku 6.d on Rakudo 2022.06.
```

If the candidate is triggered, it will exit with the default value for `exit` (which is usually **0**).

If you would also like to see the description of the module, you can add `--verbose` as an argument: then you get something like:

```bash
    $ rak -V --verbose
    rak - a CLI for searching strings in files.
    Provided by App::Rak 0.0.3, running Raku 6.d with Rakudo 2022.06.27.
```

By specifying a true value as the 3rd argument in the `use` statement, will cause only `--version` to trigger the candidate.

IMPLEMENTATION NOTES
====================

Due to the fact that the `$?DISTRIBUTION` and `&MAIN` of the code that uses this module, can **not** be obtained by a public API, it is necessary to provide them in the `use` statement. This need may disappear in future versions of the Raku Programming Language.

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/CLI-Version . Comments and Pull Requests are welcome.

If you like this module, or what I’m doing more generally, committing to a [small sponsorship](https://github.com/sponsors/lizmat/) would mean a great deal to me!

COPYRIGHT AND LICENSE
=====================

Copyright 2022 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.
