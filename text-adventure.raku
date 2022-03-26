sub walk(*@directions) {
  unless @directions {
    say "Please specify a direction.";
    return;
  }

  for @directions -> $direction {
    say "walking $direction...";
  }
}

sub quit(*@_) {
  say "Bye!";
  exit;
}

sub parse-input($input-string) {
  $input-string.trim.split(/\s+/);
}

my %command-to-method-map = walk => &walk,
                            quit => &quit;
sub respond-to-input {
  my $input = prompt "? ";
  my ($command, *@args) = parse-input $input;
  %command-to-method-map{$command}(|@args);
}

say "Type 'quit' to quit.";

loop { respond-to-input }
