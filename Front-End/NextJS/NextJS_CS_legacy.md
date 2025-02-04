**Next.JS**

\*\* Things that are on /public are refrenced like / . don’t ref like /public

\*\* For linking a non-text:

<span class="Apple-tab-span" style="white-space: pre;"></span><Link href=‘/some-link’>

<span class="Apple-tab-span" style="white-space: pre;"></span><a>

<span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span><Logo />

<span class="Apple-tab-span" style="white-space: pre;"></span></a>

<span class="Apple-tab-span" style="white-space: pre;"></span></Link>

\*\* there is a article tag available for posts <article></article>

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 9px; line-height: normal; font-family: Menlo;"></span>Routing:

- <span class="s2" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span><link replace href=“/signin”>signin</link> : the _replace_ tag has the ability to replace page instead of pushing it, so you can’t go back from there
- <span class="s2" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>Navigating Programmatically:

- <span class="s2" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>import {useRouter} from ‘next/router’;
- <span class="s2" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>(inside of function)
- <span class="s2" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>const router = useRouter;
- <span class="s2" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>router.push(/clients/max/project12)
- <span class="s2" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>router.replace(/clients/max/project123

- <span class="s2" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>[…slug].js : dynamically captures any kind of value in url
- <span class="s2" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>404.js : make a custom 404 page

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 9px; line-height: normal; font-family: Menlo;"></span>page pere-rendering:

- <span class="s2" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>has two forms :

1.  static generation —> pre-generate during build time

- export async function getStaticProps(context)<span class="Apple-converted-space"> </span>

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

- <span class="s2" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>although next.js is pre-render pages by default, use this to tell next that page is static genereation and there are things to do.
- <span class="s2" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>code inside getStaticProps function is not accessible by user. db credentials can be place here
- <span class="s2" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>revalidate: used for incremental static generation (ISR) that is regenerate page and update server-side pre-rendered file every x seconds
- <span class="s2" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>notFound: used for responcing 404
- <span class="s2" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>redirect: can redirect to another route

- <span class="s2" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>default behaviour for<span class="Apple-converted-space"> </span> dynamic pages ([postId.js] etc.) is not pre-generating them. for pre-generating them you should know which [id] values will be available with:

<span class="Apple-converted-space">   </span> export async function getStaticPaths() {

<span class="Apple-converted-space">    <span class="Apple-tab-span" style="white-space: pre;"></span></span>return {

<span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>paths: [

<span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>{ params: { pid: ‘p1’ } },

<span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>{ params: { pid: ‘p2’ } },

<span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>{ params: { pid: ‘p3’ } },

<span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>],

<span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>fallback: false

<span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>};

<span class="Apple-converted-space">   </span> }

- <span class="s2" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>fallback: if set to false, should enter all of params. if true, should enter most visited and frequent pages and urls, so only these ones are pre-generated. notice that for not pre-generated pages, add below code snippet before <return()> :

<span class="Apple-converted-space">   </span> if (!props) {

<span class="Apple-converted-space">    <span class="Apple-tab-span" style="white-space: pre;"></span></span>return <p>Loading…</p>;

<span class="Apple-converted-space">   </span> }

- <span class="s2" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>fallback: could be ‘blocking’. then there is no need to up code snippet, next.js automatically handles that

1.  server-side rendering: renders after request is issued to server

export async function getServerSideProps(context) {

<span class="Apple-tab-span" style="white-space: pre;"></span>const {params, req, res} = context;

<span class="Apple-tab-span" style="white-space: pre;"></span>return {

<span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>props: {

<span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>username: ‘asghar’

<span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>}

};

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 9px; line-height: normal; font-family: Menlo;"></span>header

import Head from ‘’next/head

### IMPORTANT

<span class="Apple-converted-space">     </span> <Head>

<span class="Apple-converted-space">       </span> <title>Next Events</title>

<span class="Apple-converted-space">       </span> <meta name='description' content='NextJS Events' />

<span class="Apple-converted-space">       </span> <meta name='viewport' content='initial-scale=1.0, width=device-width' />. —> GOOD FOR responsive view of ALL Pages

<span class="Apple-converted-space">     </span> </Head>

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 9px; line-height: normal; font-family: Menlo;"></span>pages/\_document.js

being used when need to override final html document, outside of app tree. for example changing font on all app

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 9px; line-height: normal; font-family: Menlo;"></span>Optimizing Images

import Image from ‘next/image’;

<Image src={'/' + image} alt={title} width={250} height={160} />

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 9px; line-height: normal; font-family: Menlo;"></span>pages/api<span class="Apple-converted-space"> </span>

will not be in codes that user can see
