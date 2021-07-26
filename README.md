# reactive_mvvm

Reactive MVVM seeks to solve the fundamental issues with flutter state management especially revolving around forms by formalizing the relationship between updates of forms versus pages/views and even specific fields.

It works similarly to bloc pattern using a model for managing forms similar to other mvvm libraries at the same time, but eliminates the enormous boilerplate required to make bloc pattern work correctly with forms without causing issues, and provide flexibility to refresh based on specific changes while allowing you to listen to other changes that might be important to you.

Form management formalizes validation, saving and state management integration as well ensuring that saves and validation are completely integrated with your state management on forms.

Reactive MVVM uses rxjs internally and allows create custom wrappers for any other controls that aren't included with a few lines of code that will then work wtih Reactive MVVM's form state management.

## Getting Started

TODO
