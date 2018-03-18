# pandocker

Docker version of full featured pandoc to convert Markdown documents to PDF.

## Install

All you need is the docker engine to run the pandocker environment.
See the docker docs: https://docs.docker.com/install/

Also, docker-compose is a good tool to help with the project maintainability. You can install it following this steps: https://docs.docker.com/compose/install/

## Setup

Pandocker expects you setup some initial project structure to fit on it's scripts. The simplest model should be like this:

```
your-project/
| src/                                                                          
| | bib.yaml                                                                                                      
| | config.md
| | sections.conf                                                                
| templates/                                                                                                      
| | optinal-custom-template-helpers/                                                                                                          
| | optional-custom-template.latex                                                                                                     
| docker-compose.yml  
```

### Blank project

You can fork or download a blank project I created with some initial configurations and go ahead.
https://github.com/luanguimaraesla/pandocker-blank

### Schema
There are only two folders and three files on the Pandocker's schema

* **src/**: directory where you should put all your Markdown (`.md` extension) files.
* **tempates/**: directory where you'll put some specific Pandoc/LaTeX templates if needed. This folder is optional.
* **src/bib.yaml**: file containing your project bibliography
* **src/config.md**: file with pandocs [YAML metadata](https://pandoc.org/MANUAL.html#using-variables-in-templates)
* **src/sections.conf**: file containig the ordered list of source files' names (without the `.md` extension) that will be compiled.

How can you correctly configure the files? It is described at the [Configuration section](#configuration).

## Docker usage

I will describe how to use Pandocker with a `docker-compose` example. Feel free to skip it's installation and run a solo docker engine with the same environment variables.

Create a docker-compose.yml at the root of your project, Like you saw in the [Setup section](#setup).

```
version: '3.1'

services:
  pandocker:
    container_name: pandocker
    image: luanguimaraesla/pandocker
    volumes:
    - .:/code
```

Now, all you need is to run the next command line:

```bash
sudo docker-compose up
```

Your final document should appear in the project root as `doc.pdf`

### Environment Variables

You can setup some configurations of Pandocker with the Docker Environment Variables. Here is the comples `docker-compose.yml` file with these variables:

```
version: '3.1'

services:
  pandocker:
    container_name: pandocker
    image: luanguimaraesla/pandocker
    volumes:
    - .:/code
    variables:
      OUTPUT_FILE: 'example.pdf'   # the output file name, defalt: doc.pdf
      SOURCE_DIR: 'example'   # the markdown source directory, default: src
      TEMPLATE_PATH: 'templates/example.latex'   # the path of your pandoc template, default: none
      WITH_TABLE_OF_CONTENTS: false   # show the table of contents, default: true

```

## Advanced Configurations

### Learn what are you doing

#### src/config.md

It has some configuration variables both of the pandoc configurations, and the template you may use. There are also some filters configurations. A simple config.md file should appear like this:

```
\---
# Some pandoc configurations
bibliography: src/bib.yaml
link-citations: true
numbersections: true


# Option template configurations
lang: pt-BR
documentclass: abntex2 
classoption:
  - article
  - 12pt
  - brazil

# Optional template variables
coverlocation:  'templates/tcc/figuras/capa.eps'
title: 'Empurrando Juntos: Machine Learning'
date: '2018'
author: 'Luan Guimarães Lacerda'
course: 'Engenharia de Software'


# pandoc-crossref configurations
linkReferences: true
codeBlockCaptions: true

figPrefix:
  - "Figura"
  - "Figuras"

eqnPrefix:
  - "Equação"
  - "Equações"

tblPrefix:
  - "Tabela"
  - "Tabelas"

lstPrefix:
  - "Lista"
  - "Listas"

secPrefix:
  - "Seção"
  - "Seções"
...
```

You can read more about [pandoc metadata](https://pandoc.org/MANUAL.html#using-variables-in-templates), [pandoc-citeproc](https://github.com/jgm/pandoc-citeproc/blob/master/man/pandoc-citeproc.1.md), and [pandoc-crossref](http://lierdakil.github.io/pandoc-crossref/).

#### src/bib.yaml

YAML-CSL file where you should write your project's bibliography. This is not a BibTeX like tool, this is much easier. Following the YAML strcture, all you need to know is the [Citation Style Language (CSL) variables](http://docs.citationstyles.org/en/1.0.1/specification.html#appendix-iv-variables). Your bibliography file should be like this:

```yaml
- type: book
  id: fefa06
  editor:
  - family: Guyon
    given: Isabelle
  - family: Gunn
    given: Steve
  - family: Nikrevesh
    given: Masoud
  - family: Zadeh
    given: [Lofti, A.]
  title: 'Feature Extraction: Foundations and Applications'
  title-short: 'Feature Extraction'
  number-of-pages: 778
  collection-number: 207
  collection-title: 'Studies in Fuzziness and Soft Computing'
  ISBN: 978-3540354871
  publisher: "Springer"
  issued:
    date-parts:
    - - 2006
      - 8
  edition: '2006'
  language: en-US


- type: book
  id: joll02
  author:
  - family: Jolliffe
    given: [I., T.]
  title: 'Principal Component Analysis'
  ISBN: 0-387-95442-2
  collection-title: 'Springer series in statistics'
  publisher: "Springer"
  publisher-place: "175 Fifth Avenue, New York, NY 10010, USA"
  issued:
    date-parts:
    - - 2002
      - 2
  edition: 2
  language: en-US
```

Note you need to specify each block `id` with any text you want. This `id` will be used to `pandoc-citeproc` filter to enable Markdown citations. Following the example above, on the Markdown text you can make reference using:

```
"This is a Feature Extraction book citation" [@fefa06]
# becomes:
# "This is a Feature Extraction book citation" (Guyon et al, 2006)

Jollife [-@joll02] said some thing.
# becomes:
# Jollife (2002) said some thing.
```

Read more about pandoc-citeproc: [pandoc-citeproc man page](https://github.com/jgm/pandoc-citeproc/blob/master/man/pandoc-citeproc.1.md).

#### /src/sections.conf

This file describes the order of your project files. Let me take an example where I have a project with three sections (introduction, metodology and conclusion). Each section is a Markdown file under the `src/` folder:

```
my-project/
| src/                                                                          
| | bib.yaml                                                                                                      
| | config.md
| | sections.conf                                                                
| | introduction.md                                                                
| | metodology.md                                                                
| | conclusion.md                                                                

```

My `sections.conf` should contains the name of each section file in the order they will be printed in the final document (PDF). It should appear like the following:

```
config
introduction
metodology
conclusion
```

IMPORTANT: Note there are no `.md` extension, and my `config` should ever be the first file of my stack.

### Mathematics

You can write math following the LaTeX style. All you want to do is use double `$` to mathematics blocks, `$$ <math-code> $$`, and single `$` to inline mathematics `$ <math-code> $`.

I usually use [codecogs](https://www.codecogs.com/latex/eqneditor.php?lang=pt-br) to generate my math code.

### Cross Reference

We use the `pandoc-crossref` filter to create and link some text references: sections, figures, tables, lists, and equations. The way we do this is very similar to the bibliograpy citation we explaned above. To create a reference anchor you'll use the `{#foo:bar}` syntax.

```
|object|value|
|:----:|:---:|
|A     |10   |
|B     |5    |

: Caption of the table {#tbl:unique-table-ref}
```

`pandoc-crossref` enable us to use five kinds of references: `{#fig:foo}` to figures, `{#eq:foo}` to equations, `{#tbl:foo}` to tables, `{#lst:foo}` to lists and `{#sec:foo}` to sections. The way it will appear in the text can be changed in the `src/config.md` file. For the above example of a table, we can make the text reference using the same style of the citations.

```
Look the values on the [@tbl:unique-table-ref]
# becomes:
# Look the values on the Table 1
```

The value '1' is the order of this table on the final document. You can learn more about `pandoc-crossref` at https://github.com/lierdakil/pandoc-crossref.

### Templates

The template is a `.latex` file. It's description is under the theme of this explanation. You can learn how to create your own template at this simple example: https://gist.github.com/michaelt/1017790
