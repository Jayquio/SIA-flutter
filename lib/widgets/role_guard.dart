import 'package:flutter/material.dart';
import '../data/auth_service.dart';

class RoleGuard extends StatelessWidget {
  const RoleGuard({
    super.key,
    required this.allowed,
    required this.child,
    this.unauthorizedMessage,
  });

  final Set<UserRole> allowed;
  final Widget child;
  final String? unauthorizedMessage;

  @override
  Widget build(BuildContext context) {
    final role = AuthService.instance.currentRole;
    final isAllowed = allowed.contains(role);
    if (isAllowed) return child;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.red.withValues(alpha: 0.08),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Icon(Icons.lock, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              unauthorizedMessage ?? 'Unauthorized for your role',
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
