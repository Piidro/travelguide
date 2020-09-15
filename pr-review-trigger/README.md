# pr-review-trigger
A github action for detecting a "trigger word" in a pull request review

## Usage

Can only be triggered with `pull_request_review`. For instance:

```
on: 
  pull_request_review:
    types: [submitted]
```

## Re-compilation

In case of any changes, you need to have `zeit/ncc`. Install with `npm i -g @zeit/ncc`

Then: 
```
npm install
ncc build index.js
```
