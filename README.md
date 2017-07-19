NAME
====

TextDates_sv 

SYNOPSIS
========

    use Swedish::TextDates_sv;

    # Let us pretend that todays date is 2017-07-12.
    # First the date:
    my $date = Whole-Date-Names_sv.new(whole_date => DateTime.now.yyyy-mm-dd);
    say $date.date-to-text; # --> (2017 juli tolfte) 

    # Day of week.
    my $day = Day-Of-Week-Name_sv.new(day_of_week_number => DateTime.now.day-of-week);
    say $day.get-day-name_sv; # --> onsdag 

    # Day in week in short form.
    my $shortday = Day-Of-Week-Name_sv.new(day_of_week_number => DateTime.now.day-of-week);
    say $shortday.get-day-name-short_sv; # --> ons

DESCRIPTION
===========

TextDates_sv transforms the digits in a date or the weekday number to the Swedish text equivalent.  If an invalid date or day of week is provided, for example 2017-02-31, TextDates_sv will print a message to `$*ERR` and exit.

INSTALLATION
============

With zef:

zef install https://github.com/svekenfur/Swedish-TextDates_sv.git 

USAGE
=====

See the **SYNOPSIS** above, that is pretty much all of it.

BUGS
====

TextDates_sv has only been tested on a machine with MS Windows 7 and Rakudo 2017.04.3. To report bugs or request features, please use https://github.com/svekenfur/Swedish-TextDates_sv/issues.

AUTHOR
======

Sverre Furberg

LICENCE
=======

You can use and distribute this module under the terms of the The Artistic License 2.0.
