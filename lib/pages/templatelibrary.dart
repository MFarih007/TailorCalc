import 'package:flutter/material.dart';
import 'package:tailor_calc/database/price_database.dart';
import 'package:tailor_calc/models/template.dart';
import 'package:tailor_calc/pages/newcalc.dart';
import 'package:intl/intl.dart';

class TemplateLibraryPage extends StatefulWidget {
	const TemplateLibraryPage({super.key});

	@override
	State<TemplateLibraryPage> createState() => _TemplateLibraryPageState();
}

class _TemplateLibraryPageState extends State<TemplateLibraryPage> {
  final PriceDatabase _database = PriceDatabase();
  List<Template> _templates = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final templates = await _database.getAllTemplates();
      setState(() {
        _templates = templates;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading templates: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteTemplate(Template template) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Template'),
          content: Text('Are you sure you want to delete "${template.templateName}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true && template.id != null) {
      try {
        await _database.deleteTemplate(template.id!);
        _loadTemplates();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Template deleted'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting template: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _useTemplate(Template template) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewCalcPage(
          initialInput: template.toInputMap(),
        ),
      ),
    );
  }

  void _showTemplateDetails(Template template) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(template.templateName),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Outfit Name', template.outfitName),
                _buildDetailRow('Category', template.category),
                SizedBox(height: 10),
                // Show comprehensive data if available
                ...[
                  Text('Materials:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...template.inputs.materials.map((material) =>
                    _buildDetailRow(material.name, '${material.length.toStringAsFixed(0)} units @ ${material.cost.toStringAsFixed(2)}')
                  ).toList(),
                  SizedBox(height: 10),
                ],
                ...[
                  Text('Transport:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...template.inputs.transports.map((transport) =>
                    _buildDetailRow(transport.location, '${transport.cost.toStringAsFixed(2)} ${transport.notes.isNotEmpty ? "(${transport.notes})" : ""}')
                  ).toList(),
                  SizedBox(height: 10),
                ],
                ...[
                  Text('Overheads:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...template.inputs.overheads.map((overhead) =>
                    _buildDetailRow(overhead.type, '${overhead.hours.toStringAsFixed(1)} hrs @ ${overhead.cost.toStringAsFixed(2)}/hr')
                  ).toList(),
                  SizedBox(height: 10),
                ],
                ...[
                  Text('Labor:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...template.inputs.labors.map((tailor) =>
                    _buildDetailRow(tailor.name, '${tailor.hoursSpent.toStringAsFixed(1)} hrs @ ${(tailor.salaryPerMonth / (tailor.daysPerMonth * tailor.hoursPerDay)).toStringAsFixed(2)}/hr')
                  ).toList(),
                  SizedBox(height: 10),
                ],
                _buildDetailRow('Profit Margin', '${template.inputs.profitMarginPct.toStringAsFixed(1)}%'),
                SizedBox(height: 10),
                Text(
                  'Updated: ${DateFormat('dd/MM/yyyy HH:mm').format(template.updatedAt)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _useTemplate(template);
              },
              child: Text('Use Template'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }

  void _createNewTemplate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NewCalcPage(),
      ),
    );
    // After returning from creation flow, refresh the list
    if (mounted) {
      _loadTemplates();
    }
  }

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
				title: Text('Saved Templates'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadTemplates,
            tooltip: 'Refresh',
          ),
        ],
			),
      body: SafeArea(
        child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _templates.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.description, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No templates saved',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Save a template from a calculation result',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: _loadTemplates,
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _templates.length,
                  itemBuilder: (context, index) {
                    final template = _templates[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.description, color: Colors.white),
                        ),
                        title: Text(
                          template.templateName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text('${template.outfitName} - ${template.category}'),
                            SizedBox(height: 2),
                            // Show data type indicator
                            Text(
                              template.inputs.materials.isNotEmpty || template.inputs.transports.isNotEmpty ||
                              template.inputs.overheads.isNotEmpty || template.inputs.labors.isNotEmpty
                                  ? 'Comprehensive Template' : 'Legacy Template',
                              style: TextStyle(
                                fontSize: 11,
                                color: template.inputs.materials.isNotEmpty || template.inputs.transports.isNotEmpty ||
                                       template.inputs.overheads.isNotEmpty || template.inputs.labors.isNotEmpty
                                    ? Colors.green[600] : Colors.orange[600]
                              ),
                            ),
                            Text(
                              'Updated: ${DateFormat('dd/MM/yyyy').format(template.updatedAt)}',
                              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline, size: 20),
                                  SizedBox(width: 8),
                                  Text('Details'),
                                ],
                              ),
                              onTap: () {
                                Future.delayed(Duration.zero, () {
                                  _showTemplateDetails(template);
                                });
                              },
                            ),
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  Icon(Icons.delete, size: 20, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Delete', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                              onTap: () {
                                Future.delayed(Duration.zero, () {
                                  _deleteTemplate(template);
                                });
                              },
                            ),
                          ],
                        ),
                        onTap: () => _useTemplate(template),
                      ),
                    );
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewTemplate,
        icon: const Icon(Icons.add),
        label: const Text('New Template'),
      ),
		);
	}
}
