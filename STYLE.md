# Introduction

This file describes the various style and design conventions that are used in this repository. While you may choose to use these conventions in your own projects, it is not required.

- [Naming](#naming)
- [File and Structure](#file-and-structure)
- [YAML Style Guide](#yaml-style-guide)
  - [Booleans](#booleans)
  - [Comments](#comments)
  - [Indentation](#indentation)
  - [Mappings](#mappings)
  - [Sequences](#sequences)
  - [Strings](#strings)
  - [Multi-line Strings](#multi-line-strings)

## Naming

1. Use kebab-case for patch file names.
2. Use kebab-case for replacement file names.
3. Use kebab-case for resource file names.
4. Do not use <kbd>_</kbd> for private files.
5. Use whole words in names when possible.

## File and Structure

1. Shared resources should be created in `base` overlay.
2. Specific resources should be created in their environment overlay.
3. Patches never must be created in `base` overlay.

## YAML Style Guide

### Booleans

1. Use only `true` or `false` as boolean values.
2. Boolean values must be lower case.
3. Avoid the use of truthy boolean values.

```yaml
# Good
one: true
two: false

# Bad
one: True
two: False
```

### Comments

1. Comments should start with a capital letter.
2. Comments should have a space between the comment hash # and the start of the comment.

```yaml
# Good
example:
  # Comment
  one: true

# Bad
example:
# Comment
  one: false
  #Comment
  two: false
  # comment
  three: false
```

### Indentation

1. An indentation of 2 spaces must be used.

```yaml
# Good
example:
  one: 1

# Bad
example:
    bad: 2
```

## Mappings

Mappings in YAML are also known as associative arrays, hash tables, key/value pairs, collections or dictionaries.

1. Use block style mappings.

```yaml
# Good
example:
  one: 1
  two: 2

# Bad
example: { one: 1, two: 2 }
```

## Sequences

Sequences in YAML are also known as lists or arrays.

1. Use block style sequences.
2. Avoid flow style sequences.

```yaml
# Good
example:
  - 1
  - 2
  - 3

# Bad
example:
- 1
- 2
- 3

# Bad
example: [1, 2, 3]
```

### Strings

1. Use double quotes for strings.

```yaml
# Good
example: "Hi there!"

# Bad
example: 'Hi there!'
```

## Multi-line strings

Avoid the use of \n or other new line indicators in YAML configuration when possible. The same applies to avoiding long, single line, strings.

Instead, make use of the literal style (preserves new lines) and folded style (does not preserve new lines) strings.

```yaml
# Good
literal_example: |
  This example is an example of literal block scalar style in YAML.
  It allows you to split a string into multiple lines.
folded_example: >
  This example is an example of a folded block scalar style in YAML.
  It allows you to split a string into multi lines, however, it magically
  removes all the new lines placed in your YAML.

# Bad
literal_example: "This example is an example of literal block scalar style in YAML.\nIt allows you to split a string into multiple lines.\n"
folded_example_same_as: "This example is an example of a folded block scalar style in YAML. It allows you to split a string into multi lines, however, it magically removes all the new lines placed in your YAML.\n"
```
