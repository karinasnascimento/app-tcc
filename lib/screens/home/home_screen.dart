import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/dvanille_brand.dart';
import '../../widgets/product_widgets.dart';
import '../menu/product_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Scaffold(
      appBar: DVanilleHeader(
        showDrawerButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: AppColors.brownStrong),
            onPressed: () => Navigator.pushNamed(context, '/notificacoes'),
          ),
        ],
      ),
      drawer: const _HomeDrawer(),
      body: ListenableBuilder(
        listenable: state,
        builder: (context, _) {
          final populares = state.products.where((p) => p.popular).toList();
          final outros = state.products;
          final ofertas = state.products.where((p) => p.emOferta).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text('Olá, ${state.user.nome.split(' ').first}!',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text('Que tal um docinho hoje?', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/cardapio'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(color: AppColors.beige),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.search, color: AppColors.textMuted, size: 20),
                        SizedBox(width: 10),
                        Text('O que você procura?', style: TextStyle(color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                ),
                const SectionTitle('Categorias'),
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: ProductCategory.values.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, i) {
                      final cat = ProductCategory.values[i];
                      return CategoryChip(
                        label: cat.label,
                        selected: false,
                        onTap: () => Navigator.pushNamed(context, '/cardapio', arguments: cat),
                      );
                    },
                  ),
                ),
                const SectionTitle('Populares'),
                SizedBox(
                  height: 190,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: populares.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      final p = populares[i];
                      return SizedBox(
                        width: 140,
                        child: ProductCard(
                          product: p,
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: p))),
                        ),
                      );
                    },
                  ),
                ),
                const SectionTitle('Doces, milkshakes e cafés'),
                SizedBox(
                  height: 190,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: outros.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      final p = outros[i];
                      return SizedBox(
                        width: 140,
                        child: ProductCard(
                          product: p,
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: p))),
                        ),
                      );
                    },
                  ),
                ),
                const SectionTitle('Ofertas'),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/ofertas'),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.pink.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Column(
                      children: [
                        const Text('🎁', style: TextStyle(fontSize: 30)),
                        const SizedBox(height: 6),
                        Text(
                          ofertas.isEmpty
                              ? 'Confira nossas ofertas especiais'
                              : '${ofertas.length} produtos em oferta especial',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.brownStrong),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Center(child: BowDecoration()),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HomeDrawer extends StatelessWidget {
  const _HomeDrawer();

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Drawer(
      backgroundColor: AppColors.cream,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: DVanilleLogo(height: 56)),
            const SizedBox(height: 20),
            const Divider(),
            _drawerItem(context, Icons.home_outlined, 'Início', () => Navigator.pop(context)),
            _drawerItem(context, Icons.favorite_border, 'Favoritos', () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/favoritos');
            }),
            _drawerItem(context, Icons.receipt_long_outlined, 'Meus pedidos', () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/pedidos');
            }),
            _drawerItem(context, Icons.card_giftcard_outlined, 'Vale-presente', () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/ofertas');
            }),
            _drawerItem(context, Icons.settings_outlined, 'Configurações', () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/configuracoes');
            }),
            if (state.isAdmin)
              _drawerItem(context, Icons.admin_panel_settings_outlined, 'Área administrativa', () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/admin');
              }),
            const Spacer(),
            _drawerItem(context, Icons.logout, 'Sair', () {
              state.logout();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.brownStrong),
      title: Text(label, style: const TextStyle(color: AppColors.brownStrong, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }
}
