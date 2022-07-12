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

  picker = new Picker(this);
    
  // get home directory name
  dir = get_home_dir();
  //println(dir);

  textAlign(CENTER);
}



void draw()
{
  background(0, 0, 0);

  // obtain files at this directory
  files = get_ls(dir);
  //println(files);
  
  // count the number of files
  numFiles = files.length;
  //println(numFiles);

  // draw files
  int XYsize = int(ceil(sqrt(numFiles)));
  float fileWidth = 100;
  textSize(fileWidth/7);
  
  // draw the boxes and file names
  file = 0;
  for(int xIndex = 0; xIndex < (XYsize+2); xIndex++)
  {
    for(int yIndex = 0; yIndex < XYsize; yIndex++)
    {
      file++;
      if (file < numFiles)
      {
        float w = fileWidth/2;
        String f = files[file];
        pushMatrix();
        translate(width/XYsize, height/XYsize, width/XYsize/2);
        translate(fileWidth*yIndex+w, fileWidth*xIndex, 0);
        translate(0, (fileWidth/4)*((yIndex+1)%2), 0);
        stroke(256, 256, 256);
        noFill();
        {
          picker.start(file);
          box(w, w, w);
          text(f, 0, fileWidth/2, 0);
        }
        popMatrix();
      }
    }
  }
  text(dir, width/2, 40, 0);
}




void mouseClicked()
{
  int id = picker.get(mouseX, mouseY);  // check if a box was selected
  String returnedValues = "";
  if (id > -1)  // if a box was selected
  {
    dir = dir + files[id] + "/";
    returnedValues = cd(dir);
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
      returnedValues = cd(dir);  // go back up one directory
    }
  }
  // println(returnedValues);
}


  
