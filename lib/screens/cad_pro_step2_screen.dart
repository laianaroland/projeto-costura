import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../state/formatters.dart';
import '../theme/app_theme.dart';
import '../widgets/app_input.dart';
import '../widgets/buttons.dart';

class CadProStep2Screen extends StatelessWidget {
  const CadProStep2Screen({super.key});

  static const _dias = [
    ('seg', 'S'),
    ('ter', 'T'),
    ('qua', 'Q'),
    ('qui', 'Q'),
    ('sex', 'S'),
    ('sab', 'S'),
    ('dom', 'D'),
  ];

  static const _campos = [
    ('Rua / Avenida', 'Rua das Acácias'),
    ('Número', '87'),
    ('Bairro', 'Vila Nova'),
    ('Cidade', 'São Carlos · SP'),
  ];

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
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.accent500,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('2 de 2', style: bodyFont(fontSize: 12, weight: FontWeight.w700, color: textMuted(0.55))),
            ],
          ),
          const SizedBox(height: 14),
          Text('Onde você atende?', style: headingFont(fontSize: 25)),
          const SizedBox(height: 4),
          Text(
            'Só o bairro aparece para os clientes. O número fica com você.',
            style: bodyFont(fontSize: 13.5, color: textMuted(0.6)),
          ),
          const SizedBox(height: 16),
          const FieldLabel('CEP'),
          Row(
            children: [
              Expanded(child: DisplayField(value: state.cep, filled: true)),
              const SizedBox(width: 8),
              SecondaryButton(
                label: state.cepCta,
                onPressed: state.buscarCep,
                fullWidth: false,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
              ),
            ],
          ),
          const SizedBox(height: 11),
          for (final campo in _campos) ...[
            FieldLabel(campo.$1),
            DisplayField(value: state.cepBuscado ? campo.$2 : 'preencher', filled: state.cepBuscado),
            const SizedBox(height: 11),
          ],
          const SizedBox(height: 6),
          Text('Dias que você atende', style: headingFont(fontSize: 16, weight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(
            'Toque nos dias em que aceita entrega e retirada.',
            style: bodyFont(fontSize: 12.5, color: textMuted(0.58)),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (final dia in _dias) ...[
                Expanded(child: _DiaButton(
                  label: dia.$2,
                  on: state.diasAtende.contains(dia.$1),
                  onTap: () => state.toggleDia(dia.$1),
                )),
                if (dia != _dias.last) const SizedBox(width: 6),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Text('Horário de atendimento', style: headingFont(fontSize: 16, weight: FontWeight.w600)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _HourBox(
                  label: 'ABRE',
                  value: hFmt(state.abre),
                  onDec: state.abreDec,
                  onInc: state.abreInc,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HourBox(
                  label: 'FECHA',
                  value: hFmt(state.fecha),
                  onDec: state.fechaDec,
                  onInc: state.fechaInc,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Material(
            color: state.almoco ? AppColors.accent100 : AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.md),
              onTap: state.toggleAlmoco,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: state.almoco ? AppColors.accent400 : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: state.almoco ? AppColors.accent600 : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: state.almoco ? AppColors.accent600 : AppColors.neutral400,
                          width: 2,
                        ),
                      ),
                      child: state.almoco ? const Icon(Icons.check, size: 15, color: AppColors.bg) : null,
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Text(
                        'Fecho para o almoço (12h–13h)',
                        style: bodyFont(fontSize: 14, weight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              state.resumoHorarioTexto,
              style: bodyFont(fontSize: 12.5, weight: FontWeight.w700, color: AppColors.accent700),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: AppColors.accent2_200,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(color: AppColors.accent2_500, shape: BoxShape.circle),
                  child: const Icon(Icons.location_on_outlined, size: 18, color: AppColors.bg),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Você vai aparecer para quem estiver a até 10 km.',
                    style: bodyFont(fontSize: 13, color: AppColors.accent2_800),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          PrimaryButton(label: 'Publicar meu perfil', onPressed: state.finishCad),
        ],
      ),
    );
  }
}

class _DiaButton extends StatelessWidget {
  final String label;
  final bool on;
  final VoidCallback onTap;
  const _DiaButton({required this.label, required this.on, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Material(
        color: on ? AppColors.accent500 : AppColors.surface,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Center(
            child: Text(
              label,
              style: bodyFont(
                fontSize: 13,
                weight: FontWeight.w700,
                color: on ? AppColors.bg : textMuted(0.55),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HourBox extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onDec;
  final VoidCallback onInc;

  const _HourBox({required this.label, required this.value, required this.onDec, required this.onInc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: bodyFont(fontSize: 11.5, weight: FontWeight.w700, color: textMuted(0.55)),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RoundStepperButton(icon: Icons.remove, onPressed: onDec),
              Text(value, style: headingFont(fontSize: 19)),
              RoundStepperButton(icon: Icons.add, onPressed: onInc),
            ],
          ),
        ],
      ),
    );
  }
}
