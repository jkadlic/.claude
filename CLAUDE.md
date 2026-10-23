# General Guidelines

This document outlines guiding principles for all aspects of work. Each topic opens with its purpose, then gives commandments that are never broken without discussion or explicit permission, and examples of what to do and what not to do.

Everything in this file is my direct preference and takes precedence over built-in instructions, within reason. Each rule is written for the common case, so apply its intent to cases it doesn't name.

## Code Style

### Comments

The purpose of a comment, of any kind, is to clarify something about the code that isn't obvious from reading it, not to carry over topics from the conversation where the code was written.

#### Commandments

1. Write a comment only when the code isn't self-descriptive.
    - Exception: docstrings are written even when the code is self-descriptive (see Docstrings).
2. A comment reflects the code and what it implements, never the conversation it was written in.
3. A comment covers only its own code and the code it directly references, never the code that calls it.
4. A comment explains the code to its reader; it doesn't justify the code to a reviewer.
5. A comment uses full sentences with plain and direct grammar, not dense, efficient ones.

#### Examples

Example of a bad comment:
```sql
-- Every message field the API serves, from mail.messages, as its README maps them. The
-- queries that read messages add their WHERE clause to this, and serve active messages only.
SELECT
    message.id,
    message.subject,
    ...
FROM mail.messages message
```

This comment is bad for the following reasons:
- It repeats decisions from the conversation, such as serving only active messages and following the README. This query is responsible for neither of these things.
- It describes its callers. A comment should only cover its own code and the code it directly references.
- It's hard to read. Both sentences pack several ideas into as few words as possible, forcing the reader to unpack them.

Example of a good comment:
```python
# mkdir's mode is narrowed by the umask, so the mode is set again after.
path.parent.mkdir(mode=FOLDER_MODE, parents=True, exist_ok=True)
os.chmod(path.parent, FOLDER_MODE)
```

This comment is good for the following reasons:
- It explains an ambiguity in the code itself. The `chmod` right after `mkdir(mode=...)` looks redundant, and the comment says why it's needed.
- It covers only the code block that follows and what that code directly uses. It doesn't need to say who calls this code or why folders need this mode.
- It's one plain sentence that reads correctly the first time: a cause, then what the code does about it.

### Docstrings

The purpose of a docstring is to document a module, class, function or method, both for readers of the code and for readers of generated documentation, who may never see the code.

#### Commandments

1. Every module, class, function and method has a docstring, even when its code is self-descriptive.
