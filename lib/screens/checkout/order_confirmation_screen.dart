import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/dvanille_brand.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});
  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  Order? order;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    order ??= AppState.instance.createOrder();
  }

  @override
  Widget build(BuildContext context) {
    final o = order;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BowDecoration(size: 56),
                const SizedBox(height: 18),
                const DVanilleLogo(height: 56),
                const SizedBox(height: 20),
                const Icon(Icons.check_circle, color: AppColors.success, size: 48),
                const SizedBox(height: 10),
                Text('PEDIDO REALIZADO!', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('Seu pedido foi recebido.', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 18),
                if (o != null)
                  DVanilleCard(
                    child: Column(
                      children: [
                        Text('Pedido ${o.numeroPedido}',
                            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.brownStrong)),
                        const SizedBox(height: 6),
                        const Text('Previsão: 25–40 min', style: TextStyle(color: AppColors.textMuted)),
                        const SizedBox(height: 6),
                        Text('Pagamento: ${o.metodoPagamento.label}', style: const TextStyle(color: AppColors.textMuted)),
                        Text(o.tipoEntrega == TipoEntrega.delivery ? 'Delivery' : 'Retirada na loja',
                            style: const TextStyle(color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/main', (r) => false);
                    Navigator.pushNamed(context, '/rastreamento', arguments: o);
                  },
                  child: const Text('ACOMPANHAR PEDIDO'),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/main', (r) => false),
                  child: const Text('VOLTAR AO INÍCIO'),
                ),
                const SizedBox(height: 20),
                const BowDecoration(size: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
