# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Needed module imports -------------------------------------------------
import os
import sys

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'NAMD-Benchmark-Harness'
copyright = '2022, Arnold Tharrington'
author = 'Arnold Tharrington'
release = '0.1'

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = []
extensions.append('sphinx.ext.autodoc')

templates_path = ['_templates']
exclude_patterns = []


# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'alabaster'
html_static_path = ['_static']

# -- Paths to python source files --------------------------------------------
path1 = os.getenv("NCP_TOP_LEVEL")
path2 = os.path.join(path1,"bin")
sys.path.append(path2)
