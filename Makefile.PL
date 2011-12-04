use inc::Module::Install;
name 'XML-XPathBuilder';
all_from 'lib/XML/XPathBuilder.pm';
readme_from 'lib/XML/XPathBuilder.pm';

requires 'Test::Most';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;

