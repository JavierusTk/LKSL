<!--- This document is written in a "Markdown" language, and is best viewed on https://github.com/LaKraven/LKSL. -->
LaKraven Studios Standard Library [LKSL]
====

## DEPRECATED!
Please note that the LKSL project has now been deprecated, and superceded by [ADAPT](https://github.com/LaKraven/ADAPT).

The LSKL project remains on GitHub mostly for posterity, and the [ADAPT](https://github.com/LaKraven/ADAPT) library (which has been fully redesigned, refined, improved and expanded upon) will receive all future support.

If you haven't already taken a look at [ADAPT](https://github.com/LaKraven/ADAPT), please do so.

## Installation
On *Windows*, don't forget to run **INSTALL.BAT** to register the necessary Environment Variables.

Environment Variables registered by **INSTALL.BAT** on *Windows*:

| Variable Name | Points to Path     |
| ------------- | ------------------ |
| LKSL_HOME     | \                  |
| LKSL_LIB      | \Source\Lib        |
| LKSL_PASCAL   | \Source\Lib\Pascal |


## Features:
|         Feature         | Description                                                                                      | Status                                                          |
| ----------------------- | ------------------------------------------------------------------------------------------------ | --------------------------------------------------------------- |
| Base Types              | Special *Common Base Types* each containing a Thread-Safe Locking Mechanism.                     | Suitable for real-world use (being used in production software) |
| Event Engine            | A *very powerful* system for producing Multi-Threaded, Asynchronous and Event-Driven programs.   | Events, Event Threads and Event Listeners all working well      |
| Generics Collections    | Highly efficient, Thread-Safe Collection Types (*lists, trees etc.*)                             | Suitable for real-world use (being used in production software) |
| High Precision Threads  | A special Thread Base Type designed to provide supremely High Precision Tick Rates.              | Suitable for real-world use (being used in production software) |
| Math Library            | A library for Unit Conversion, special calculation and other useful mathematics routines.        | Early in development                                            |
| Package Engine          | Extension of the Streamables Engine supporting the packaging of files together (a VFS of sorts)  | Planned, not yet implemented.                                   |
| Shared Streams Library  | 100% Thread-Safe Stream Classes (Interfaced too) allowing read/write from multiple Threads.      | Initial Types written and implemented, improvements underway!   |
| Stream Handling Library | Makes working with Streams *much* easier! Handles Deleting, Inserting, Reading and Writing data. | Suitable for real-world use (being used in production software) |
| Streamables Engine      | A system to serialize Object Instances into Streams, and to dynamically reconstitute them, too.  | Suitable for real-world use (being used in production software) |

## Support Matrix:

|         Feature         | Delphi (XE2-XE8) | C++ Builder (XE2-XE8) | FreePascal 3.x+ |
| ----------------------- | ---------------- | --------------------- | --------------- |
| Base Types              | Yes              | Soon                  | Yes             |
| Event Engine            | Yes              | Soon                  | Soon            |
| Generics Collections    | Yes              | Soon                  | Soon            |
| High Precision Threads  | Yes              | Soon                  | Yes             |
| Math Library            | Yes              | Soon                  | Yes             |
| Package Engine          | Soon             | Soon                  | Soon            |
| Shared Streams Library  | Yes              | Soon                  | Yes             |
| Stream Handling Library | Yes              | Soon                  | Yes             |
| Streamables Engine      | Yes              | Soon                  | Soon            |

## Other Platforms currently in Consideration:

|         Feature         | C    | C++  | C#   | Java | PHP  | Python |
| ----------------------- | ---- | ---- | ---- | ---- | ---- | ------ |
| Base Types              | No   | Yes  | Yes  | Yes  | No   | Yes    |
| Event Engine            | Yes  | Yes  | Yes  | Yes  | No   | Yes    |
| Generics Collections    | No   | Yes  | Yes  | Yes  | No   | Yes    |
| High Precision Threads  | Yes  | Yes  | Yes  | Yes  | No   | Yes    |
| Math Library            | Yes  | Yes  | Yes  | Yes  | Yes  | Yes    |
| Package Engine          | Yes  | Yes  | Yes  | Yes  | Yes  | Yes    |
| Shared Streams Library  | Yes  | Yes  | Yes  | Yes  | No   | Yes    |
| Stream Handling Library | Yes  | Yes  | Yes  | Yes  | Yes  | Yes    |
| Streamables Engine      | Yes  | Yes  | Yes  | Yes  | Yes  | Yes    |
*Note: There are no promises with the above table! It depends on who is willing to support what!**

> If there's another platform that you think could benefit from the features of the LKSL, please raise an issue. Better yet, if you feel you can produce a viable LKSL translation (in part or whole) for another programming/scripting language, please consider contributing that work back to this original repository!

## Documentation:
Feel free to take a look at the [Documentation](./Documentation) to learn how the LKSL can be integrated into your systems (or, as the case may be, how your system can be designed to best utilize the features of the LKSL).

You can also find educational articles demonstrating the various features of the LKSL can be found at http://otapi.com.

## License:
See LICENSE.md for the complete, no-nonsense license (and disclaimer). It's a very simple license scheme, enabling you to do anything you want *except* for claiming ownership of the source, or charging for its distribution.

## Donations:
Donations (while by no means mandatory) are always appreciated, and can be made by clicking this button: <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=84FXYZX27EUJL"><img src="https://www.paypalobjects.com/en_US/GB/i/btn/btn_donateCC_LG.gif" alt="[paypal]" /></a>
<!--- If you're reading in a plain-text editor, please copy and paste the Hyperlink into your Browser -->
