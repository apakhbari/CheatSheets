## TypeScript
```
 _______  __   __  _______  _______  _______  _______  ______    ___   _______  _______ 
|       ||  | |  ||       ||       ||       ||       ||    _ |  |   | |       ||       |
|_     _||  |_|  ||    _  ||    ___||  _____||       ||   | ||  |   | |    _  ||_     _|
  |   |  |       ||   |_| ||   |___ | |_____ |       ||   |_||_ |   | |   |_| |  |   |  
  |   |  |_     _||    ___||    ___||_____  ||      _||    __  ||   | |    ___|  |   |  
  |   |    |   |  |   |    |   |___  _____| ||     |_ |   |  | ||   | |   |      |   |  
  |___|    |___|  |___|    |_______||_______||_______||___|  |_||___| |___|      |___|  
```

Types:

1- Primitive types: number - boolean - void - undefined - string - symbol - null

2- Object types: functions - arrays - classes - objects

Array:

```ts
let colors: (string | number)[] = [‘red’, 000, ‘blue’];
```

Tuple:

```ts
const pepsi: [string, boolean, number] = [‘brown’, true, 40]
```

Object literal:

```ts
let point: { x: number; y: number} = {
  x: 10,
  y: 20
};
```

Function:

1- 
```ts
const logNumber: (i: number) => void = (i: number) => {
  console.log(i);
};
```

2- 
```ts
function divide(a: number, b:number): number {
  return a / b;
}
```

3- 
```ts
const multiply = function(a: number, b: number) {
  return a * b;
}
```

Optional value:

```ts
zoom?: number;
```

—————————

To work with JS inside typescript, need to install adapter, can find it in Definietly Typed project, by installing @types/{library name}

—————————

```sh
tsc --init --> creates config file
```

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