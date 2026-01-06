import 'package:flutter/material.dart';

class MealCardSiddharth extends StatelessWidget {
  final String mealName;
  final String mealTypeLabel;
  final IconData icon;
  final Color themeColor;
  final String? imageUrl;
  final String? calories;
  final VoidCallback? onTap;

  const MealCardSiddharth({
    super.key,
    required this.mealName,
    required this.mealTypeLabel,
    this.icon = Icons.fastfood_rounded,
    this.themeColor = Colors.orange,
    this.imageUrl,
    this.calories,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            splashColor: themeColor.withValues(alpha: 0.1),
            highlightColor: themeColor.withValues(alpha: 0.05),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _buildVisualSection(),

                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTypePill(),
                        const SizedBox(height: 6),
                        Text(
                          mealName,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: -0.5,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  _buildRightSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVisualSection() {
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [themeColor.withValues(alpha: 0.2), themeColor.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildIconPlaceholder(),
              ),
            )
          : _buildIconPlaceholder(),
    );
  }

  Widget _buildIconPlaceholder() {
    return Center(child: Icon(icon, color: themeColor, size: 30));
  }

  Widget _buildTypePill() {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: themeColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          mealTypeLabel.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.grey[600],
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildRightSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (calories != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.local_fire_department_rounded,
                  size: 14,
                  color: Colors.deepOrange,
                ),
                const SizedBox(width: 4),
                Text(
                  calories!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: Colors.grey[300],
        ),
      ],
    );
  }
}
