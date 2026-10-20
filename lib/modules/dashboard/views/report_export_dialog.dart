import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:atur_dompet/core/components/custom_notification.dart';
import 'package:atur_dompet/core/models/transaction.dart';
import 'package:atur_dompet/core/services/report_export_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportExportDialog extends StatefulWidget {
  final List<Transaction> transactions;
  final Set<String> savingsWalletIds;

  const ReportExportDialog({
    super.key,
    required this.transactions,
    required this.savingsWalletIds,
  });

  @override
  State<ReportExportDialog> createState() => _ReportExportDialogState();
}

class _ReportExportDialogState extends State<ReportExportDialog> {
  final ReportExportService _exportService = ReportExportService();
  final DateFormat _monthFormat = DateFormat('MMMM yyyy', 'id_ID');
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTimeRange? _customRange;
  bool _useCustomRange = false;
  bool _isExporting = false;

  DateTime get _startDate => _useCustomRange && _customRange != null
      ? _customRange!.start
      : DateTime(_selectedMonth.year, _selectedMonth.month);

  DateTime get _endDate => _useCustomRange && _customRange != null
      ? _customRange!.end
      : DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);

  Future<void> _selectMonth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: Dictionary.chooseMonth,
    );
    if (picked != null && mounted) {
      setState(() => _selectedMonth = DateTime(picked.year, picked.month));
    }
  }

  Future<void> _selectRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: _customRange,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: Dictionary.chooseDateRange,
      initialEntryMode: DatePickerEntryMode.calendar,
      currentDate: now,
    );
    if (picked != null && mounted) {
      setState(() => _customRange = picked);
    }
  }

  Future<void> _export({required bool asPdf}) async {
    if (_useCustomRange && _customRange == null) {
      CustomNotification.showError(Dictionary.chooseDateRange);
      return;
    }

    final transactions = _exportService.filterByDateRange(
      widget.transactions,
      startDate: _startDate,
      endDate: _endDate,
    );
    if (transactions.isEmpty) {
      CustomNotification.showError(Dictionary.noTransactionsInRange);
      return;
    }

    setState(() => _isExporting = true);
    try {
      if (asPdf) {
        await _exportService.sharePdf(
          widget.transactions,
          startDate: _startDate,
          endDate: _endDate,
          savingsWalletIds: widget.savingsWalletIds,
        );
      } else {
        await _exportService.shareExcel(
          widget.transactions,
          startDate: _startDate,
          endDate: _endDate,
          savingsWalletIds: widget.savingsWalletIds,
        );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      CustomNotification.showError('${Dictionary.failExportReport}: $error');
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateRangeLabel = _useCustomRange
        ? _customRange == null
              ? Dictionary.selectDateRange
              : '${DateFormat('dd/MM/yyyy').format(_customRange!.start)} - '
                    '${DateFormat('dd/MM/yyyy').format(_customRange!.end)}'
        : _monthFormat.format(_selectedMonth);

    return AlertDialog(
      title: const Text(Dictionary.exportReport),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AbsorbPointer(
            absorbing: _isExporting,
            child: RadioGroup<bool>(
              groupValue: _useCustomRange,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _useCustomRange = value);
                }
              },
              child: Column(
                children: [
                  RadioListTile<bool>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(Dictionary.monthlyReport),
                    value: false,
                  ),
                  RadioListTile<bool>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(Dictionary.customDateRange),
                    value: true,
                  ),
                ],
              ),
            ),
          ),
          OutlinedButton.icon(
            onPressed: _isExporting
                ? null
                : _useCustomRange
                ? _selectRange
                : _selectMonth,
            icon: const Icon(Icons.calendar_month_outlined),
            label: Text(dateRangeLabel),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isExporting ? null : () => Navigator.of(context).pop(),
          child: const Text(Dictionary.cancelBtn),
        ),
        OutlinedButton.icon(
          onPressed: _isExporting ? null : () => _export(asPdf: true),
          icon: const Icon(Icons.picture_as_pdf_outlined),
          label: const Text('PDF'),
        ),
        FilledButton.icon(
          onPressed: _isExporting ? null : () => _export(asPdf: false),
          icon: _isExporting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.table_chart_outlined),
          label: const Text('Excel'),
        ),
      ],
    );
  }
}
