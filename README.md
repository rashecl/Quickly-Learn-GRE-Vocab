# Quickly-Learn-GRE-Vocab
This program is intended to help you rapidly learn GRE vocabulary words. 
It uses a database of common GRE words and associated groups from: 
https://quizlet.com/5821214/kaplan-gre-word-groups-flash-cards/

You will need a working copy of matlab on your computer to run this code.
The program is intuitive, and all you have to do is download/clone this repository and run 'WordAssociation.m'. All your training data is saved after each trial, so you can close the program whenever. In fact, this is advisable, because your response latencies are recorded and utilized in your final diagnostic. 

**If you are curious about how this program works:**
  This program learns words you don't know and repeats those words until you achieve a threshold score for each word.
By default, the threshold is set to 1 (the lowest setting), but you can programmtically change the threshold to however high you want in line 3 of the code. 
  For each word you will get 1 point for a correct answer, -1 for having to look up the definition, and -2 if you get it wrong. Thus, your score on each trial can range from 1 (if you didn't need help and got it right) to -3 (if you got help and didn't get it right. Obviously, some words have multiple definitions and the GRE may prefer the second definitions (like for pedestrian which means boring), but only the first one from Oxford English Dictionary (OED) is presented. **Clicking the definition button opens a link to the definition(s) in OED, which includes some synonyms and sentence examples-all of which are useful for the GREs. (Note: This supplemental info does not impact your score, so click away!)**
  Because the threshold to completion of training is 1pt for all words, it means that if you got help and got it right (-1+1=0) the word will be repeated. If you got help and still got it wrong (-1-2=-3) you will have to repeat the word 4 times without any help (1+1+1+1) to reach your threshold for the word. Additionally, the latency for each response is recorded, which at the end will be presented at the end of training.
  You will see the cell variable 'Words' that keeps an ongoing log of your individualized training after each click. A simplified version of this will be displayed at the end in order of what you found most challenging to least. This can be used for your diagnostic purposes, but also for a possible definition matching version of this software, depending on how people like the program. Send comments and feedback to my gmail: rashecl
  
** Extras: **
  Also included in this repository is code to programmtically define the words into the database the WordAssociation code utilizes by parsing the definitions from OED's website. This is not essential unless you want to create a different word list, as the default database is loaded into the program to get you up and running. 
  
MIT License

Copyright (c) 2017 Rashed Harun

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
  
