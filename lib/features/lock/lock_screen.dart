import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/backup.dart';
import '../../core/profile.dart';
import '../../core/security.dart';
import '../../l10n/l10n.dart';
import '../../shared/deer_icon.dart';
import '../../shared/widgets.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  @override
  void initState() {
    super.initState();
    if (ref.read(profileProvider).biometrics) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _biometric());
    }
  }

  Future<void> _biometric() async {
    if (await ref.read(securityProvider).authenticateBiometric(context.l10n.biometricReason)) {
      ref.read(unlockedProvider.notifier).unlock();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final profile = ref.watch(profileProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                DeerIcon(size: 44, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 16),
                Text(profile.name.isEmpty ? l.welcomeBack : l.welcomeBackName(profile.name),
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 32),
                PinPad(
                  onComplete: (pin) async {
                    final ok = await ref.read(securityProvider).verifyPin(pin);
                    if (ok) ref.read(unlockedProvider.notifier).unlock();
                    return ok;
                  },
                  extraAction: profile.biometrics
                      ? IconButton(onPressed: _biometric, icon: const Icon(Icons.fingerprint, size: 32))
                      : null,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () async {
                    final ok = await confirmDialog(
                      context,
                      title: l.forgotPinTitle,
                      body: l.forgotPinBody,
                      confirm: l.eraseEverything,
                      destructive: true,
                    );
                    if (ok) await resetAllData(ref);
                  },
                  child: Text(l.forgotPin),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
