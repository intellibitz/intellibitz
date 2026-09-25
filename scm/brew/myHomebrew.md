# Homebrew Package Manager Guide

Overview and quickstart for using [Homebrew](https://brew.sh/) on macOS and Linux.

---

## Installation

Run the installation script in your terminal:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
*(Or execute [install-brew.sh](file:///home/ramadoss/github.com/intellibitz/intellibitz/scm/brew/install-brew.sh))*

---

## Common Commands

### Installing Packages
```bash
brew install wget
```

### Installing macOS GUI Applications (Casks)
```bash
brew install --cask firefox
```

### Managing Formulae
```bash
brew update
brew upgrade
brew cleanup
```

---

## Creating Formulae

Homebrew formulae are Ruby scripts:
```ruby
class Wget < Formula
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.15.tar.gz"
  sha256 "52126be8cf1bddd7536886e74c053ad7d0ed2aa89b4b630f76785bac21695fcd"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
```

---

## Documentation & Links
- [Official Website](https://brew.sh/)
- [Manpage Reference](https://docs.brew.sh/Manpage)
- [Formulae Search](https://formulae.brew.sh/)
