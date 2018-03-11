\name{NEWS}
\title{ecospace News}
\encoding{UTF-8}

\section{Changes in version 1.4.1 (2018-03-11)}{
  \itemize{
    \item Change how FD::dbFD is called to allow additional user control via ... [ellipses].
  }
}

\section{Changes in version 1.3.1 (2018-03-05)}{
  \itemize{
    \item Add warning to create_ecospace when number of character states you provide does not match those in the provided weight.file. (Thanks for Edicson Parra Sanchez for catching the error.)
    \item Add warning to calc_metrics when Smax provided is greater than size of sample.
    \item create_ecospace now correctly labels headings for factor characters.
  }
}

\section{Changes in version 1.2.4 (2018-02-18)}{
  \itemize{
    \item Corrected examples for rbind_listdf.
    \item Functions reformatted to Google / Hadley style.
  }
}

\section{Changes in version 1.2.3 (2018-02-17)}{
  \itemize{
    \item Change working directory reset so no longer permanently changes wd to temp dir.
    \item Faster examples.
  }
}

\section{Changes in version 1.2.2 (2017-11-13)}{
  \itemize{
    \item Moved (outside the loop) returned value when 'increm'=TRUE for improved handling of unusual data sets.
  }
}

\section{Changes in version 1.2.1 (2017-11-05)}{
  \itemize{
    \item Addition of 'increm' argument to calc_metrics() for those wishing to only calculate statistics on the entire sample (instead of incrementally). (Thanks to Craig McClain, Felipe Opazo, Stewart Edie, and Katie Collins for the recommendation.)
    \item Improved descriptions of statistics in calc_metrics help file
    \item Fixing miscellaneous typos
  }
}

\section{Changes in version 1.1.5 (2017-03-11)}{
  \itemize{
    \item Text updates to Vignette
  }
}

\section{Changes in version 1.1.4 (2017-02-20)}{
  \itemize{
    \item Text updates to Vignette
  }
}

\section{Changes in version 1.1.3 (2017-02-19)}{
  \itemize{
    \item First draft of Vignette
    \item Improved NEWS documentation
  }
}

\section{Changes in version 1.1.1 (2017-01-06)}{
  \itemize{
    \item Slightly faster calculation of H, life habit richness in calc_metrics()
    \item Minor fixes: typos in documentation and updated references
  }
}

\section{version 1.0.1 (2015-10-29)}{
  \itemize{
    \item First release
  }
}
