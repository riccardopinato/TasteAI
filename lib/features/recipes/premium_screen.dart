import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../data/premium/premium_controller.dart';
import '../../data/premium/premium_service.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({
    super.key,
    required this.controller,
  });

  final PremiumController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        final AppStrings strings = AppStrings.of(context);
        return Scaffold(
          appBar: AppBar(title: Text(strings.tasteAiPlus)),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            children: <Widget>[
              Icon(
                Icons.workspace_premium,
                size: 62,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 14),
              Text(
                strings.plusTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                strings.plusBody,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              _Benefit(text: strings.plusBenefitPremiumRecipes),
              _Benefit(text: strings.plusBenefitLocalAi),
              _Benefit(text: strings.plusBenefitFutureFeatures),
              const SizedBox(height: 22),
              if (controller.isPlus)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.verified),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            strings.plusActive,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (controller.status ==
                  PremiumStatus.notConfigured)
                _MessageCard(text: strings.premiumNotConfigured)
              else if (controller.status ==
                  PremiumStatus.unsupported)
                _MessageCard(text: strings.premiumWebUnavailable)
              else ...<Widget>[
                if (controller.packages.isEmpty &&
                    !controller.busy)
                  _MessageCard(text: strings.noPremiumPackages),
                for (final PremiumPackageOption option
                    in controller.packages) ...<Widget>[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            option.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          if (option.description.isNotEmpty) ...<Widget>[
                            const SizedBox(height: 6),
                            Text(option.description),
                          ],
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: controller.busy
                                ? null
                                : () => controller.purchase(
                                      option.identifier,
                                    ),
                            child: Text(
                              '${strings.subscribeFor} '
                              '${option.priceString}',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                if (controller.configured &&
                    controller.supported)
                  OutlinedButton.icon(
                    onPressed:
                        controller.busy ? null : controller.restore,
                    icon: const Icon(Icons.restore),
                    label: Text(strings.restorePurchases),
                  ),
              ],
              if (controller.busy) ...<Widget>[
                const SizedBox(height: 16),
                const LinearProgressIndicator(),
              ],
              if (controller.status == PremiumStatus.error) ...<Widget>[
                const SizedBox(height: 12),
                _MessageCard(text: strings.premiumError),
              ],
              const SizedBox(height: 18),
              Text(
                strings.premiumPriceStoreNotice,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Benefit extends StatelessWidget {
  const _Benefit({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: <Widget>[
          const Icon(Icons.check_circle_outline, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}
