sub respond-to-input {
  my $input = prompt "? ";
  exit if $input eq "quit";
}

say "\n(type 'quit' to quit.)\n";

loop { respond-to-input }
