# Regular Expression
```
 ______    _______  _______  _______  __   __ 
|    _ |  |       ||       ||       ||  |_|  |
|   | ||  |    ___||    ___||    ___||       |
|   |_||_ |   |___ |   | __ |   |___ |       |
|    __  ||    ___||   ||  ||    ___| |     | 
|   |  | ||   |___ |   |_| ||   |___ |   _   |
|___|  |_||_______||_______||_______||__| |__|
```

## Basic Ones

- **Bracket Expressions**: `b[aeiou]g` matches the words bag, beg, big, bog, and bug. **(b[^aeiou]g)**  
- **Range Expressions**: `a[2-4]z`, `a[a-z]z`  
- **Any Single Character**: (`.`) represents any single character except a newline => `a.z`  
- **Start and End of Line**: The caret (`^`) represents the start of a line, and the dollar sign (`$`) denotes the end of a line  
- **Repetition**: An asterisk (`*`) denotes zero or more matches => `A.*Lincoln`  
- `.*` = Represent multiple characters  
- **Escaping**: Precede it with a backslash (`\`)

## Character Classes

- `[:alnum:]` —> Matches any alphanumeric characters (any case), and is equal to using the `[0-9A-Za-z]` bracket expression  
- `[:alpha:]` —> Matches any alphabetic characters (any case), and is equal to using the `[A-Za-z]` bracket expression  
- `[:blank:]` —> Matches any blank characters, such as tab and space  
- `[:digit:]` —> Matches any numeric characters, and is equal to using the `[0-9]` bracket expression  
- `[:lower:]` —> Matches any lowercase alphabetic characters, and is equal to using the `[a-z]` bracket expression  
- `[:punct:]` —> Matches punctuation characters, such as `!`, `#`, `$`, and `@`  
- `[:space:]` —> Matches space characters, such as tab, form feed, and space  
- `[:upper:]` —> Matches any uppercase alphabetic characters, and is equal to using the `[A-Z]` bracket expression  

## Extended Regular Expression

- **Additional Repetition Operators**: A plus sign (`+`) matches one or more occurrences, and a question mark (`?`) specifies zero or one match  
- **Multiple Possible Strings**: The vertical bar (`|`) separates two possible matches => `car|truck` matches either car or truck  
- **Parentheses**: Ordinary parentheses (`()`) surround subexpressions. Parentheses are often used to specify how operators are to be applied

# acknowledgment
## Contributors

APA 🖖🏻

## Links


## APA, Live long & prosper
```
  aaaaaaaaaaaaa  ppppp   ppppppppp     aaaaaaaaaaaaa
  a::::::::::::a p::::ppp:::::::::p    a::::::::::::a
  aaaaaaaaa:::::ap:::::::::::::::::p   aaaaaaaaa:::::a
           a::::app::::::ppppp::::::p           a::::a
    aaaaaaa:::::a p:::::p     p:::::p    aaaaaaa:::::a
  aa::::::::::::a p:::::p     p:::::p  aa::::::::::::a
 a::::aaaa::::::a p:::::p     p:::::p a::::aaaa::::::a
a::::a    a:::::a p:::::p    p::::::pa::::a    a:::::a
a::::a    a:::::a p:::::ppppp:::::::pa::::a    a:::::a
a:::::aaaa::::::a p::::::::::::::::p a:::::aaaa::::::a
 a::::::::::aa:::ap::::::::::::::pp   a::::::::::aa:::a
  aaaaaaaaaa  aaaap::::::pppppppp      aaaaaaaaaa  aaaa
                  p:::::p
                  p:::::p
                 p:::::::p
                 p:::::::p
                 p:::::::p
                 ppppppppp
```