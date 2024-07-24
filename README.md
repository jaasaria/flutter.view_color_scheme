<p align="center">
  <img src="./assets/images/default_avatar.jpg" width="350" title="View Color Scheme">
</p>

# View Color Scheme 👨‍🎨👨‍💻

## Features

The purpose of this package is to visually view color scheme by `Seeder` or by `ThemeData`.



## Installation

Add the package to `pubspec.yaml`

```
    $ flutter pub add package_name
```
or
```
    dependencies:
        view_color_scheme: ^0.0.1
```
or
```
    view_color_scheme:
        path: ../../plugins/view_color_scheme
```

After that import the package.
```
   import 'package:view_color_scheme/view_color_scheme.dart';
```


## Usage

There are 2 type of implementation, the `Seeder` and `ThemeData`. Bellow a sample usage on how to use the class.

1. View the color scheme by `Seeder`

```dart
    VcsOption.setSeedColor(Theme.of(context).colorScheme.primary);
    VcsHelper.navigateToColorSchemeScreen(context);
```

or force; use when doing debugging switching between states

```dart
    VcsOption.setThemeData(null);
    VcsOption.setSeedColor(Theme.of(context).colorScheme.primary);
    VcsHelper.navigateToColorSchemeScreen(context);
```

2. View the color scheme by `ThemeData`

```dart
    VcsOption.setThemeData(Theme.of(context));
    VcsHelper.navigateToColorSchemeScreen(context);
```



## TODO

- [ ] Ability to switch state beetween `Seeder` and `ThemeData` option.

---

Last updated on July 24, 2024
