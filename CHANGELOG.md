## [1.0.21] - May 18th, 2022

1. Update to Flutter 3
2. Fix issue with warnings.
3. Update home page information.

## [1.0.17] - October 4th, 2021

1. Make save on MvvmForm FutureOr<bool> instead of just Future<bool>

## [1.0.16] - October 1st, 2021

1. Update onLoad to be FutureOr<void> instead of just Future
2. Add onLoad to ViewModelBuilder.

## [1.0.14] - September 27th, 2021

1. Add short hande ready, error etc. methods on ViewModel for emitting.

## [1.0.12] - September 22nd, 2021

1. Fix issue with onLoad that would cause loading of final page when it wasn't finished loading.

## [1.0.8] - September 16th, 2021

1. Add onLoad parameter that takes a future for loading the page. When complete the status should be set to ready or error.

## [1.0.7] - September 10th, 2021

1. Update to Dart 2.14
2. Add linting

## [1.0.6] - August 30, 2021

1. Add URL Validation

## [1.0.5] - August 26, 2021

1. Fixed issue with email validation

## [1.0.4] - August 10, 2021

1. Enable localization text for validation prompts

## [1.0.3] - August 4, 2021

1. Removed IJsonable as not required
2. Allow TextInputFields to be nullable fields

## [1.0.1] - July 29, 2021

1. Converted to part notation and fixed a bug.

## [1.0.0+1] - July 26, 2021

1. Initial Release.
