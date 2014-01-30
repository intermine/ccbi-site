#Cambridge Computational Biology Institute

[![Built with Grunt](https://cdn.gruntjs.com/builtwith.png)](http://gruntjs.com/) [![Powered by Blad CMS](http://intermine.github.io/CDN/img/blad/80x15.gif)](https://github.com/radekstepan/blad)

##Quickstart

```bash
$ npm install
$ PORT=5000 DATABASE_URL=mongodb://localhost:27017/ccbi-site node start.js
```

##Development

###Bower & Grunt

Use [Bower](http://bower.io/) to fetch client-side vendor dependencies & [Grunt](http://gruntjs.com/) to build them including your [Stylus](http://learnboost.github.io/stylus/) files.

Install `npm` dependencies:

```bash
$ npm install -d
```

Get vendor libraries using `Bower`:

```bash
$ bower install
```

Watch styles and scripts and build them using `Grunt`:

```bash
$ watch --color -n 1 grunt
```