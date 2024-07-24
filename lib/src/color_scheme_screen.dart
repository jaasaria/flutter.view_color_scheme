import 'package:view_color_scheme/src/helper/vcs_option.dart';
import 'package:flutter/material.dart';

const Widget divider = SizedBox(height: 10);

class ColorSchemeScreen extends StatefulWidget {
  const ColorSchemeScreen({super.key});

  @override
  State<ColorSchemeScreen> createState() => _ColorSchemeScreenState();
}

class _ColorSchemeScreenState extends State<ColorSchemeScreen> {
  late List<ColorPallete> colorPalleteListing = [];
  late Color selectedColor;

  @override
  void initState() {
    super.initState();

    if (VcsOption.themeData == null) {
      colorPalleteListing.addAll(ColorPallete.listing);
    }
    colorPalleteListing.insert(
      0,
      ColorPallete(
        (VcsOption.themeData != null) ? "Primary Color" : "Seed Color",
        VcsOption.themeData?.primaryColor ?? VcsOption.seedColor,
      ),
    );

    selectedColor = colorPalleteListing.first.color;
  }

  Brightness selectedBrightness =
      VcsOption.themeData?.brightness ?? Brightness.light;

  static const List<DynamicSchemeVariant> schemeVariants =
      DynamicSchemeVariant.values;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: VcsOption.themeData ??
          ThemeData(
              colorScheme: ColorScheme.fromSeed(
            seedColor: selectedColor,
            brightness: selectedBrightness,
          )),
      child: Builder(
        builder: (BuildContext context) => Scaffold(
          appBar: AppBar(
            title: const Text('ColorScheme'),
            actions: <Widget>[
              Offstage(
                offstage: VcsOption.themeData != null,
                child: Row(
                  children: <Widget>[
                    const Text('Color Seed'),
                    MenuAnchor(
                      builder: (BuildContext context, MenuController controller,
                          Widget? widget) {
                        return IconButton(
                          icon: Icon(Icons.circle, color: selectedColor),
                          onPressed: () {
                            setState(() {
                              if (!controller.isOpen) {
                                controller.open();
                              }
                            });
                          },
                        );
                      },
                      menuChildren: List<Widget>.generate(
                          colorPalleteListing.length, (int index) {
                        final Color itemColor =
                            colorPalleteListing[index].color;

                        return MenuItemButton(
                          leadingIcon: selectedColor ==
                                  colorPalleteListing[index].color
                              ? Icon(Icons.circle, color: itemColor)
                              : Icon(Icons.circle_outlined, color: itemColor),
                          onPressed: () {
                            setState(() {
                              selectedColor = itemColor;
                            });
                          },
                          child: Text(colorPalleteListing[index].label),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Offstage(
                    offstage: VcsOption.themeData != null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: <Widget>[
                          const Text('Brightness'),
                          const SizedBox(width: 10),
                          Switch(
                            value: selectedBrightness == Brightness.light,
                            onChanged: (bool value) {
                              setState(() {
                                selectedBrightness =
                                    value ? Brightness.light : Brightness.dark;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (VcsOption.themeData != null)
                    ColorSchemeVariantColumn(
                      selectedColor: selectedColor,
                    )
                  else
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List<Widget>.generate(schemeVariants.length,
                            (int index) {
                          return ColorSchemeVariantColumn(
                            selectedColor: selectedColor,
                            brightness: selectedBrightness,
                            schemeVariant: schemeVariants[index],
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ColorSchemeVariantColumn extends StatelessWidget {
  const ColorSchemeVariantColumn({
    super.key,
    this.schemeVariant = DynamicSchemeVariant.tonalSpot,
    this.brightness = Brightness.light,
    required this.selectedColor,
  });

  final DynamicSchemeVariant schemeVariant;
  final Brightness brightness;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: 250),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                schemeVariant.name == 'tonalSpot'
                    ? '${schemeVariant.name} (Default)'
                    : schemeVariant.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ColorSchemeView(
                colorScheme: VcsOption.themeData?.colorScheme ??
                    ColorScheme.fromSeed(
                      seedColor: selectedColor,
                      brightness: brightness,
                      dynamicSchemeVariant: schemeVariant,
                    ),
              ),
            ),
          ],
        ));
  }
}

class ColorSchemeView extends StatelessWidget {
  const ColorSchemeView({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ColorGroup(children: <ColorChip>[
          ColorChip('primary', colorScheme.primary, colorScheme.onPrimary),
          ColorChip('onPrimary', colorScheme.onPrimary, colorScheme.primary),
          ColorChip('primaryContainer', colorScheme.primaryContainer,
              colorScheme.onPrimaryContainer),
          ColorChip(
            'onPrimaryContainer',
            colorScheme.onPrimaryContainer,
            colorScheme.primaryContainer,
          ),
        ]),
        divider,
        ColorGroup(children: <ColorChip>[
          ColorChip('primaryFixed', colorScheme.primaryFixed,
              colorScheme.onPrimaryFixed),
          ColorChip('onPrimaryFixed', colorScheme.onPrimaryFixed,
              colorScheme.primaryFixed),
          ColorChip('primaryFixedDim', colorScheme.primaryFixedDim,
              colorScheme.onPrimaryFixedVariant),
          ColorChip(
            'onPrimaryFixedVariant',
            colorScheme.onPrimaryFixedVariant,
            colorScheme.primaryFixedDim,
          ),
        ]),
        divider,
        ColorGroup(children: <ColorChip>[
          ColorChip(
              'secondary', colorScheme.secondary, colorScheme.onSecondary),
          ColorChip(
              'onSecondary', colorScheme.onSecondary, colorScheme.secondary),
          ColorChip(
            'secondaryContainer',
            colorScheme.secondaryContainer,
            colorScheme.onSecondaryContainer,
          ),
          ColorChip(
            'onSecondaryContainer',
            colorScheme.onSecondaryContainer,
            colorScheme.secondaryContainer,
          ),
        ]),
        divider,
        ColorGroup(children: <ColorChip>[
          ColorChip('secondaryFixed', colorScheme.secondaryFixed,
              colorScheme.onSecondaryFixed),
          ColorChip('onSecondaryFixed', colorScheme.onSecondaryFixed,
              colorScheme.secondaryFixed),
          ColorChip(
            'secondaryFixedDim',
            colorScheme.secondaryFixedDim,
            colorScheme.onSecondaryFixedVariant,
          ),
          ColorChip(
            'onSecondaryFixedVariant',
            colorScheme.onSecondaryFixedVariant,
            colorScheme.secondaryFixedDim,
          ),
        ]),
        divider,
        ColorGroup(
          children: <ColorChip>[
            ColorChip('tertiary', colorScheme.tertiary, colorScheme.onTertiary),
            ColorChip(
                'onTertiary', colorScheme.onTertiary, colorScheme.tertiary),
            ColorChip(
              'tertiaryContainer',
              colorScheme.tertiaryContainer,
              colorScheme.onTertiaryContainer,
            ),
            ColorChip(
              'onTertiaryContainer',
              colorScheme.onTertiaryContainer,
              colorScheme.tertiaryContainer,
            ),
          ],
        ),
        divider,
        ColorGroup(children: <ColorChip>[
          ColorChip('tertiaryFixed', colorScheme.tertiaryFixed,
              colorScheme.onTertiaryFixed),
          ColorChip('onTertiaryFixed', colorScheme.onTertiaryFixed,
              colorScheme.tertiaryFixed),
          ColorChip('tertiaryFixedDim', colorScheme.tertiaryFixedDim,
              colorScheme.onTertiaryFixedVariant),
          ColorChip(
            'onTertiaryFixedVariant',
            colorScheme.onTertiaryFixedVariant,
            colorScheme.tertiaryFixedDim,
          ),
        ]),
        divider,
        ColorGroup(
          children: <ColorChip>[
            ColorChip('error', colorScheme.error, colorScheme.onError),
            ColorChip('onError', colorScheme.onError, colorScheme.error),
            ColorChip('errorContainer', colorScheme.errorContainer,
                colorScheme.onErrorContainer),
            ColorChip('onErrorContainer', colorScheme.onErrorContainer,
                colorScheme.errorContainer),
          ],
        ),
        divider,
        ColorGroup(
          children: <ColorChip>[
            ColorChip(
                'surfaceDim', colorScheme.surfaceDim, colorScheme.onSurface),
            ColorChip('surface', colorScheme.surface, colorScheme.onSurface),
            ColorChip('surfaceBright', colorScheme.surfaceBright,
                colorScheme.onSurface),
            ColorChip('surfaceContainerLowest',
                colorScheme.surfaceContainerLowest, colorScheme.onSurface),
            ColorChip('surfaceContainerLow', colorScheme.surfaceContainerLow,
                colorScheme.onSurface),
            ColorChip('surfaceContainer', colorScheme.surfaceContainer,
                colorScheme.onSurface),
            ColorChip('surfaceContainerHigh', colorScheme.surfaceContainerHigh,
                colorScheme.onSurface),
            ColorChip('surfaceContainerHighest',
                colorScheme.surfaceContainerHighest, colorScheme.onSurface),
            ColorChip('onSurface', colorScheme.onSurface, colorScheme.surface),
            ColorChip(
              'onSurfaceVariant',
              colorScheme.onSurfaceVariant,
              colorScheme.surfaceContainerHighest,
            ),
          ],
        ),
        divider,
        ColorGroup(
          children: <ColorChip>[
            ColorChip('outline', colorScheme.outline, null),
            ColorChip('shadow', colorScheme.shadow, null),
            ColorChip('inverseSurface', colorScheme.inverseSurface,
                colorScheme.onInverseSurface),
            ColorChip('onInverseSurface', colorScheme.onInverseSurface,
                colorScheme.inverseSurface),
            ColorChip('inversePrimary', colorScheme.inversePrimary,
                colorScheme.primary),
          ],
        ),
      ],
    );
  }
}

class ColorGroup extends StatelessWidget {
  const ColorGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child:
          Card(clipBehavior: Clip.antiAlias, child: Column(children: children)),
    );
  }
}

class ColorChip extends StatelessWidget {
  const ColorChip(this.label, this.color, this.onColor, {super.key});

  final Color color;
  final Color? onColor;
  final String label;

  static Color contrastColor(Color color) {
    final Brightness brightness = ThemeData.estimateBrightnessForColor(color);
    return brightness == Brightness.dark ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final Color labelColor = onColor ?? contrastColor(color);
    return ColoredBox(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Expanded>[
            Expanded(child: Text(label, style: TextStyle(color: labelColor))),
          ],
        ),
      ),
    );
  }
}

class ColorPallete {
  const ColorPallete(this.label, this.color);
  final String label;
  final Color color;

  static List<ColorPallete> get listing => [
        const ColorPallete('M3 Baseline', Color(0xff6750a4)),
        const ColorPallete('Indigo', Colors.indigo),
        const ColorPallete('Blue', Colors.blue),
        const ColorPallete('Teal', Colors.teal),
        const ColorPallete('Green', Colors.green),
        const ColorPallete('Yellow', Colors.yellow),
        const ColorPallete('Orange', Colors.orange),
        const ColorPallete('Deep Orange', Colors.deepOrange),
        const ColorPallete('Pink', Colors.pink),
        const ColorPallete('Bright Blue', Color(0xFF0000FF)),
        const ColorPallete('Bright Green', Color(0xFF00FF00)),
        const ColorPallete('Bright Red', Color(0xFFFF0000))
      ];

  static void addAtFirstIndex(ColorPallete colorPallete) {
    listing.insert(0, colorPallete);
  }
}
