// Graphical file manager demonstration
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
//import java.io.InputStreamReader;



String get_home_dir()
{
  // declare variables
  String dir = "/";
  //String result = "";
  File workingDir = new File(dir);  // where to do it - should be full path
  String whoamiResult = "";
  //String[] tokens = {""};
  //String whoami = "";
  
  // find username and form home directory string plus working directory
  whoamiResult = unix("whoami", workingDir, whoamiResult, "");
  //println(whoamiResult);
  dir = "/Users/" + whoamiResult + "/";
  //println(dir);
  return dir;
}
  
  
String[] get_ls(String dir)
{
  File workingDir = new File(dir);
  String result = "";
  
  // obtain the ls result
  result = unix("ls", workingDir, result, "\n");
  // print(result + "\t");
  
  // parse ls result into an array
  String[] lsResult = split(result, '\n');
  // println(lsResult);
  return lsResult;
}



String unix(String commandToRun, File workingDir, String returnedValues, String separator)
{
  // run the command!
  try {

    // complicated!  basically, we have to load the exec command within Java's Runtime
    // exec asks for 1. command to run, 2. null which essentially tells Processing to 
    // inherit the environment settings from the current setup (I am a bit confused on
    // this so it seems best to leave it), and 3. location to work (full path is best)
    Process p = Runtime.getRuntime().exec(commandToRun, null, workingDir);

    // variable to check if we've received confirmation of the command
    int i = p.waitFor();

    // if we have an output, print to screen
    if (i == 0) {

      // BuffererdReader used to get values back from the command
      BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));

      // read the output from the command
      String returned = "";
      while ( (returned = stdInput.readLine()) != null) {
        returnedValues = returnedValues + separator + returned;
      }
    }

    // if there are any error messages but we can still get an output, 
    // they print here
    else {
      BufferedReader stdErr = new BufferedReader(new InputStreamReader(p.getErrorStream()));
      println("error:  " + stdErr);
      // if something is returned (ie: not null) print the result
      String returned = "";
      while ( (returned = stdErr.readLine()) != null) {
        returnedValues = returnedValues + separator + returned;
      }
    }
  }

  // if there is an error, let us know
  catch (Exception e) {
    println("Error running command!");  
    println(e);
  }

  // when done running command, quit
  return returnedValues;
}



// change directories
String cd(String dir)
{
  String returnedValues = "";
  String separator = "\n";
  File workingDir = new File(dir);
  
  returnedValues = unix("cd", workingDir, returnedValues, separator);
  return returnedValues;
}
