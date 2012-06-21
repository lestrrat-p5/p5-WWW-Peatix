use inc::Module::Install;

name 'WWW-Peatix';
all_from 'lib/WWW/Peatix.pm';

requires 'WWW::Mechanize';
requires 'LWP::Protocol::https';
requires 'Text::CSV';
recommends 'Text::CSV_XS';

WriteAll;