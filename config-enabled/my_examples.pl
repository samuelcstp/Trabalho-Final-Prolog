:- module(my_examples, []).

:- multifile swish_config:config/2.
:- multifile user:file_search_path/2.

user:file_search_path(example, '/data').
