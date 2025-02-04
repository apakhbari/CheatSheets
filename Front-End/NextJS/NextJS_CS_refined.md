# **Next.JS**

### **Things that are on /public are referenced like / . don’t ref like /public**

### **For linking a non-text:**


### **There is an article tag available for posts `<article></article>`**

- Routing:
  - `<link replace href=“/signin”>signin</link>` : the _replace_ tag has the ability to replace the page instead of pushing it, so you can’t go back from there
- Navigating Programmatically:
  - `import {useRouter} from ‘next/router’;`
  - (inside of function)
  - `const router = useRouter;`
  - `router.push(/clients/max/project12)`
  - `router.replace(/clients/max/project123)`
- `[…slug].js` : dynamically captures any kind of value in URL
- `404.js` : make a custom 404 page

### **Page Pre-rendering:**

Page pre-rendering has two forms:

1. Static generation —> pre-generate during build time

```javascript
export async function getStaticProps(context) {  
    const { params } = context;
    const postId = params.postId;
    return {
        props: { ... },
        revalidate: 60*12,
        notFound: true,
        redirect: { destination: ’/no-data’}
    };
}
```

<span class="Apple-tab-span" style="white-space: pre;"></span>{ …

<span class="Apple-tab-span" style="white-space: pre;"></span>const { params } = context;

<span class="Apple-tab-span" style="white-space: pre;"></span>const postId = params.postId

<span class="Apple-tab-span" style="white-space: pre;"></span>return {

<span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>props: { … },

<span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>revalidate: 60\*12,

<span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>notFound: true,

<span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>redirect: { destination: ’/no-data’}

<span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>

<span class="Apple-tab-span" style="white-space: pre;"></span>};

<span class="Apple-tab-span" style="white-space: pre;"></span>}

- although next.js is pre-render pages by default, use this to tell next that page is static generation and there are things to do.
- code inside getStaticProps function is not accessible by user. db credentials can be placed here
- revalidate: used for incremental static generation (ISR) that is regenerate page and update server-side pre-rendered file every x seconds
- notFound: used for responding 404
- redirect: can redirect to another route

- default behaviour for dynamic pages ([postId.js] etc.) is not pre-generating them. For pre-generating them you should know which [id] values will be available with:

  export async function getStaticPaths() {

  <span class="Apple-tab-span" style="white-space: pre;"></span>return {

  <span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>paths: [

  <span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>{ params: { pid: ‘p1’ } },

  <span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>{ params: { pid: ‘p2’ } },

  <span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>{ params: { pid: ‘p3’ } },

  <span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>],

  <span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>fallback: false

  <span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>};

  }

- fallback: if set to false, should enter all of params. If true, should enter most visited and frequent pages and URLs, so only these ones are pre-generated. Notice that for not pre-generated pages, add the code snippet below before `<return()>`:

  if (!props) {

  <span class="Apple-tab-span" style="white-space: pre;"></span>return <p>Loading…</p>;

  }

- fallback: could be ‘blocking’. Then there is no need to add the code snippet, Next.js automatically handles that

1. server-side rendering: renders after request is issued to server

```javascript
export async function getServerSideProps(context) {

<span class="Apple-tab-span" style="white-space: pre;"></span>const {params, req, res} = context;

<span class="Apple-tab-span" style="white-space: pre;"></span>return {

<span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>props: {

<span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>username: ‘asghar’

<span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>}

};
```

- header

```javascript
import Head from ‘’next/head
```

### IMPORTANT

  <Head>

       <title>Next Events</title>

       <meta name='description' content='NextJS Events' />

       <meta name='viewport' content='initial-scale=1.0, width=device-width' />. —> GOOD FOR responsive view of ALL Pages

  </Head>

- pages/\_document.js

Being used when need to override final HTML document, outside of app tree. For example changing font on all app

- Optimizing Images

```javascript
import Image from ‘next/image’;

<Image src={'/' + image} alt={title} width={250} height={160} />
```

- pages/api

Will not be in codes that user can see


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