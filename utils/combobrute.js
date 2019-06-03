'use strict';
/*
 * simple bruteforce intended for alphabetic combination locks
 * usage:
 *   - enter the values on each wheel of the lock into the wheels array
 *   - run the script to generate every possible combination
 * TODO: add a newline to each combo (tr , '\n' <combos.txt > combos-nl.txt)
 * protip:
 *   - grab a dictionary and compare the combos.txt line by line
 *     to pare down the list to real words. For example (using fish shell):
 *       for i in (cat combos-nl.txt)
 *         grep -w $i words_alpha.txt
 *       end
 */

const fs = require('fs');
const outfile = 'combos.txt';

const wheels = {
  1: [  'k',  'l',  'm',  'm',  'o',  'p',  'r',  's',  't',  'w',  ],
  2: [  'k',  'l',  'm',  'm',  'o',  'p',  'q',  'r',  's',  't',  ],
  3: [  'a',  'b',  'c',  'd',  'e',  'f',  'g',  'h',  'i',  'j',  ],
  4: [  'd',  't',  'h',  'e',  'n',  'z',  'l',  'p',  'o',  'r',  ],
  5: [  'a',  'e',  'i',  'o',  'u',  'l',  'm',  'r',  's',  't',  ]
}

function allPossibleCases(arr) {
  if (arr.length === 0) {
    return [];
  }
else if (arr.length ===1){
return arr[0];
}
else {
    var result = [];
    var allCasesOfRest = allPossibleCases(arr.slice(1));  // recur with the rest of array
    for (var c in allCasesOfRest) {
      for (var i = 0; i < arr[0].length; i++) {
        result.push(arr[0][i] + allCasesOfRest[c]);
      }
    }
    return result;
  }

}

const wheelsArr = [ wheels[1], wheels[2], wheels[3], wheels[4], wheels[5], ]
var combinations = allPossibleCases(wheelsArr);

fs.writeFile(outfile, combinations, function(err) {
  if(err) {
    return console.log(err);
  }
  console.log('done! file is saved to ' + outfile);
});
