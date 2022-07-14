// 3D graphical file manager demonstration
// started Jul 9 2022
// Lester Crossman Hall
// with code by Jeff Thompson, obtained from processing.org forum


//code from here: https://forum.processing.org/one/topic/running-bash-script-from-processing.html
/*
 * RUN UNIX COMMANDS IN PROCESSING
 * Jeff Thompson
 * Adapted and annotated from code by Wharfie
 * http://www.computing.net/answers/unix/run-unix-command-thr-java-program-/5887.html
 * July 2011
 *
 * Runs Unix commands from within Processing.  This can be *super* helpful for
 * doing complex operations on folders such as copying or compressing multiple 
 * files.  A simple command can make quick work of what would otherwise be a 
 * cumbersome task in Processing and will likely be much quicker than any Java 
 * implementation of the same process.
 *
 * You will likely need to specify the full path where you want to work, unless your
 * location is relative to your sketch.  For example: /Users/jeffthompson/Desktop
 *
 * Suggestions to try:
 *   whoami                            prints username currently logged on
 *   ls                                this lists all files in the particular location
 *   wc -w filename.extension          this counts words in a particular file
 *   cp sourcefile.ext destfile.txt    makes a copy of a file to a new one
 *   ./yourBashScript.sh               run a bash script (allowing nested and more complex commands)
 *
 * For more ideas, look at the excellent SS64 site: http://ss64.com/bash
 * 
 * www.jeffreythompson.org
 */
 
 //addition from here: https://forum.processing.org/one/topic/unexpected-token-import-17-5-2013.html
import java.io.InputStreamReader;

// get library for selecting items
import picking.*;



// global variables
String[] files = {"0", "1"};
int numFiles = 0;
String dir = "";
Picker picker;
int file = 0;


void setup() {
  size(1024, 768, P3D); 
  frameRate(10);

  picker = new Picker(this);
    
  // get home directory name
  dir = get_home_dir();
  //println(dir);
}



void draw()
{
  background(0, 0, 0);

  // obtain files at this directory
  files = get_ls("-F", dir);
  //println(files);
  
  // count the number of files
  numFiles = files.length;
  //println(numFiles);

  // draw files
  float XYsize = sqrt(numFiles);  // determine the size of the array as the squareroot of number of files
  float fileWidth = 100;  // set the spacing of the files
  float w = fileWidth/2;  // set the size of the boxes
  String filename = "";  // set scope of this variable for later use
  
  // draw the boxes and file names
  file = 0;  // clear the file index
  for(int xIndex = 0; xIndex < XYsize; xIndex++)  // loop through horizontal display numbers
  {
    for(int yIndex = 0; yIndex < XYsize; yIndex++)  // loop through vertical display numbers
    {
      // start with a blank filled box
      noFill();
      // display the files as boxes with name underneath
      if (file < numFiles)  // stop at number of files
      {
        // set file information
        filename = files[file];  // get the name of the next file
        
        // obtain the final character and color it based on type
        String[] directory = split(filename, "/");
        if (directory.length != 1)  // this is a directory
        {
          String[] link = split(filename, "@");
          if (link.length == 1)  // this is a directory
          {
            stroke(255, 0, 0);  // set directory color
          }
          else
          {
            stroke(0, 0,256);  // set link color
          }
        }
        else  // this is a file
        {
          stroke(0, 256, 0);  // set file color
        }
        //files = get_ls("A", dir);
        file++;
        // println(file);

        pushMatrix();
        translate(width/XYsize, height/XYsize, width/XYsize/2);
        translate(fileWidth*yIndex, fileWidth*xIndex, 0);
        translate(w*3/2, (fileWidth/4)*((yIndex+1)%2), 0);
        {
          rectMode(CENTER);
          picker.start(file);
          box(w, w, w);
            
          textAlign(CENTER);
          textSize(fileWidth/7);
          text(filename, 0, fileWidth/2, 0);
        }
        popMatrix();
      }
    }
  }
  
  // draw the path with directory name at the top of the window
  textAlign(CENTER);
  textSize(fileWidth/4);
  text(dir, width/2, 40, 0);
}




void mouseClicked()
{
  int id = picker.get(mouseX, mouseY);  // check if a box was selected
  if (id > -1)  // if a box was selected
  {
    dir = dir + files[id-1];
    cd(dir);
  }
  else  // if no box was selected
  {
    String[] folders = split(dir, '/');
    if(folders.length > 0)
    {
      dir = "/";
      for (int folder = 1; folder < (folders.length-2); folder++)
      {
        dir = dir + folders[folder] + "/";
      }
      cd(dir);  // go back up one directory
    }
  }
  // println(returnedValues);
}


  
