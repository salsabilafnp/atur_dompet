import 'dart:typed_data';

import 'package:atur_dompet/config/utils/dictionary.dart';
import 'package:atur_dompet/config/utils/enum.dart';
import 'package:atur_dompet/core/models/transaction.dart';
import 'package:atur_dompet/core/services/report_file_saver.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportExportService {
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _fileDateFormat = DateFormat('yyyyMMdd');
  static final NumberFormat _numberFormat = NumberFormat.decimalPattern(
    'id_ID',
  );

  Future<void> sharePdf(
    List<Transaction> transactions, {
    required DateTime startDate,
    required DateTime endDate,
    required Set<String> savingsWalletIds,
  }) async {
    final reportTransactions = filterByDateRange(
      transactions,
      startDate: startDate,
      endDate: endDate,
    );
    final document = pw.Document();
    final totals = _calculateTotals(reportTransactions, savingsWalletIds);

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) => [
          pw.Text(
            Dictionary.reportTitle,
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            '${Dictionary.periode}: ${_dateFormat.format(startDate)} - ${_dateFormat.format(endDate)}',
          ),
          pw.SizedBox(height: 12),
          pw.Text(
            '${Dictionary.totalIncome}: Rp ${_numberFormat.format(totals.income)}    '
            '${Dictionary.totalExpense}: Rp ${_numberFormat.format(totals.expense)}    '
            '${Dictionary.totalSavings}: Rp ${_numberFormat.format(totals.savings)}    '
            '${Dictionary.totalBalance}: Rp ${_numberFormat.format(totals.income - totals.expense)}',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 14),
          if (reportTransactions.isEmpty)
            pw.Center(child: pw.Text(Dictionary.noTransactions))
          else
            pw.TableHelper.fromTextArray(
              headers: const [
                Dictionary.trxDate,
                Dictionary.transactionType,
                Dictionary.title,
                Dictionary.category,
                Dictionary.notes,
                Dictionary.amount,
              ],
              data: reportTransactions.map((transaction) {
                return [
                  _dateFormat.format(transaction.transactionDate),
                  _typeLabel(transaction.type),
                  transaction.title,
                  transaction.categoryName ?? '-',
                  transaction.note ?? '-',
                  _numberFormat.format(transaction.amount),
                ];
              }).toList(),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.blueGrey800,
              ),
              cellStyle: const pw.TextStyle(fontSize: 8),
              cellPadding: const pw.EdgeInsets.all(5),
              border: pw.TableBorder.all(color: PdfColors.grey400),
            ),
        ],
      ),
    );

    final fileName = _fileName('pdf', startDate, endDate);
    await saveReportFile(
      await document.save(),
      fileName: fileName,
      mimeType: 'application/pdf',
    );
  }

  Future<void> shareExcel(
    List<Transaction> transactions, {
    required DateTime startDate,
    required DateTime endDate,
    required Set<String> savingsWalletIds,
  }) async {
    final reportTransactions = filterByDateRange(
      transactions,
      startDate: startDate,
      endDate: endDate,
    );
    final workbook = Excel.createExcel();
    workbook.rename('Sheet1', 'Laporan');
    final sheet = workbook['Laporan'];
    final totals = _calculateTotals(reportTransactions, savingsWalletIds);

    sheet.appendRow([TextCellValue(Dictionary.reportTitle)]);
    sheet.appendRow([
      TextCellValue(
        'Periode: ${_dateFormat.format(startDate)} - ${_dateFormat.format(endDate)}',
      ),
    ]);
    sheet.appendRow([
      TextCellValue(Dictionary.totalIncome),
      DoubleCellValue(totals.income),
      TextCellValue(Dictionary.totalExpense),
      DoubleCellValue(totals.expense),
      TextCellValue(Dictionary.totalSavings),
      DoubleCellValue(totals.savings),
      TextCellValue(Dictionary.totalBalance),
      DoubleCellValue(totals.income - totals.expense),
    ]);
    sheet.appendRow([
      TextCellValue('Tanggal'),
      TextCellValue('Jenis'),
      TextCellValue('Judul'),
      TextCellValue('Kategori'),
      TextCellValue('Catatan'),
      TextCellValue('Nominal (Rp)'),
    ]);

    for (final transaction in reportTransactions) {
      sheet.appendRow([
        TextCellValue(_dateFormat.format(transaction.transactionDate)),
        TextCellValue(_typeLabel(transaction.type)),
        TextCellValue(transaction.title),
        TextCellValue(transaction.categoryName ?? '-'),
        TextCellValue(transaction.note ?? '-'),
        DoubleCellValue(transaction.amount),
      ]);
    }

    final bytes = workbook.encode();
    if (bytes == null) {
      throw StateError('Gagal membuat file Excel.');
    }

    final fileName = _fileName('xlsx', startDate, endDate);
    await saveReportFile(
      Uint8List.fromList(bytes),
      fileName: fileName,
      mimeType:
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    );
  }

  List<Transaction> filterByDateRange(
    List<Transaction> transactions, {
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final endExclusive = DateTime(endDate.year, endDate.month, endDate.day + 1);

    return transactions.where((transaction) {
      return !transaction.transactionDate.isBefore(start) &&
          transaction.transactionDate.isBefore(endExclusive);
    }).toList()..sort(
      (first, second) =>
          first.transactionDate.compareTo(second.transactionDate),
    );
  }

  _ReportTotals _calculateTotals(
    List<Transaction> transactions,
    Set<String> savingsWalletIds,
  ) {
    var income = 0.0;
    var expense = 0.0;
    var savings = 0.0;

    for (final transaction in transactions) {
      if (transaction.type == TransactionType.income) {
        income += transaction.amount;
        if (savingsWalletIds.contains(transaction.walletId)) {
          savings += transaction.amount;
        }
      } else if (transaction.type == TransactionType.expense) {
        expense += transaction.amount;
        if (savingsWalletIds.contains(transaction.walletId)) {
          savings -= transaction.amount;
        }
      } else if (transaction.type == TransactionType.transfer) {
        if (savingsWalletIds.contains(transaction.destinationWalletId)) {
          savings += transaction.amount;
        }
        if (savingsWalletIds.contains(transaction.walletId)) {
          savings -= transaction.amount;
        }
      }
    }

    return _ReportTotals(income: income, expense: expense, savings: savings);
  }

  String _typeLabel(String type) {
    switch (type) {
      case TransactionType.income:
        return 'Pemasukan';
      case TransactionType.expense:
        return 'Pengeluaran';
      case TransactionType.transfer:
        return 'Transfer';
      case TransactionType.debt:
        return 'Utang';
      case TransactionType.loan:
        return 'Piutang';
      default:
        return type;
    }
  }

  String _fileName(String extension, DateTime startDate, DateTime endDate) {
    return 'laporan_${_fileDateFormat.format(startDate)}_'
        '${_fileDateFormat.format(endDate)}.$extension';
  }
}

class _ReportTotals {
  final double income;
  final double expense;
  final double savings;

  const _ReportTotals({
    required this.income,
    required this.expense,
    required this.savings,
  });
}
