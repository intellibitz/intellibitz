# https://docs.python.org/3.12/using/index.html


# https://docs.python.org/3.12/installing/index.html

# The following command will install the latest version of a module and its dependencies from the Python Package Index:

python -m pip install SomePackage

# Key terms
# pip is the preferred installer program. Starting with Python 3.4, it is included by default with the Python binary installers.

# A virtual environment is a semi-isolated Python environment that allows packages to be installed for use by a particular application, rather than being installed system wide.

# venv is the standard tool for creating virtual environments, and has been part of Python since Python 3.3. Starting with Python 3.4, it defaults to installing pip into all created virtual environments.

# virtualenv is a third party alternative (and predecessor) to venv. It allows virtual environments to be used on versions of Python prior to 3.4, which either don’t provide venv at all, or aren’t able to automatically install pip into created environments.

# The Python Package Index is a public repository of open source licensed packages made available for use by other Python users.

# the Python Packaging Authority is the group of developers and documentation authors responsible for the maintenance and evolution of the standard packaging tools and the associated metadata and file format standards. They maintain a variety of tools, documentation, and issue trackers on GitHub.

# distutils is the original build and distribution system first added to the Python standard library in 1998. While direct use of distutils is being phased out, it still laid the foundation for the current packaging and distribution infrastructure, and it not only remains part of the standard library, but its name lives on in other ways (such as the name of the mailing list used to coordinate Python packaging standards development).

# Changed in version 3.5: The use of venv is now recommended for creating virtual environments.

# Pip not installed
# It is possible that pip does not get installed by default. One potential fix is:

python -m ensurepip --default-pip
