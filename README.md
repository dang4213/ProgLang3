# ProgLang3

Dan Gay and Elijah Abney

## Part 1
  Our part one runs correctly or the given and our own test cases.
  It uses recursion to find all buttons and press them, only searching
  for the lowest ID button first. After, it will recursively search for the
  exit.

  It uses the recommended method of keeping track of visited cells and not
  revisiting these.

  Due to our order of recursion, the solution path is generally not the shortest
  or the same as the given example; however, it is still a valid and correct path.

  We only implemented type c puzzles, as per the specifications, if it can reliably
  solve c puzzles it should work for any type. Note however that if buttons in
  mazeInfo have anonymous IDs, the solver may not solve them, but according to the
  hw pdf, this should never happen.

## Part 2
  Our part two also runs correctly for the given test and our own test cases.

  At the top is a database of the entire english grammars we are allowed to accept.
  Our program will parse the input file with the given code, and then go through each
  sentence.

  If the sentence follows one of the two forms and only uses the allowed words, then
  the program will check if the sentence specifies a valid move, and move einstein
  accordingly.

  With an invalid sentence, the program just moves to the next one. With an invalid
  move, the program aborts, as specified in the hw pdf.

  As things are parsed, output if sent to the output file.
