import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../state/formatters.dart';
import '../theme/app_theme.dart';
import '../widgets/app_input.dart';
import '../widgets/buttons.dart';

class CadProStep1Screen extends StatefulWidget {
  const CadProStep1Screen({super.key});

  @override
  State<CadProStep1Screen> createState() => _CadProStep1ScreenState();
}

class _CadProStep1ScreenState extends State<CadProStep1Screen> {
  late final TextEditingController _novoNome;

  @override
  void initState() {
    super.initState();
    _novoNome = TextEditingController();
  }

  @override
  void dispose() {
    _novoNome.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RoundIconButton(icon: Icons.chevron_left_rounded, onPressed: state.back),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.neutral300,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.accent500,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('1 de 2', style: bodyFont(fontSize: 12, weight: FontWeight.w700, color: textMuted(0.55))),
            ],
          ),
          const SizedBox(height: 14),
          Text('O que você costura?', style: headingFont(fontSize: 25)),
          const SizedBox(height: 4),
          Text(
            'Marque os serviços e ajuste o preço. Você muda quando quiser.',
            style: bodyFont(fontSize: 13.5, color: textMuted(0.6)),
          ),
          const SizedBox(height: 16),
          for (final s in state.servicos) ...[
            _ServicoRow(
              nome: s.nome,
              preco: s.preco,
              on: s.on,
              onToggle: () => state.toggleServico(s.id),
              onInc: () => state.incServico(s.id),
              onDec: () => state.decServico(s.id),
            ),
            const SizedBox(height: 10),
          ],
          if (!state.novoAberto)
            _AddServiceButton(onTap: state.abrirNovo)
          else
            _NovoServicoCard(
              controller: _novoNome,
              preco: state.novoPreco,
              onNomeChanged: state.setNovoNome,
              onInc: state.novoInc,
              onDec: state.novoDec,
              onCancel: () {
                _novoNome.clear();
                state.cancelarNovo();
              },
              onSalvar: () {
                state.salvarNovo();
                _novoNome.clear();
              },
            ),
          const SizedBox(height: 14),
          PrimaryButton(label: state.cad1Cta, onPressed: state.toCad2),
        ],
      ),
    );
  }
}

class _ServicoRow extends StatelessWidget {
  final String nome;
  final int preco;
  final bool on;
  final VoidCallback onToggle;
  final VoidCallback onInc;
  final VoidCallback onDec;

  const _ServicoRow({
    required this.nome,
    required this.preco,
    required this.on,
    required this.onToggle,
    required this.onInc,
    required this.onDec,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      decoration: BoxDecoration(
        color: on ? AppColors.accent100 : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: on ? AppColors.accent400 : Colors.transparent, width: 2),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onToggle,
              child: Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: on ? AppColors.accent600 : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: on ? AppColors.accent600 : AppColors.neutral400, width: 2),
                    ),
                    child: on ? const Icon(Icons.check, size: 15, color: AppColors.bg) : null,
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      nome,
                      style: bodyFont(fontSize: 14.5, weight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (on) ...[
            RoundStepperButton(icon: Icons.remove, onPressed: onDec),
            SizedBox(
              width: 62,
              child: Text(brl(preco), textAlign: TextAlign.center, style: headingFont(fontSize: 16)),
            ),
            RoundStepperButton(icon: Icons.add, onPressed: onInc),
          ],
        ],
      ),
    );
  }
}

class _AddServiceButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddServiceButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.accent400, width: 2, style: BorderStyle.solid),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, size: 18, color: AppColors.accent700),
              const SizedBox(width: 8),
              Text(
                'Adicionar outro serviço',
                style: bodyFont(fontSize: 14.5, weight: FontWeight.w700, color: AppColors.accent700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NovoServicoCard extends StatelessWidget {
  final TextEditingController controller;
  final int preco;
  final ValueChanged<String> onNomeChanged;
  final VoidCallback onInc;
  final VoidCallback onDec;
  final VoidCallback onCancel;
  final VoidCallback onSalvar;

  const _NovoServicoCard({
    required this.controller,
    required this.preco,
    required this.onNomeChanged,
    required this.onInc,
    required this.onDec,
    required this.onCancel,
    required this.onSalvar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accent100,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.accent400, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FieldLabel('Nome do serviço'),
          AppTextField(controller: controller, placeholder: 'Ex.: Ajuste de manga', onChanged: onNomeChanged),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Preço', style: bodyFont(fontSize: 12, weight: FontWeight.w700)),
              Row(
                children: [
                  RoundStepperButton(icon: Icons.remove, onPressed: onDec, size: 32),
                  SizedBox(
                    width: 72,
                    child: Text(brl(preco), textAlign: TextAlign.center, style: headingFont(fontSize: 18)),
                  ),
                  RoundStepperButton(icon: Icons.add, onPressed: onInc, size: 32),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: 'Cancelar',
                  onPressed: onCancel,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  label: 'Adicionar serviço',
                  onPressed: onSalvar,
                  fontSize: 14.5,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
