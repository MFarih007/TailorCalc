import 'package:flutter/material.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerPage extends StatefulWidget {
  const PdfViewerPage({
    super.key,
    required this.file,
    required this.fileName,
  });

  final File file;
  final String fileName;

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? _errorMessage;
  bool _isFileValid = false;
  final PdfViewerController _pdfViewerController = PdfViewerController();
  int _currentPage = 1;
  int _totalPages = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _validateFile();
  }

  Future<void> _validateFile() async {
    try {
      if (await widget.file.exists()) {
        if (widget.file.lengthSync() > 0) {
          setState(() {
            _isFileValid = true;
            _errorMessage = null;
          });
        } else {
          setState(() {
            _errorMessage = 'PDF file is empty';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'PDF file not found';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error accessing PDF file: $e';
      });
    }
  }

  Future<void> _sharePDF() async {
    try {
      await Share.shareXFiles(
        [XFile(widget.file.path)],
        text: 'Tailoring Quote PDF',
        subject: widget.fileName,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _goToPage(int page) {
    if (page >= 1 && page <= _totalPages) {
      _pdfViewerController.jumpToPage(page);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.fileName,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          if (_isFileValid && _totalPages > 1) ...[
            IconButton(
              icon: const Icon(Icons.first_page),
              onPressed: _currentPage > 1 ? () => _goToPage(1) : null,
              tooltip: 'First Page',
            ),
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: _currentPage > 1 ? () => _goToPage(_currentPage - 1) : null,
              tooltip: 'Previous Page',
            ),
            Text(
              '$_currentPage/$_totalPages',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: _currentPage < _totalPages ? () => _goToPage(_currentPage + 1) : null,
              tooltip: 'Next Page',
            ),
            IconButton(
              icon: const Icon(Icons.last_page),
              onPressed: _currentPage < _totalPages ? () => _goToPage(_totalPages) : null,
              tooltip: 'Last Page',
            ),
          ],
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _sharePDF,
            tooltip: 'Share PDF',
          ),
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: _showFileInfo,
            tooltip: 'File Info',
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_isFileValid) ...[
            FloatingActionButton(
              heroTag: "zoom_in",
              backgroundColor: Colors.green,
              mini: true,
              tooltip: 'Zoom In',
              onPressed: () => _pdfViewerController.zoomLevel += 0.5,
              child: const Icon(Icons.zoom_in, color: Colors.white),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: "zoom_out",
              backgroundColor: Colors.orange,
              mini: true,
              tooltip: 'Zoom Out',
              onPressed: () => _pdfViewerController.zoomLevel -= 0.5,
              child: const Icon(Icons.zoom_out, color: Colors.white),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: "page_up",
              backgroundColor: Colors.purple,
              mini: true,
              tooltip: 'Previous Page',
              onPressed: _currentPage > 1 ? () => _goToPage(_currentPage - 1) : null,
              child: const Icon(Icons.arrow_upward, color: Colors.white),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: "page_down",
              backgroundColor: Colors.indigo,
              mini: true,
              tooltip: 'Next Page',
              onPressed: _currentPage < _totalPages ? () => _goToPage(_currentPage + 1) : null,
              child: const Icon(Icons.arrow_downward, color: Colors.white),
            ),
            const SizedBox(height: 8),
          ],
          FloatingActionButton(
            heroTag: "share_pdf",
            backgroundColor: Colors.blue,
            tooltip: 'Share PDF',
            onPressed: _isFileValid ? _sharePDF : null,
            child: const Icon(Icons.share, color: Colors.white),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "close_viewer",
            backgroundColor: Colors.grey,
            tooltip: 'Close Viewer',
            onPressed: () => Navigator.pop(context),
            child: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (!_isFileValid) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // PDF Preview with actual rendering
    return Stack(
      children: [
        SfPdfViewer.file(
          widget.file,
          controller: _pdfViewerController,
          onDocumentLoaded: (PdfDocumentLoadedDetails details) {
            setState(() {
              _totalPages = details.document.pages.count;
              _isLoading = false;
            });
          },
          onPageChanged: (PdfPageChangedDetails details) {
            setState(() {
              _currentPage = details.newPageNumber;
            });
          },
          canShowScrollHead: true,
          canShowScrollStatus: true,
          enableDoubleTapZooming: true,
          enableTextSelection: true,
        ),
        if (_isLoading)
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Loading PDF...'),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            const Text(
              'Error Loading PDF',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _errorMessage!,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Go Back'),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: _validateFile,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFileInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('PDF File Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('File Name', widget.fileName),
              _buildDetailRow('File Size', _formatFileSize(widget.file.lengthSync())),
              _buildDetailRow('Total Pages', _totalPages > 0 ? _totalPages.toString() : 'Loading...'),
              _buildDetailRow('Current Page', _totalPages > 0 ? _currentPage.toString() : 'N/A'),
              _buildDetailRow('Absolute Path', widget.file.absolute.path),
              _buildDetailRow('Created', _formatDateTime(widget.file.lastModifiedSync())),
              const SizedBox(height: 10),
              const Text(
                'Note: This PDF file is temporary and will be deleted when the app is closed.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes bytes';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/'
           '${dateTime.month.toString().padLeft(2, '0')}/'
           '${dateTime.year} '
           '${dateTime.hour.toString().padLeft(2, '0')}:'
           '${dateTime.minute.toString().padLeft(2, '0')}';
  }
}