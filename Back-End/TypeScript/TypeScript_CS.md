## TypeScript

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