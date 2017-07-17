# TextDates_sv.pm6
# Transforms a date or a day of week to the text equivalent in Swedish.
#

unit module TextDates_sv:ver<0.1.0>:auth<Sverre Furberg (skf@sverro.se)>;

# The names of weekdays, months and day of months in Swedish.
# The beginning '0' in every array is just there to occupy the first index (@array[0]).
my @day_name_sv = <0 måndag tisdag onsdag torsdag fredag lördag söndag>;
my @day_name_short_sv = <0 mån tis ons tors fre lör sön>;
my @month_name_sv = 
        <0 januari februari mars april maj juni juli augusti september november december>;
my @day_of_month_name_sv = 
        <0 första andra tredje fjärde femte sjätte sjunde åttonde nionde
        tionde elfte tolfte trettonde fjortonde femtonde sextonde sjuttonde
        artonde nittonde tjugonde tjugoförsta tjugoandra tjugotredje
        tjugofjärde tjugofemte tjugosjätte tjugosjunde tjugoåttonde
        tjugonionde trettionde trettioförsta>;

# Transform the digit of a day of week to 
# the corresponding Swedish weekday.
class Day-Of-Week-Name_sv is export {
    has Int $.day_of_week_number;

    method get-day-name_sv {
        day-check ($!day_of_week_number);
        @day_name_sv[$!day_of_week_number];
    }

    method get-day-name-short_sv {
        day-check ($!day_of_week_number);
        @day_name_short_sv[$!day_of_week_number];
    }
}

# Transform the digits of a date in the form yyyy-mm-dd to 
# the corresponding Swedish names 
# (returns year, month and day of month in a list).
class Whole-Date-Names_sv is export {
    has Str $.whole_date;
    has Str $.year;
    has Str $.month_number;
    has Str $.day_of_month_number;

    method date-to-text {
        ($!year, $!month_number, $!day_of_month_number) = split('-', $!whole_date);
        my Int $year = $!year.Int;
        my Int $month_nr = $!month_number.Int;
        my Int $day_of_month_nr = $!day_of_month_number.Int;
        day-of-month-check $day_of_month_nr, $month_nr, $year;
        return $year, @month_name_sv[$month_nr], @day_of_month_name_sv[$day_of_month_nr];
    }
}

# *** Subs ***

# Is the month number valid?
sub month-check (Int $m_nr) {
    if $m_nr < 1 || $m_nr > 12 {
        note "Out of range. There is only twelve months in a year (1-12).";
        exit;
    }
}

# Is the day-of-week valid?
sub day-check (Int $d_nr) {
    if $d_nr < 1 || $d_nr > 7 {
        note "Out of range. There is only seven days in a week (1-7).";
        exit;
    }
}

# Is the day-of-month number valid?
# The more data sent, the better is the check of validity.
sub day-of-month-check (Int $dom_nr, Int $m_nr?, Int $y?) {
    my $dom_max = 31;
    # The first index in @m_lenght is not a month, hence the zero.
    my @m_lenght = (0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);

    if $m_nr {
        $dom_max = @m_lenght[$m_nr];
    }
    # February check. 28 or 29 days?
    if $y && $m_nr {
        if $m_nr == 2 {
            if DateTime.new(:year($y)).is-leap-year {
                $dom_max = 29;
            }
        }
    }

    if $dom_nr < 1 || $dom_nr > $dom_max {
        note "The day of month is out of range (1-{$dom_max})";
        exit;
    }
}

=begin pod

=head1 NAME

TextDates_sv 

=head1 SYNOPSIS

=begin code
use TextDates_sv;

# Lets pretend that todays date is 2017-07-12.
# First the date.
my $date = Whole-Date-Names_sv.new(whole_date => DateTime.now.yyyy-mm-dd);
say $date.date-to-text; # --> (2017 juli tolfte) 

# Now the day of week.
my $day = Day-Of-Week-Name_sv.new(day_of_week_number => DateTime.now.day-of-week);
say $day.get-day-name_sv; # --> onsdag 

# At last the day in week in short form.
my $shortday = Day-Of-Week-Name_sv.new(day_of_week_number => DateTime.now.day-of-week);
say $shortday.get-day-name-short_sv; # --> ons

=end code

=head1 DESCRIPTION

TextDates_sv transforms the digits in a date or the weekday number to the Swedish text equivalent. 
If an invalid date or day of week is provided, for example 2017-02-31, TextDates_sv will print a message to C<$*ERR> and exit.

=head1 INSTALLATION

With zef:

K<zef install https://github.com/svekenfur/Swedish-TextDates_sv.git> 

=head1 USAGE

See the B<SYNOPSIS> above, that is pretty much all of it.

=head1 BUGS

TextDates_sv has only been tested on a machine with MS Windows 7 and Rakudo 2017.04.3. To report bugs or request features, please use https://github.com/svekenfur/Swedish-TextDates_sv/issues.

=head1 AUTHOR

Sverre Furberg

=head1 LICENCE

You can use and distribute this module under the terms of the The Artistic License 2.0.

=end pod
