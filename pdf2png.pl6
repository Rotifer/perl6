#!/usr/bin/env perl6

# Purpose: Convert PDF files to PNG format.

# Use the gs command (Ghostscript) command to convert PDF files to PNG format.
# Assumes Ghostscript is installed and in the user's path
# Creates the output files in the same directory as the input files.
# To Do: Turn into a proper command line utility
# Add chech for gs.

# Installed Ghostscript on Mac using $ brew install ghostscript

# Return a list of files for the given directory and file extension
# by executing "ls -1".
sub get-file-names-for-dir($path, $file-ext='*') {
  my $cmd = 'ls -1 %s/*%s'.sprintf($path, $file-ext);
  say $cmd;
  my $files = qq:x/$cmd/;
  return  $files.split("\n");
}

# Create a hash mapping each of the input list file paths to an output file
# where the input file extension is replaced by the output one. 
sub get-inpu-output-file-map(@file-names, $file-ext-in, $file-ext-out) {
  my %file-map;
  for @file-names -> $file-name-in {
    my $file-name-out = $file-name-in.subst($file-ext-in, $file-ext-out);
    %file-map{$file-name-in} = $file-name-out;
  }
  return %file-map;
}

# Command template for "gs" with place-holders for the output and input file names.
my $cmd = 'gs -sDEVICE=png16m -dTextAlphaBits=4 -r300 -o %s %s';

# Get the input file list.
my @file-names = get-file-names-for-dir('/Users/michaelmaguire/Desktop/foxp3_tcga_survival', 'pdf');
# Get the input-output file names hash mapping.
my %file-in-out-map = get-inpu-output-file-map(@file-names, 'pdf', 'png');

# Loop over the hash and execute the gs command for each iteration.
for %file-in-out-map -> $pair {
  my ($file-name-in, $file-name-out) = ($pair.key, $pair.value);
  my $exit-code = shell "$cmd.sprintf($file-name-out, $file-name-in)";
  if $exit-code == 0 {
    say 'Done!';
  } else {
    say 'Oops!';
  }
}
say "Done!";

