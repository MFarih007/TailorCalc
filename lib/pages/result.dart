import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:tailor_calc/utils/settings_helper.dart';
import 'package:tailor_calc/database/price_database.dart';
import 'package:tailor_calc/models/pricinghistoryrecord.dart';
import 'package:tailor_calc/models/template.dart';
import 'package:tailor_calc/pages/pdf_viewer.dart';

class ResultPage extends StatefulWidget {
	const ResultPage({super.key, required this.result, this.input});

  final Map<String, dynamic> result;
  final Map<String, dynamic>? input;

	@override
	State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final PriceDatabase _database = PriceDatabase();
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _saveCalculation();
  }

  Future<void> _saveCalculation() async {
    if (_isSaved || widget.input == null) return;
    
    try {
      final input = widget.input!;
      final result = widget.result;
      
      // Generate unique history ID
      final historyId = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Get currency from settings
      final currency = SettingsHelper.getCurrency();
      
      // Get profit margin from result or default
      final profitMarginPct = result['profitMarginPct'] ?? SettingsHelper.getDefaultMargin();
      
      // Get detailed data - ALL INPUT DATA IS SAVED
      final materials = input['materials'] ?? [];
      final transports = input['transports'] ?? [];
      final overheads = input['overheads'] ?? [];
      final tailors = input['tailors'] ?? [];
      
      // Calculate totals for computed results
      double materialsTotal = 0.0;
      for (var material in materials) {
        materialsTotal += material.cost * material.length;
      }
      
      double transportTotal = 0.0;
      for (var transport in transports) {
        transportTotal += transport.cost;
      }
      
      double overheadTotal = 0.0;
      for (var overhead in overheads) {
        overheadTotal += overhead.cost * overhead.hours;
      }
      
      double laborTotal = 0.0;
      for (var tailor in tailors) {
        laborTotal += tailor.salaryPerMonth / (tailor.daysPerMonth * tailor.hoursPerDay) * tailor.hoursSpent;
      }
      
      // Create Inputs object with ALL detailed data for database storage
      // This includes all materials, transports, overheads, and tailors
      final inputs = Inputs(
        labors: input['tailors'], // Labor/tailor data
        materials: input['materials'], // Material items
        transports: input['transports'], // Transport details
        overheads: input['overheads'], // Overhead items
        profitMarginPct: profitMarginPct,
      );
      
      // Create Computed object with all totals
      final computed = Computed(
        laborTotal: laborTotal,
        materialsTotal: materialsTotal,
        overheadTotal: overheadTotal,
        transportTotal: transportTotal,
        costTotal: (result['costTotal'] ?? (materialsTotal + laborTotal + overheadTotal + transportTotal)).toDouble(),
        profitAmount: (result['profitAmount'] ?? 0.0).toDouble(),
        sellingPrice: (result['sellingPrice'] ?? 0.0).toDouble(),
      );
      
      // Create complete record with ALL input data
      final record = PricingHistoryRecord(
        historyId: historyId,
        createdAt: DateTime.now(),
        outfitName: input['outfitName'] ?? 'N/A',
        category: input['category'] ?? 'N/A',
        currency: currency,
        inputs: inputs, // Contains ALL detailed input data
        computed: computed,
      );
      
      // Save COMPLETE calculation data to database
      final resultId = await _database.insertRecord(record);
      
      _isSaved = true;
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Calculation with all details saved to history (ID: $resultId)'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving calculation: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  String _formatCurrency(double amount) {
    return SettingsHelper.formatCurrency(amount);
  }

  String _formatQuoteText() {
    final input = widget.input ?? {};
    final result = widget.result;
    
    final outfitName = input['outfitName'] ?? 'N/A';
    final category = input['category'] ?? 'N/A';
    final materialsTotal = result['materialsTotal'] ?? 0.0;
    final laborTotal = result['laborTotal'] ?? 0.0;
    final overheadTotal = result['overheadTotal'] ?? 0.0;
    final transportTotal = result['transportTotal'] ?? 0.0;
    final profitAmount = result['profitAmount'] ?? 0.0;
    final sellingPrice = result['sellingPrice'] ?? 0.0;
    final profitMarginPct = result['profitMarginPct'] ?? SettingsHelper.getDefaultMargin();
    
    final currency = SettingsHelper.getCurrency();
    final preparedBy = SettingsHelper.getPreparedBy();
    final brandName = SettingsHelper.getBrandName();
    final date = DateFormat('dd/MM/yyyy').format(DateTime.now());
    
    String quote = '''
📋 *Tailoring Quote*

*Job Details:*
• Outfit: $outfitName ($category)
• Currency: $currency

*Cost Breakdown:*
• Materials: ${_formatCurrency(materialsTotal)}
• Transport: ${_formatCurrency(transportTotal)}
• Labor: ${_formatCurrency(laborTotal)}
• Overhead: ${_formatCurrency(overheadTotal)}
• Total Cost: ${_formatCurrency(materialsTotal + transportTotal + laborTotal + overheadTotal)}
• Profit (${profitMarginPct.toStringAsFixed(1)}%): ${_formatCurrency(profitAmount)}
• Suggested Selling Price: ${_formatCurrency(sellingPrice)}
• Prepared by: $preparedBy
• Date: $date

---
Generated with $brandName
''';
    
    return quote;
  }

  Future<File> _generatePDF() async {
    final pdf = pw.Document();
    final input = widget.input ?? {};
    final result = widget.result;
    
    final outfitName = input['outfitName'] ?? 'N/A';
    final category = input['category'] ?? 'N/A';
    final materialsTotal = result['materialsTotal'] ?? 0.0;
    final laborTotal = result['laborTotal'] ?? 0.0;
    final overheadTotal = result['overheadTotal'] ?? 0.0;
    final transportTotal = result['transportTotal'] ?? 0.0;
    final profitAmount = result['profitAmount'] ?? 0.0;
    final sellingPrice = result['sellingPrice'] ?? 0.0;
    final profitMarginPct = result['profitMarginPct'] ?? SettingsHelper.getDefaultMargin();
    
    final currency = SettingsHelper.getCurrency();
    final preparedBy = SettingsHelper.getPreparedBy();
    final brandName = SettingsHelper.getBrandName();

    final fontData = await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
    final myFont = pw.Font.ttf(fontData);

    final date = DateFormat('dd/MM/yyyy').format(DateTime.now());
    
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(40),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Tailoring Quote',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold
                  ),
                ),
                pw.SizedBox(height: 30),
                pw.Text(
                  'Job Details',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text('Outfit: $outfitName'),
                pw.Text('Category: $category'),
                pw.Text('Currency: $currency'),
                pw.Text('Date: $date'),
                pw.SizedBox(height: 30),
                pw.Text(
                  'Cost Breakdown',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text('Material Cost: ${_formatCurrency(materialsTotal)}', style: pw.TextStyle(font: myFont)),
                pw.Text('Transport Cost: ${_formatCurrency(transportTotal)}', style: pw.TextStyle(font: myFont)),
                pw.Text('Labor Cost: ${_formatCurrency(laborTotal)}', style: pw.TextStyle(font: myFont)),
                pw.Text('Overhead Cost: ${_formatCurrency(overheadTotal)}', style: pw.TextStyle(font: myFont)),
                pw.Text('Total Cost: ${_formatCurrency(materialsTotal + transportTotal + laborTotal + overheadTotal)}', style: pw.TextStyle(font: myFont)),
                pw.Text('Profit (${profitMarginPct.toStringAsFixed(1)}%): ${_formatCurrency(profitAmount)}', style: pw.TextStyle(font: myFont)),
                pw.SizedBox(height: 30),
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Suggested Selling Price',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    font: myFont
                  ),
                ),
                pw.Text(
                  _formatCurrency(sellingPrice),
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    font: myFont
                  ),
                ),
                if (preparedBy.isNotEmpty) ...[
                  pw.SizedBox(height: 20),
                  pw.Text('Prepared by: $preparedBy'),
                ],
                pw.Spacer(),
                pw.Text(
                  'Generated with $brandName',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/quote_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<void> _shareViaWhatsApp() async {
    try {
      final quoteText = _formatQuoteText();
      await Share.share(
        quoteText,
        subject: 'TailorCalc',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing: $e')),
        );
      }
    }
  }

  Future<void> _shareAsPDF() async {
    try {
      final pdfFile = await _generatePDF();
      await Share.shareXFiles(
        [XFile(pdfFile.path)],
        text: 'Tailoring Quote',
        subject: 'Tailoring Quote',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating PDF: $e')),
        );
      }
    }
  }

  Future<void> _viewPDF() async {
    try {
      final pdfFile = await _generatePDF();
      final fileName = 'tailoring_quote_${DateTime.now().millisecondsSinceEpoch}.pdf';
      
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfViewerPage(
              file: pdfFile,
              fileName: fileName,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating PDF: $e')),
        );
      }
    }
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.message),
                title: Text('Share as WhatsApp Message'),
                onTap: () {
                  Navigator.pop(context);
                  _shareViaWhatsApp();
                },
              ),
              ListTile(
                leading: Icon(Icons.picture_as_pdf),
                title: Text('Share as PDF'),
                onTap: () {
                  Navigator.pop(context);
                  _shareAsPDF();
                },
              ),
              ListTile(
                leading: Icon(Icons.preview),
                title: Text('View PDF'),
                onTap: () {
                  Navigator.pop(context);
                  _viewPDF();
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveTemplate() async {
    if (widget.input == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No calculation data to save')),
      );
      return;
    }

    final input = widget.input!;
    
    // Prompt for template name
    final templateNameController = TextEditingController();
    templateNameController.text = input['outfitName'] ?? 'Template';

    final templateName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Save Template'),
          content: TextField(
            controller: templateNameController,
            decoration: InputDecoration(
              labelText: 'Template Name',
              hintText: 'Enter template name',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (templateNameController.text.trim().isNotEmpty) {
                  Navigator.pop(context, templateNameController.text.trim());
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (templateName == null || templateName.isEmpty) {
      return;
    }

    try {

      final inputs = Inputs(
        labors: input['tailors'], // Labor/tailor data
        materials: input['materials'], // Material items
        transports: input['transports'], // Transport details
        overheads: input['overheads'], // Overhead items
        profitMarginPct: (input['profitMarginPct'] as num?)?.toDouble() ?? SettingsHelper.getDefaultMargin(),
      );
      // Use the new comprehensive template creation method
      final template = Template(
        templateName: templateName,
        outfitName: input['outfitName'] ?? 'N/A',
        category: input['category'] ?? 'N/A',
        currency: input['currency'] ?? 'N/A',
        inputs: inputs,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _database.insertTemplate(template);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Template "$templateName" saved successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving template: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

	@override
	Widget build(BuildContext context) {
	   final materialsTotal = widget.result['materialsTotal'] ?? 0.0;
	   final laborTotal = widget.result['laborTotal'] ?? 0.0;
	   final overheadTotal = widget.result['overheadTotal'] ?? 0.0;
	   final transportTotal = widget.result['transportTotal'] ?? 0.0;
	   final profitAmount = widget.result['profitAmount'] ?? 0.0;
	   final sellingPrice = widget.result['sellingPrice'] ?? 0.0;
	   final profitMarginPct = widget.result['profitMarginPct'] ?? SettingsHelper.getDefaultMargin();
	   
	   // Get detailed data from input
	   final input = widget.input ?? {};
	   final materials = input['materials'] ?? [];
	   final transports = input['transports'] ?? [];
	   final overheads = input['overheads'] ?? [];
	   final tailors = input['tailors'] ?? [];
	   
		return Scaffold(
			appBar: AppBar(
	       backgroundColor: Colors.blue,
	       foregroundColor: Colors.white,
				title: Text('Calculation Result'),
			),
	     body: SafeArea(
	       child: ListView(
	         padding: const EdgeInsets.all(30.0),
	         children: [
	           // Job Details
	           Text(
	             'Job Details',
	             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
	           ),
	           SizedBox(height: 10),
	           Text('Outfit: ${input['outfitName'] ?? 'N/A'}'),
	           Text('Category: ${input['category'] ?? 'N/A'}'),
	           SizedBox(height: 30),

	           // Materials Section
	           if (materials.isNotEmpty) ...[
	             Text(
	               'Materials',
	               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
	             ),
	             SizedBox(height: 10),
	             ...materials.map<Widget>((material) => Padding(
	               padding: const EdgeInsets.symmetric(vertical: 2),
	               child: Row(
	                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
	                 children: [
	                   Text('${material.name} (${material.length.toStringAsFixed(0)} units)'),
	                   Text(_formatCurrency(material.cost * material.length)),
	                 ],
	               ),
	             )),
	             Divider(),
	             Row(
	               mainAxisAlignment: MainAxisAlignment.spaceBetween,
	               children: [
	                 Text('Total Materials:', style: TextStyle(fontWeight: FontWeight.bold)),
	                 Text(_formatCurrency(materialsTotal), style: TextStyle(fontWeight: FontWeight.bold)),
	               ],
	             ),
	             SizedBox(height: 20),
	           ],

	           // Transport Section
	           if (transports.isNotEmpty) ...[
	             Text(
	               'Transport',
	               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
	             ),
	             SizedBox(height: 10),
	             ...transports.map<Widget>((transport) => Padding(
	               padding: const EdgeInsets.symmetric(vertical: 2),
	               child: Row(
	                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
	                 children: [
	                   Text('${transport.location}${transport.notes.isNotEmpty ? ' (${transport.notes})' : ''}'),
	                   Text(_formatCurrency(transport.cost)),
	                 ],
	               ),
	             )),
	             Divider(),
	             Row(
	               mainAxisAlignment: MainAxisAlignment.spaceBetween,
	               children: [
	                 Text('Total Transport:', style: TextStyle(fontWeight: FontWeight.bold)),
	                 Text(_formatCurrency(transportTotal), style: TextStyle(fontWeight: FontWeight.bold)),
	               ],
	             ),
	             SizedBox(height: 20),
	           ],

	           // Overheads Section
	           if (overheads.isNotEmpty) ...[
	             Text(
	               'Overheads',
	               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
	             ),
	             SizedBox(height: 10),
	             ...overheads.map<Widget>((overhead) => Padding(
	               padding: const EdgeInsets.symmetric(vertical: 2),
	               child: Row(
	                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
	                 children: [
	                   Text('${overhead.type} (${overhead.hours.toStringAsFixed(1)} hours)'),
	                   Text(_formatCurrency(overhead.cost * overhead.hours)),
	                 ],
	               ),
	             )),
	             Divider(),
	             Row(
	               mainAxisAlignment: MainAxisAlignment.spaceBetween,
	               children: [
	                 Text('Total Overheads:', style: TextStyle(fontWeight: FontWeight.bold)),
	                 Text(_formatCurrency(overheadTotal), style: TextStyle(fontWeight: FontWeight.bold)),
	               ],
	             ),
	             SizedBox(height: 20),
	           ],

	           // Labor Section
	           if (tailors.isNotEmpty) ...[
	             Text(
	               'Labor',
	               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
	             ),
	             SizedBox(height: 10),
	             ...tailors.map<Widget>((tailor) => Padding(
	               padding: const EdgeInsets.symmetric(vertical: 2),
	               child: Row(
	                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
	                 children: [
	                   Text('${tailor.name} (${tailor.hoursSpent.toStringAsFixed(1)} hours)'),
	                   Text(_formatCurrency(tailor.salaryPerMonth / (tailor.daysPerMonth * tailor.hoursPerDay) * tailor.hoursSpent)),
	                 ],
	               ),
	             )),
	             Divider(),
	             Row(
	               mainAxisAlignment: MainAxisAlignment.spaceBetween,
	               children: [
	                 Text('Total Labor:', style: TextStyle(fontWeight: FontWeight.bold)),
	                 Text(_formatCurrency(laborTotal), style: TextStyle(fontWeight: FontWeight.bold)),
	               ],
	             ),
	             SizedBox(height: 20),
	           ],

	           // Final Totals
	           Divider(thickness: 2),
	           SizedBox(height: 20),
	           Text('Profit (${profitMarginPct.toStringAsFixed(1)}%)'),
	           SizedBox(height: 10),
	           Text(
	             _formatCurrency(profitAmount),
	             style: TextStyle(fontSize: 18),
	           ),
	           SizedBox(height: 20),
	           Text('Suggested Selling Price'),
	           SizedBox(height: 10),
	           Text(
	             _formatCurrency(sellingPrice),
	             style: TextStyle(
	               fontSize: 30,
	               fontWeight: FontWeight.bold,
	             ),
	           ),
	           SizedBox(height: 30),
	           MaterialButton(
	             color: Colors.blue,
	             textColor: Colors.white,
	             onPressed: _saveTemplate,
	             minWidth: 100,
	             height: 50,
	             child: Text('Save as Template'),
	           ),
	           SizedBox(height: 30),
	           MaterialButton(
	             color: Colors.blue,
	             textColor: Colors.white,
	             onPressed: _showShareOptions,
	             minWidth: 100,
	             height: 50,
	             child: Text('Share Quote'),
	           )
	         ],
	       )
	     )
		);
	}
}

