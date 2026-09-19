import 'package:flutter/material.dart';

import 'models/models.dart';
import 'theme/app_theme.dart';

import 'screens/auth/auth_screens.dart';
import 'screens/home/main_nav_screen.dart';
import 'screens/menu/menu_screen.dart';
import 'screens/menu/product_details_screen.dart';
import 'screens/favorites/favorites_screen.dart';
import 'screens/offers/offers_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/checkout/delivery_screen.dart';
import 'screens/checkout/payment_screen.dart';
import 'screens/checkout/order_confirmation_screen.dart';
import 'screens/orders/orders_screens.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/addresses_screen.dart';
import 'screens/profile/restrictions_notifications_settings.dart';
import 'screens/admin/admin_screens.dart';

void main() {
  runApp(const DVanilleApp());
}

class DVanilleApp extends StatelessWidget {
  const DVanilleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "D'Vanille",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/login',
      routes: {
        // Autenticação
        '/login': (context) => const LoginScreen(),
        '/cadastro': (context) => const CadastroScreen(),
        '/recuperar': (context) => const RecuperarScreen(),
        '/emailok': (context) => const EmailOkScreen(),
        '/emailfail': (context) => const EmailFailScreen(),

        // Navegação principal
        '/main': (context) => const MainNavScreen(),
        '/home': (context) => const MainNavScreen(),
        '/cardapio': (context) => const MenuScreen(),
        '/ofertas': (context) => const OffersScreen(),

        // Favoritos / vale-presente
        '/favoritos': (context) => const FavoritesScreen(),
        '/vale-presente': (context) => const GiftCardScreen(),
        '/meus-vales': (context) => const MyGiftCardsScreen(),

        // Carrinho / checkout
        '/carrinho': (context) => const CartScreen(),
        '/revisar-pedido': (context) => const ReviewOrderScreen(),
        '/entrega': (context) => const DeliveryScreen(),
        '/pagamento': (context) => const PaymentScreen(),
        '/checkout-ok': (context) => const OrderConfirmationScreen(),

        // Pedidos
        '/pedidos': (context) => const OrdersScreen(),

        // Perfil
        '/perfil': (context) => const ProfileScreen(),
        '/editar-perfil': (context) => const EditProfileScreen(),
        '/enderecos': (context) => const AddressesScreen(),
        '/restricoes': (context) => const RestrictionsScreen(),
        '/notificacoes': (context) => const NotificationsScreen(),
        '/configuracoes': (context) => const SettingsScreen(),

        // Admin
        '/admin': (context) => const AdminDashboardScreen(),
        '/admin-produtos': (context) => const AdminProductsScreen(),
        '/admin-pedidos': (context) => const AdminOrdersScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/detalhes':
            final product = settings.arguments as Product;
            return MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product));
          case '/pedido-detalhes':
            final order = settings.arguments as Order;
            return MaterialPageRoute(builder: (_) => OrderDetailsScreen(order: order));
          case '/rastreamento':
            final order = settings.arguments as Order;
            return MaterialPageRoute(builder: (_) => OrderTrackingScreen(order: order));
        }
        return null;
      },
    );
  }
}
