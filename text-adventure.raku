class TextAdventure {
  has @!position = [0, 1];
  has $!map;

  method main {
    say "Type 'quit' to quit.";
    $.map.access-position(@!position).look;
    loop { $.respond-to-input }
  }

  class Place {
    has $.description;
    has $.name;
    has $.seen;

    method new($name, $description) {
      self.bless(:$name, :$description, :!seen);
    }

    method look {
      say ($!seen ?? $!name !! $!description);
      $!seen = True;
    }
  }

  # maps are just multi-dimensional arrays.
  # this is a very thin abstraction on top (too thin).
  class SimpleMap {
    has @.multi-dimensional-array;

    method is-valid-position(@position) {
      so $.access-position(@position);
    }

    method new-position(@position, @increment) {
      my @new-position = @position <<+>> @increment;
      $.is-valid-position(@new-position) ?? @new-position !! @position;
    }

    method access-position(@position) {
      my $m = @!multi-dimensional-array;
      for @position -> $p {
        $m = $m[$p];
      }
      $m;
    }
  }

  method map {
    $!map or $!map = do {
      my $grid = q:to/END/;
        ABCD
        E F
        G HI
        JKLM
          N
          O
          P
        END

      my %map-descriptions = A => ("shaded wood", "You are in a shaded wood."),
                             B => ("hill", "You've climbed a hill."),
                             C => ("paths", "You see two paths --one well worn and level, the other sharp and twisted.."),
                             D => ("river", "A roaring river blocks your way."),
                             E => ("thorny bramble", "You are in a thorny bramble."),
                             F => ("twisted path", "You are on a twisted path with sharp rocks and little footing."),
                             G => ("small clearing", "You are in a small clearing."),
                             H => ("NW corner of massive square", "You are on the NW corner of a massive square."),
                             I => ("NE corner of massive square", "You are on the NE corner of a massive square."),
                             J => ("road", "You've happened upon a road"),
                             K => ("intersection", "The road joins another road that meanders south."),
                             L => ("SW corner of massive square", "You are on the SW corner of a massive square."),
                             M => ("SE corner of massive square", "You are on the SE corner of a massive square."),
                             N => ("shaded road", "Shaded road."),
                             O => ("more road", "More road."),
                             P => ("house", "A house!");

      my @map = [];
      for $grid.lines -> $line {
        @map.push([]);
        for $line.split('') -> $char {
          my $args = %map-descriptions{$char};
          my $place = $args ?? Place.new(|$args) !! Any;
          @map[*-1].push($place);
        }
      }
      SimpleMap.new(multi-dimensional-array => @map);
    };
  }

  constant %POSITION-INCREMENT = :n(-1,0), :s(1,0), :e(0,1), :w(0,-1);

  method walk(*@directions) {
    unless @directions {
      say "Please specify a direction.";
      return;
    }

    my @last-position = @!position;
    for @directions -> $direction {
      my $increment = %POSITION-INCREMENT{$direction};
      unless $increment {
        my @keys = %POSITION-INCREMENT.keys;
        my $repeated_key = "@keys[0] @keys[0] @keys[0]";
        say "I don't understand. (try: walk {@keys.join(", walk ")}, walk {$repeated_key}, etc.)";
        return
      }
      say "walking $direction...";
      @!position = $.map.new-position(@!position, $increment);
      say "  ❌ couldn't walk that direction!" if @!position ~~ @last-position;
      @last-position = @!position;
    }

    $.map.access-position(@!position).look;
  }

  method quit(*@_) {
    say "Bye!";
    exit;
  }

  constant %COMMAND-TO-METHOD-MAP = walk => "walk",
                                    quit => "quit";

  method parse-input($input-string) {
    $input-string.trim.split(/\s+/);
  }

  method respond-to-input {
    my $input = prompt "? ";
    my ($command, *@args) = $.parse-input($input);
    my $m = %COMMAND-TO-METHOD-MAP{$command};
    return self."$m"(|@args) if $m;
    say "I don't understand. (try: {%COMMAND-TO-METHOD-MAP.keys.join(", ")})";
  }

  method debug($string) {
    say $string;
  }
}

TextAdventure.new.main
