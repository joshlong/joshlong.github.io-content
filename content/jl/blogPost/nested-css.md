title=Nested CSS 
date=2024-11-10
type=post
tags=blog
status=published
~~~~~~

I was watching a [Kevin Powell](https://www.youtube.com/user/KepowOb) video on CSS the other day and he mentioned that modern browsers (which, unless you're using Internet Explorer or Safari, is _every browser_, since they're all "evergreen" these days) supported nested CSS rules. (And strictly speaking Safari is "quasi evergreen," since it gets frequent updates, they're just installed in the operating system's updates, not directly via Safari.) I knew how to use  nested CSS rules with preprocessors like Sass/SCSS, but had no idea they were supported natively! _NICE_! 

So, here are some of my notes on the topic. 


## Basic Nesting

```css
.parent {
    color: blue;
    
    .child {
        color: red;
    }
}
```

Compiles to: 

```css
.parent {
    color: blue;
}
.parent .child {
    color: red;
}
```

## Multiple Levels

```css

.grandparent {
    .parent {
        .child {
            color: red;
        }
    }
}
```

## Using & (Parent Selector)

```css
.button {
    color: blue;
    
    &:hover {
        color: red;
    }
    
    &.active {
        color: green;
    }
    
    &-primary {
        background: gold;
    }
}
```

compiles to:

```css
.button { color: blue; }
.button:hover { color: red; }
.button.active { color: green; }
.button-primary { background: gold; }
```

## Combining with Media Queries

```css 
.sidebar {
    width: 300px;
    
    @media (max-width: 768px) {
        & {
            width: 100%;
        }
    }
}
```

## Nesting Pseudo-classes and Elements

```css
.link {
    color: blue;
    
    &:hover {
        color: red;
    }
    
    &::before {
        content: "→";
    }
}
```

## Multiple Selectors

```css 
.heading, .title {
    font-weight: bold;
    
    & span {
        color: red;
    }
}
```

Compiles to: 

```css
.heading, .title { font-weight: bold; }
.heading span, .title span { color: red; }
```


## Direct Child Selector

```css 
.parent {
    > .child {
        /* Only direct children */
        color: blue;
    }
}
```

## Important Notes:

This is amazing. As with all things tho, some caveats:

* don't nest too deely, lest you end up with something too difficult to maintain or use.
* Always test. Remember this is a _new_ feature and not supported by all browsers. All the major browsers, sure, [but not _all_ of them](https://caniuse.com/?search=nested%20css). 
