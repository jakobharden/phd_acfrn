# Auto-correlation function estimation with reduced impact of noise

## Abstract

In traditional signal analysis, signal power and signal-to-noise ratio are estimated using the signal's stochastic properties. Those are related to a signal's auto-correlation function (ACF). Assuming that signal and noise are uncorrelated wide-sense stationary stochastic processes, the signal power can be obtained by subtracting the noise power from the signal's power in noise. This demands auxiliary data exclusively consisting of noise.
However, there are situations where signal areas that only contain noise are difficult to identify or only little data is available. In such cases, considerable losses in accuracy may have to be accepted when estimating the signal power.
The method introduced here promises to significantly reduce the influence of noise in ACF estimation without the need for auxiliary noise data. The technique involves replacing the ACF magnitudes around the Center-lag area with a regression polynomial. In its initial design, the method applies to damped, sinusoidal signals.
The numerical study presented below yields promising results. It demonstrates that the method can provide reliable signal power estimates for typical applications, making it a practical and valuable tool.

> [!NOTE]
> The entire content of this repository was conceived, implemented and tested by Jakob Harden using the scientific numerical programming language of GNU Octave 6.2.0 and TeXlive/TeXStudio.


## Table of contents

- [License](#license)
- [Prerequisites](#prerequisites)
- [Directory and file structure](#directory-and-file-structure)
- [Installation instructions](#installation-instructions)
- [Usage instructions](#usage-instructions)
- [Help and Documentation](#help-and-documentation)
- [Related data sources](#related-data-sources)
- [Related software](#related-software)
- [Revision and release history](#revision-and-release-history)


## License

Copyright 2024 Jakob Harden (jakob.harden@tugraz.at, Graz University of Technology, Graz, Austria)

This file is part of the PhD thesis of Jakob Harden.

All GNU Octave function files (\*.m) are licensed under the *GNU Affero General Public Licence v3.0*. See also licence information file "LICENSE".

All other files are licensed under the *Creative Commons Attribution 4.0 International* licence. See also licence information: [Licence deed](https://creativecommons.org/licenses/by/4.0/deed.en)


## Prerequisites

To be able to use the scripts, GNU Octave 6.2.0 (or a higher version) need to to be installed.
GNU Octave is available via the package management system on many Linux distributions. Windows users have to download the Windows version of GNU Octave and to install the software manually.

[GNU Octave download](https://octave.org/download)


To compile the LaTeX documents in this repository a TeXlive installation is required. The TeXlive package is available via the package management system on many Linux distributions. Windows users have to download the Windows version of TeXlive and to install the software manually.

[TeXlive download](https://www.tug.org/texlive/windows.html)

> [!TIP]
> **TeXStudio** is a convinient and powerful solution to edit TeX files!


## Directory and file structure

GNU Octave script files (\*.m) are written in the scientific programming language of GNU Octave 6.2.0. LaTeX files (\*.tex) are written with compliance to TeXlive version 2020.20210202-3. Text files are generally encoded in UTF-8.

```
acfrn   
├── latex   
│   └── test_acfnr   
│       ├── adaptthemePresRIP.tex   
│       ├── biblio.bib   
│       ├── main.tex   
│       └── oct2texdefs.tex   
├── octave   
│   ├── results   
│   │   └── test_acfrn   
│   │       ├── noise_Nsmp20480_Nmc500.oct   
│   │       ├── *.oct   
│   │       ├── *.ofig   
│   │       ├── *.png   
│   │       └── *.tex   
│   ├── struct   
│   │   ├── README.txt   
│   │   ├── struct_objattrib.m   
│   │   ├── struct_objdata.m   
│   │   └── struct_objref.m   
│   ├── tex   
│   │   ├── README.txt   
│   │   ├── tex_def_csvarray.m   
│   │   ├── tex_def_dotarray.m   
│   │   ├── tex_def_scalar.m   
│   │   ├── tex_def_tabarray.m   
│   │   ├── tex_def_tabmatrix.m   
│   │   ├── tex_serialize.m   
│   │   ├── tex_settings.m   
│   │   ├── tex_struct_export.m   
│   │   ├── tex_struct.m   
│   │   ├── tex_struct_objattrib.m   
│   │   ├── tex_struct_objdata.m   
│   │   └── tex_struct_objref.m   
│   ├── tools   
│   │   ├── tool_est_acf_period.m   
│   │   ├── tool_est_acfrn.m   
│   │   ├── tool_gen_noise.m   
│   │   ├── tool_gen_sinusoidal1.m   
│   │   ├── tool_plot_errorbar_extended.m   
│   │   ├── tool_plot_labelgroups.m   
│   │   ├── tool_plot_labelseries.m   
│   │   ├── tool_plot_perfassmat.m   
│   │   ├── tool_plot_vsep.m   
│   │   ├── tool_scale_noise2snr.m   
│   │   └── tool_stats_dmat.m   
│   ├── variations   
│   │   └── var_param5mc.m   
│   ├── init.m   
│   ├── test_acfrn.m   
│   └── wrapper_acfrn_pvar.m   
├── published   
├── LICENSE   
├── README.html   
└── README.md   
```

- **acfrn** ... main program directory
  - *LICENSE* ... AGPLv3 licence information file
  - *README.md* ... this file, information about the program
  - *README.html* ... html version of this file
- **acfrn/latex/test\_acfrn** ... directory, LaTeX documents, presentation slides (CC BY-4.0)
  - *adaptthemePresRIP.tex* ... file, LaTeX beamer class configuration
  - *biblio.bib* ... file, bibliography
  - *main.tex* ... file, main LaTeX document, presentation source code
  - *oct2texdefs.tex* ... file, conviniently import field data from GNU Octave data structures into LaTeX documents
- **acfrn/published** ... directory, published documents, archives (AGPLv3, CC BY-4.0)
- **acfrn/octave** ... directory, GNU Octave script files and analysis results (AGPLv3)
  - *init.m* ... function file, initialization script, load packages, add subdirectories to path environment variable
  - *test\_acfrn.m* ... function file, main script, auto-correlation function tests
  - *wrapper\_acfrn\_pvar.m* ... function file, wrapper script for the automated parameter variation
- **acfrn/octave/results/test\_acfrn** ... directory, analysis results (CC BY-4.0)
  - *noise\_Nsmp20480\_Nmc500.oct* ... GNU Octave binary file, standard noise data matrix (to reproduce analysis results, see also function file *tool\_gen\_noise.m*)
  - *\*.oct* ... GNU Octave binary files, analysis results
  - *\*.ofig* ... GNU Octave binary files, figures
  - *\*.png* ... portable network graphics, figures
  - *\*.tex* ... TeX file, exported analysis results (see also TeX file *oct2texdefs.tex*)
- **acfrn/octave/struct** ... directory, data structure building tools (MIT license)
  - *README.txt* ... file, additional information about the directory content
  - *struct\_objattrib.m* ... function file, create attribute object (atomic attribute element, AAE)
  - *struct\_objdata.m* ... function file, create data object (atomic data element, ADE)
  - *struct\_objref.m* ... function file, create reference object (atomic reference element, ARE)
- **acfrn/octave/tex** ... directory, data structure TeX file export tools (MIT license)
  - *README.txt* ... file, additional information about the directory content
  - *tex\_def\_csvarray.m* ... function file, serialize array variable to TeX code (comma-separated list, e.g. version numbers)
  - *tex\_def\_dotarray.m* ... function file, serialize short array variable to TeX code (dot-separated list, e.g. structure path)
  - *tex\_def\_scalar.m* ... function file, serialize scalar value to TeX code
  - *tex\_def\_tabarray.m* ... function file, serialize array value to TeX code (tabulated)
  - *tex\_def\_tabmatrix.m* ... function file, serialize matrix value to TeX code (tabulated)
  - *tex\_serialize.m* ... function file, serialize single value of various data types
  - *tex\_settings.m* ... function file, create data structure containing the TeX code serialization settings
  - *tex\_struct\_export.m* ... function file, export data structure(s) to TeX code file
  - *tex\_struct.m* ... function file, serialize data structure(s) to TeX code
  - *tex\_struct\_objattrib.m* ... function file, serialize atomic attribute element to TeX code
  - *tex\_struct\_objdata.m* ... function file, serialize atomic data element to TeX code
  - *tex\_struct\_objref.m* ... function file, serialize atomic reference element to TeX code
- **acfrn/octave/tools** ... directory, tool scripts (AGPLv3)
  - *tool\_est\_acf\_period.m* ... function file, auto-correlation function (ACF) signal period estimation for sinusoidal signals
  - *tool\_est\_acfrn.m* ... function file, estimate auto-correlation function with reduced impact of noise
  - *tool\_gen\_noise.m* ... function file, generate standard noise data for reproducible analysis results
  - *tool\_gen\_sinusoidal1.m* ... function file, generate (damped) sinusoidal signals
  - *tool\_plot\_errorbar_extended.m* ... function file, plot errorbars, extended support for errorbar symbols and symbol formatting
  - *tool\_plot\_labelgroups.m* ... function file, plot groups of labels
  - *tool\_plot\_labelseries.m* ... function file, plot series of labels
  - *tool\_plot\_perfassmat.m* ... function file, plot performance assessment matrix (colored, boxed grid with box labels)
  - *tool\_plot\_vsep.m* ... function file, plot vertical separator lines with labels
  - *tool\_scale\_noise2snr.m* ... function file, scale noise data w.r.t. signal power and signal-to-noise ratio
  - *tool\_stats\_dmat.m* ... function file, compute statistical values for a 2D data matrix
- **acfrn/octave/variations** ... directory, parameter variation tools (AGPLv3)
  - *var\_param5mc.m* ... function file, vary up to 5 parameters with an additional Monte-Carlo test


## Installation instructions

1. Download datasets (see references below) and move them to a directory of your choice. e.g. **/home/acme/science/data**
2. Copy the program directory **acfrn** to a location of your choice. e.g. **/home/acme/science/acfrn**.   
3. Open GNU Octave.   
4. Make the program directory **/home/acme/science/acfrn** the working directory.   


## Usage instructions

1. Set dataset path variable *dspath* in function file *test\_acfrn.m* to data directory. e.g. dspath = '/home/acme/science/data';   
2. Open GNU Octave.   
3. Initialize program.   
4. Run script files.   


### Initialize program (command line interface)

The *init* command initializes the program. The initialization must be run once before executing all the other functions. The command is adding the subdirectories included in the main program directory to the 'path' environment variable. Furthermore, *init* is loading additional GNU Octave packages required for the program execution.

```
    octave: >> init;   
```


### Execute function file (command line interface)

```
    octave: >> test_acfrn('pvar'); # compute parameter variation, method comparison    
    octave: >> test_acfrn('stats1'); # plot parameter variation stats, power estimation error, method comparison   
    octave: >> test_acfrn('stats2'); # plot parameter variation stats, error distribution, method comparison   
    octave: >> test_acfrn('stats3'); # plot parameter variation stats, performance assessment, method comparison   
    octave: >> test_acfrn('sig'); # plot synthetic test signals   
    octave: >> test_acfrn('acf'); # compute/plot ACF examples, method comparison   
    octave: >> test_acfrn('nat'); # analyse/plot selected natural signals    
```

> [!NOTE]
> To reproduce all analysis results shown in the presentation in **acfrn/latex/test\_acfrn**, run all above-mentioned commands.


## Help and Documentation

All function files contain an adequate function description and instructions on how to use the functions. The documentation can be displayed in the GNU Octave command line interface by entering the following command:

```
    octave: >> help function_file_name;   
```


## Related data sources

Datasets whos content can be analyzed and plotted with this scripts are made available at the repository of Graz University of Technology under an open license (Creative Commons Attribution 4.0 International, CC BY-4.0). The data records enlisted below contain the raw data, the compiled datasets and a technical description of the record content.


### Data records

- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 1, Cement Paste at Early Stages". Graz University of Technology. [doi: 10.3217/bhs4g-m3z76](https://doi.org/10.3217/bhs4g-m3z76)   
- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 3, Reference Tests on Air". Graz University of Technology. [doi: 10.3217/ph0jm-8ax76](https://doi.org/10.3217/ph0jm-8ax76)   
- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 4, Cement Paste at Early Stages". Graz University of Technology. [doi: 10.3217/f62md-kep36](https://doi.org/10.3217/f62md-kep36)   
- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 5, Reference Tests on Air". Graz University of Technology. [doi: 10.3217/bjkrj-pg829](https://doi.org/10.3217/bjkrj-pg829)   
- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 6, Reference Tests on Water". Graz University of Technology. [doi: 10.3217/hn7we-q7z09](https://doi.org/10.3217/hn7we-q7z09)   
- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Datasets - Test Series 7, Reference Tests on Aluminium Cylinder". Graz University of Technology. [doi: 10.3217/azh6e-rvy75](https://doi.org/10.3217/azh6e-rvy75)   


## Related software

### Dataset Compiler, version 1.1:

The referenced datasets are compiled from raw data using a dataset compilation tool implemented in the programming language of GNU Octave 6.2.0. To understand the structure of the datasets, it is a good idea to look at the soure code of that tool. Therefore, it was made publicly available under the MIT license at the repository of Graz University of Technology.

- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Data set compiler (1.1)". Graz University of Technology. [doi: 10.3217/6qg3m-af058](https://doi.org/10.3217/6qg3m-af058)

> [!NOTE]
> *Dataset Compiler* is also available on **github**. [Dataset Compiler](https://github.com/jakobharden/phd_dataset_compiler)


### Dataset Exporter, version 1.0:

*Dataset Exporter* is implemented in the programming language of GNU Octave 6.2.0 and allows for exporting data contained in the datasets. The main features of that script collection cover the export of substructures to variables and the serialization to the CSV format, the JSON structure format and TeX code. It is also made publicly available under the MIT licence at the repository of Graz University of Technology.

- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Dataset Exporter (1.0)". Graz University of Technology. [doi: 10.3217/9adsn-8dv64](https://doi.org/10.3217/9adsn-8dv64)

> [!NOTE]
> *Dataset Exporter* is also available on **github**. [Dataset Exporter](https://github.com/jakobharden/phd_dataset_exporter)


### Dataset Viewer, version 1.0:

*Dataset Viewer* is implemented in the programming language of GNU Octave 6.2.0 and allows for plotting measurement data contained in the datasets. The main features of that script collection cover 2D plots, 3D plots and rendering MP4 video files from the measurement data contained in the datasets. It is also made publicly available under the MIT licence at the repository of Graz University of Technology.

- Harden, J. (2023) "Ultrasonic Pulse Transmission Tests: Dataset Viewer (1.0)". Graz University of Technology. [doi: 10.3217/c1ccn-8m982](https://doi.org/10.3217/c1ccn-8m982)

> [!NOTE]
> *Dataset Viewer* is also available on **github**. [Dataset Viewer](https://github.com/jakobharden/phd_dataset_viewer)


## Revision and release history

### 2024-11-30, version 1.0.0

- published/released version 1.0.0, by Jakob Harden   
- url: [Repository of Graz University of Technology](https://repository.tugraz.at/)   
- Presentation, doi: [10.3217/bttj1-04b72](https://doi.org/10.3217/bttj1-04b72)   
- GNU Octave code, doi: [10.3217/rvnf8-z5r12](https://doi.org/10.3217/rvnf8-z5r12)   
- LaTeX code, doi: [10.3217/zkj4t-30097](https://doi.org/10.3217/zkj4t-30097)   

