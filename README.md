# Minha Costureira

Aplicativo Flutter que conecta clientes a costureiras perto de casa — busca por serviço,
preço combinado antes, orçamento e pagamento pelo app. Implementado a partir do protótipo
completo ("direção 1a") desenhado no Claude Design.

## Fluxo

Abertura → escolha de perfil (cliente ou costureira) → cadastro (endereço do cliente, ou
serviços/preços/horário da costureira) → busca (mapa/lista, filtros por categoria, raio) →
perfil da costureira → orçamento e pagamento (Pix com QR code, cartão ou na retirada) →
confirmação → pedidos → perfil.

## Rodando o projeto

```bash
flutter pub get
flutter run
```

Testes:

```bash
flutter analyze
flutter test
```

## Estrutura

```
lib/
  main.dart              # entrypoint
  theme/                 # cores, tipografia, raios, sombras
  state/                 # AppState (ChangeNotifier) — toda a lógica do fluxo
  models/                # Costureira, Servico, Pedido, ClienteInfo
  widgets/                # botões, campos, QR code, ilustrações, etc.
  screens/                # cada tela do fluxo
```

Gerenciamento de estado com [provider](https://pub.dev/packages/provider); fontes via
[google_fonts](https://pub.dev/packages/google_fonts) (Bricolage Grotesque + Inter Tight).
