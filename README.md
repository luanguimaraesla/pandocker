# pandocker 0.3.1


[![pipeline status](https://gitlab.com/luanguimaraesla/pandocker/badges/master/pipeline.svg)](https://gitlab.com/luanguimaraesla/pandocker/commits/master)


Docker version of full-featured pandoc to convert complex Markdown documents to pdf.

Github: https://github.com/luanguimaraesla/pandocker

Gitlab: https://gitlab.com/luanguimaraesla/pandocker

## Install

### Dependencies

All you need is the docker engine enabled to run the pandocker environment.
Follow the docker docs: https://docs.docker.com/install/

Make sure that docker is running:

```bash
sudo systemctl start docker
```

### Installing

Now you can install pandocker like any other docker.

```bash
sudo systemctl start docker
sudo docker pull luanguimaraesla/pandocker:0.3.1
```

`WARNING`: Because of full-latex, haskell, pandoc, pandoc-filters and erlang dependencies, download may take too long, so be patient.

### Configuring

Like many system tools built in Docker architecture, Pandocker must be executed using docker command line.

```bash
sudo docker run --rm -v $(pwd):/code luanguimaraesla/pandocker:0.3.1 help
```

However, to ease the usage, you can alias this _f*ck$@!_ command just typing it in the terminal.

```bash
cat - << EOT >> ~/.bashrc
function pandocker() {
  sudo docker run --rm -v $(pwd):/code luanguimaraesla/pandocker:0.3.1 $@
  sudo chown -R $USER:$USER .
}
EOT
source ~/.bashrc
```

Then, you'll be able to use Pandocker like a pro.

```bash
pandocker help
```

## Usage

### Quick start

Create an empty directory to your new Pandocker project and execute pandocker to setup the template structure. Then compile the source files.

```bash
mkdir myproject
cd myproject
pandocker new
pandocker compile
```

`WARNING`: if you're not using the ~/.bashrc function, because of docker architecture, to edit the files you'll need to run `chown` command inside your project directory.

```bash
sudo chown -R $USER:$USER .
```

Pandocker uses some default settings, `default` and `pandocker.yml` to the `new` and `compile` commands respectively. If you want to use a preconfigured template, find its name in [Pandocker Templates Site](https://github.com/luanguimaraesla/pandocker-templates), then you can tell Pandocker to create a new project according to this template:

```bash
mkdir myproject && cd myproject
pandocker new -t [template-name]
```

In the same way, you can use some configurations files to organize better your projects. So, all you need is to tell Pandocker which YAML file you want in the compilation:

```bash
pandocker compile -f custom.pandocker.yml
```


### Custom templates

If you need to create your own project structure, Pandocker expects you setup some initial project structure. We suggest the following simple model:

```
your-project/
| src/
| | bib.yaml
| | config.md
| | pandocker.yml
| | images/
| | template/
| | | optional-custom-template.latex
```

#### Schema

* **src/**: directory where you should put all your Markdown (`.md` extension) files;
* **src/images/**: directory to store yout images;
* **src/tempates/**: directory where you'll put some specific Pandoc/LaTeX templates if needed;
* **src/bib.yaml**: file containing your project bibliography;
* **src/config.md**: file with pandocs [YAML metadata](https://pandoc.org/MANUAL.html#using-variables-in-templates);
* **src/pandocker.yml**: Pandocker YAML configuration file.

How can you correctly configure the files? See below the basic usage.

### Understanting common Pandocker files

#### YAML configuration file

You can setup all the configurations of Pandocker with a custom YAML file:

```yaml
# pandocker.yml
sections:
  - config.md
  - your_section_1.md
  - your_section_2.md

pandoc:
  custom_flags:  "-s"
  source_path:   "src/"   # relative to where you run the pandocker command
  template_file: "template/example.latex"  # relative to src/ path
  output_file:   "yourproject.pdf"
  toc:           true
  filters:
    - pandoc-crossref
    - pandoc-citeproc

```

All the sections will be compiled according to the order described in the YAML configuration file. Also, Pandocker uses the `pandoc` section to configure the flags for the compilation.


#### config.md

This is the Pandoc metadata YAML. It should be your first file described in the `pandocker.yml` file. Here you can configure the behavior of pandoc, filters and templates. Look a simple example:

```yaml
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
title: 'Empurrando Juntos: Machine Learning'
date: '2018'
author: 'Luan Guimarães Lacerda'
course: 'Engenharia de Software'


# pandoc-crossref configurations
linkReferences: true
codeBlockCaptions: true
...
```

Read more about [pandoc metadata](https://pandoc.org/MANUAL.html#using-variables-in-templates), [pandoc-citeproc](https://github.com/jgm/pandoc-citeproc/blob/master/man/pandoc-citeproc.1.md), and [pandoc-crossref](http://lierdakil.github.io/pandoc-crossref/).

#### bib.yml

YAML-CSL file where you should write your project's bibliography. This is not a BibTeX like tool, this is much easier. Following the YAML structure, all you need to know is the [Citation Style Language (CSL) variables](http://docs.citationstyles.org/en/1.0.1/specification.html#appendix-iv-variables). Your bibliography file should be like this:

```yaml
references: 
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

Note you need to specify each block `id` with any text you want. The `id` will be used to `pandoc-citeproc` filter to enable Markdown citations. Following the example above, on the Markdown text you can make reference using:

```
"This is a Feature Extraction book citation" [@fefa06]
# becomes:
# "This is a Feature Extraction book citation" (Guyon et al, 2006)

Jollife [-@joll02] said something.
# becomes:
# Jollife (2002) said something.
```

Read more about pandoc-citeproc: [pandoc-citeproc man page](https://github.com/jgm/pandoc-citeproc/blob/master/man/pandoc-citeproc.1.md).


## Pandocker common usage

### Mathematics

You can write math code following the LaTeX style. All you want to do is use double `$` to mathematics blocks: 

```
Text text text

$$
  <math-code>
$$

Text text text
```

It is possible to add inline math code using a single `$`:

```
Text text $ <math-code> $, text text.
```

We usually use [codecogs](https://www.codecogs.com/latex/eqneditor.php?lang=pt-br) to generate math code.

### Cross Reference

We use the `pandoc-crossref` filter to create and link some text references: sections, figures, tables, lists, and equations. The way we do this is very similar to the bibliography citation we explained above. To create a reference anchor you'll use the `{#foo:bar}` syntax.

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
# Look the values on Table 1
```

The value '1' is the order of this table in the final document. You can learn more about `pandoc-crossref` at https://github.com/lierdakil/pandoc-crossref.

### Latex templates

The template is a `.latex` file. Its description is under the theme of this explanation. Learn how to create your own template with this simple example: https://gist.github.com/michaelt/1017790
