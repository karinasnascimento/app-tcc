import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/dvanille_brand.dart';
import '../../widgets/product_widgets.dart';
import '../menu/product_details_screen.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Scaffold(
      appBar: const DVanilleHeader(title: 'Ofertas'),
      body: ListenableBuilder(
        listenable: state,
        builder: (context, _) {
          final ofertas = state.products.where((p) => p.emOferta).toList();
          return SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle('Ofertas especiais'),
                if (ofertas.isEmpty)
                  const EmptyState(icon: Icons.local_offer_outlined, message: 'No momento não há ofertas disponíveis.')
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: ofertas.length,
                    itemBuilder: (context, i) {
                      final p = ofertas[i];
                      return ProductCard(
                        product: p,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: p)),
                        ),
                      );
                    },
                  ),
                const SectionTitle('Vale-presente 🎁'),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.beige.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Presenteie alguém com D\'Vanille',
                          style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.brownStrong, fontSize: 15)),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/vale-presente'),
                        child: const Text('COMPRAR VALE-PRESENTE'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/meus-vales'),
                    child: const Text('MEUS VALES-PRESENTE'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}

class GiftCardScreen extends StatefulWidget {
  const GiftCardScreen({super.key});
  @override
  State<GiftCardScreen> createState() => _GiftCardScreenState();
}

class _GiftCardScreenState extends State<GiftCardScreen> {
  double? selected = 50;
  final _customCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const valores = [25.0, 50.0, 100.0, 150.0];
    return Scaffold(
      appBar: const DVanilleHeader(title: 'Vale-presente', showBack: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Escolha o valor', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.brownStrong)),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: valores.map((v) {
                final sel = selected == v;
                return GestureDetector(
                  onTap: () => setState(() {
                    selected = v;
                    _customCtrl.clear();
                  }),
                  child: Container(
                    width: 80,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: sel ? AppColors.brown : AppColors.white,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: sel ? AppColors.brown : AppColors.beige),
                    ),
                    child: Text('R\$${v.toStringAsFixed(0)}',
                        style: TextStyle(color: sel ? Colors.white : AppColors.brownStrong, fontWeight: FontWeight.w700)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _customCtrl,
              keyboardType: TextInputType.number,
              onChanged: (v) => setState(() => selected = double.tryParse(v)),
              decoration: const InputDecoration(hintText: 'Valor personalizado (R\$)'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: selected == null || selected! <= 0
                  ? null
                  : () {
                      final card = AppState.instance.buyGiftCard(selected!);
                      showBrandSnackBar(context, 'Vale-presente criado com sucesso!', icon: Icons.card_giftcard);
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: AppColors.cream,
                          title: const Text('Vale-presente gerado'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Valor: R\$ ${card.valor.toStringAsFixed(2)}'),
                              Text('Código: ${card.codigo}'),
                              Text('Validade: ${card.validade.day}/${card.validade.month}/${card.validade.year}'),
                            ],
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
                          ],
                        ),
                      );
                    },
              child: const Text('COMPRAR VALE-PRESENTE'),
            ),
          ],
        ),
      ),
    );
  }
}

class MyGiftCardsScreen extends StatelessWidget {
  const MyGiftCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Scaffold(
      appBar: const DVanilleHeader(title: 'Meus vales-presente', showBack: true),
      body: ListenableBuilder(
        listenable: state,
        builder: (context, _) {
          if (state.giftCards.isEmpty) {
            return const EmptyState(icon: Icons.card_giftcard_outlined, message: 'Você ainda não possui vales-presente.');
          }
          return ListView.separated(
            padding: const EdgeInsets.all(18),
            itemCount: state.giftCards.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final g = state.giftCards[i];
              return DVanilleCard(
                child: Row(
                  children: [
                    const Icon(Icons.card_giftcard, color: AppColors.brown),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('R\$ ${g.valor.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.brownStrong)),
                          Text(g.codigo, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                          Text('Válido até ${g.validade.day}/${g.validade.month}/${g.validade.year}',
                              style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                    Text(g.usado ? 'Usado' : 'Ativo',
                        style: TextStyle(color: g.usado ? AppColors.textMuted : AppColors.success, fontWeight: FontWeight.w600)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
