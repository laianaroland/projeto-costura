import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_input.dart';
import '../widgets/buttons.dart';

class CadClienteScreen extends StatefulWidget {
  const CadClienteScreen({super.key});

  @override
  State<CadClienteScreen> createState() => _CadClienteScreenState();
}

class _CadClienteScreenState extends State<CadClienteScreen> {
  late final TextEditingController _nome;
  late final TextEditingController _tel;
  late final TextEditingController _cep;
  late final TextEditingController _num;
  late final TextEditingController _compl;

  @override
  void initState() {
    super.initState();
    final cli = context.read<AppState>().cli;
    _nome = TextEditingController(text: cli.nome);
    _tel = TextEditingController(text: cli.tel);
    _cep = TextEditingController(text: cli.cep);
    _num = TextEditingController(text: cli.num);
    _compl = TextEditingController(text: cli.compl);
  }

  @override
  void dispose() {
    _nome.dispose();
    _tel.dispose();
    _cep.dispose();
    _num.dispose();
    _compl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final cli = state.cli;
    final pedeComplemento = cli.moradia == 'apto' || cli.moradia == 'outro';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RoundIconButton(icon: Icons.chevron_left_rounded, onPressed: state.back),
              const SizedBox(width: 10),
              Text('Seu cadastro', style: headingFont(fontSize: 23)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Precisamos do básico para achar costureiras perto de você e combinar a entrega.',
            style: bodyFont(fontSize: 13.5, color: textMuted(0.6)),
          ),
          const SizedBox(height: 16),
          const FieldLabel('Nome completo'),
          AppTextField(
            controller: _nome,
            placeholder: 'Ana Duarte da Silva',
            onChanged: state.setNome,
          ),
          const SizedBox(height: 12),
          const FieldLabel('Telefone / WhatsApp'),
          AppTextField(
            controller: _tel,
            placeholder: '(16) 99999-0000',
            keyboardType: TextInputType.phone,
            onChanged: (v) {
              state.setTel(v);
              _syncMasked(_tel, state.cli.tel);
            },
          ),
          const SizedBox(height: 12),
          const FieldLabel('CEP'),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _cep,
                  placeholder: '13560-120',
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    state.setCep(v);
                    _syncMasked(_cep, state.cli.cep);
                  },
                ),
              ),
              const SizedBox(width: 8),
              SecondaryButton(
                label: cli.achou ? 'Achou!' : 'Buscar',
                onPressed: state.buscarCepCli,
                fullWidth: false,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              cli.achou
                  ? 'Confirme o número e o complemento.'
                  : 'A rua, o bairro e a cidade vêm sozinhos.',
              style: bodyFont(fontSize: 11.5, color: textMuted(0.52)),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FieldLabel('Rua / Avenida'),
                    DisplayField(
                      value: cli.achou ? 'Rua das Palmeiras' : 'preenchido pelo CEP',
                      filled: cli.achou,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FieldLabel('Número'),
                    AppTextField(
                      controller: _num,
                      placeholder: '240',
                      keyboardType: TextInputType.number,
                      onChanged: state.setNum,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FieldLabel('Bairro'),
                    DisplayField(value: cli.achou ? 'Centro' : '—', filled: cli.achou),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FieldLabel('Cidade'),
                    DisplayField(value: cli.achou ? 'São Carlos/SP' : '—', filled: cli.achou),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('Tipo de moradia', style: bodyFont(fontSize: 12, weight: FontWeight.w700)),
          const SizedBox(height: 7),
          Row(
            children: [
              _MoradiaChip(
                label: 'Casa',
                selected: cli.moradia == 'casa',
                onTap: () => state.setMoradia('casa'),
              ),
              const SizedBox(width: 8),
              _MoradiaChip(
                label: 'Apartamento',
                selected: cli.moradia == 'apto',
                onTap: () => state.setMoradia('apto'),
              ),
              const SizedBox(width: 8),
              _MoradiaChip(
                label: 'Outro',
                selected: cli.moradia == 'outro',
                onTap: () => state.setMoradia('outro'),
              ),
            ],
          ),
          if (pedeComplemento) ...[
            const SizedBox(height: 12),
            FieldLabel(cli.moradia == 'apto' ? 'Bloco e apartamento' : 'Complemento'),
            AppTextField(
              controller: _compl,
              placeholder: cli.moradia == 'apto'
                  ? 'Bloco B, apto 32'
                  : 'Sala, fundos, ponto de referência',
              onChanged: state.setCompl,
            ),
          ],
          const SizedBox(height: 6),
          PrimaryButton(label: 'Salvar cadastro', onPressed: state.salvarCadastro),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'Seu endereço completo só aparece para a costureira depois que você confirmar um pedido.',
              textAlign: TextAlign.center,
              style: bodyFont(fontSize: 11.5, color: textMuted(0.5)),
            ),
          ),
        ],
      ),
    );
  }

  void _syncMasked(TextEditingController c, String masked) {
    if (c.text != masked) {
      c.value = c.value.copyWith(
        text: masked,
        selection: TextSelection.collapsed(offset: masked.length),
      );
    }
  }
}

class _MoradiaChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _MoradiaChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: selected ? AppColors.accent500 : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(color: selected ? AppColors.accent500 : Colors.transparent, width: 2),
            ),
            child: Text(
              label,
              style: bodyFont(
                fontSize: 13.5,
                weight: FontWeight.w700,
                color: selected ? AppColors.bg : AppColors.text,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
