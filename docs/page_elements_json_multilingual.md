# Tahoe Multilingual page builder

This doc is a follow up of [Tahoe multilingual content for page builder](https://docs.google.com/document/d/1Gzsl8GKlJg30CghPfsStgIKAL8czRdzd6_hRWYwy474/edit#heading=h.rsl5b6ay8bwo) in where we estimated and defined the work needed to add Multilingual support to the Tahoe Page Builder.

## Context
All the Management Console page builder data is stored in the Site Configuration model in the edX platform end, in the variable page elements (JSON). We don’t want to introduce changes in the edX platform unless it’s is 100% necessary. Following Matej’s recommendation, we’ll need to add a new level to this JSON to have different entries per language. In this way we'll be able to translate all the content of the `page elements` JSON.

## Proposed solutions
In [the original doc](https://docs.google.com/document/d/1Gzsl8GKlJg30CghPfsStgIKAL8czRdzd6_hRWYwy474/edit#heading=h.rsl5b6ay8bwo) we proposed two different ways to modify the `page elements` JSON structure, in order to support multilingual content.

Please check the following section of the [doc](https://docs.google.com/document/d/1Gzsl8GKlJg30CghPfsStgIKAL8czRdzd6_hRWYwy474/edit#heading=h.3kxtfi3pp7fu) in where the two proposed ways are detailed.

## Selected solution
We think the most elegant, sostenible and easy way to implement the change, is the solution one: *Adding languages at the top level of the JSON*.

### Current Structure
```
{
  "embargo":{
    "content":[]
  },
  "about":{
    "content":[
      "children":{
        "column-1":[]
      }
    ]
  }
}
```
### New structure
```
"en": {
    "embargo":{
      "content":[]
    },
    "about":{
      "content":[
        "children":{
          "column-1":[]
        }
      ]
    }
  },
  "es": {
    "embargo":{
      "content":[]
    },
    "about":{
      "content":[
        "children":{
          "column-1":[]
        }
      ]
    }
  }  
}
```
## Justification
Here are the main reasons why we've chosen this solution.

* Elegancy and clarity: With this approach we can handle most of the logic in the backend code, returning the selected language that is gonna be present in the header request.
* Data Migration: In this way we only add a new level at the top of the JSON structure. In the other approach, we introduce the "language level" in all the different properties in the structure, which is gonna introduce a lot of work in the migrations scripts, to manipulate the data.
* Defaults translations: This structure allow us to manage the concept of default language, for now we'll use english, but is something we can allow the user to set in the future. With this structure is easy replace any missing element in JSON with the default values in `en`.

## Risks
We'll to be extra careful keeping the structure in sync. Every time a new value is added to the structure, it need to be replicated to all the sibling languages, even if the value is empty in other languages.

### Sanity Check
Write a small linter that goes through the languages in the JSON and either warns when there aren't corresponding entries for all languages or automatically inserts the default ones when necessary.
