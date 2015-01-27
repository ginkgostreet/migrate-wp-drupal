<?php
/***
 * Echo with timestamp.
 * includes a line-break 
 ***/
function show_user($msg, $new_line = true) {
  system('echo -n '.escapeshellarg(ESC_WHITE.date('d-m-y@h:m:sa').' '.ESC_RESET));
  $opt = ($new_line)? '' : '-n';
  system('echo '.$opt.' '.escapeshellarg($msg.ESC_RESET));
}

/*** Terminal Escape Sequences ***/
/*** use with system('echo '.escapeshellarg($message)); ***/
define('ESC_BOLD', '\\033[1m');
define('ESC_PURPLE', '\\033[35m');
define('ESC_NOCOLOR', '\\033[0m');
define('ESC_RESET', ESC_NOCOLOR);
define('ESC_RED', '\\033[31m');
define('ESC_LT_RED', '\\033[1;31m');
define('ESC_GREEN', '\\033[32m');
define('ESC_LT_GREEN', '\\033[1;32m');
define('ESC_BLUE', '\\033[34m');
define('ESC_YELLOW', '\\033[1;33m');
define('ESC_WHITE', '\\033[1;37m');
/*
Black       0;30     Dark Gray     1;30
Blue        0;34     Light Blue    1;34
Green       0;32     Light Green   1;32
Cyan        0;36     Light Cyan    1;36
Red         0;31     Light Red     1;31
Purple      0;35     Light Purple  1;35
Brown       0;33     Yellow        1;33
Light Gray  0;37     White         1;37
*/

/***
 * generate a command line confirmation
 * stops execution if response is not 'y'
 * callback is called for negative user response
 ***/
function user_confirm_or_exit($prompt, $callback_on_cancel='') {
   if (user_confirm($prompt)) {
    if (is_callable($callback_on_cancel)) call_user_func($callback_on_cancel);
    system('echo '.escapeshellarg(ESC_YELLOW.ESC_BOLD.'Exiting.'.ESC_RESET));
    exit (0);
  }
  return true;
}

/***
 * generate a command line confirmation
 ***/
function user_confirm($prompt) {
  system('echo '.escapeshellarg($prompt)); flush();
  $confirmation = trim( fgets(STDIN) );
  return ( $confirmation !== 'y' );
}
