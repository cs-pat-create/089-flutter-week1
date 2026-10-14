import 'package:flutter/material.dart';

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'แอปคำนวณ BMI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const BMIScreen(),
    );
  }
}

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  // Controller สำหรับดึงข้อมูลจากช่องกรอก
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  double? _bmi;
  String _resultText = '';
  Color _resultColor = Colors.black;

  // ฟังก์ชันคำนวณและแปลผล BMI
  void _calculateBMI() {
    final String weightText = _weightController.text.trim();
    final String heightText = _heightController.text.trim();

    // 1. ตรวจสอบการกรอกข้อมูลว่าง
    if (weightText.isEmpty || heightText.isEmpty) {
      _showAlertDialog('กรุณากรอกข้อมูล', 'โปรดระบุทั้งน้ำหนักและส่วนสูงก่อนกดคำนวณ');
      return;
    }

    final double? weight = double.tryParse(weightText);
    final double? height = double.tryParse(heightText);

    // ตรวจสอบความถูกต้องของตัวเลข
    if (weight == null || height == null || weight <= 0 || height <= 0) {
      _showAlertDialog('ข้อมูลไม่ถูกต้อง', 'กรุณากรอกตัวเลขที่มากกว่า 0');
      return;
    }

    // 2. คำนวณค่า BMI (สูตร: น้ำหนัก (กก.) / (ส่วนสูง (เมตร) ^ 2))
    final double heightInMeters = height / 100;
    final double bmiValue = weight / (heightInMeters * heightInMeters);

    String text = '';
    Color color = Colors.black;

    // 3. แปลผลตามเกณฑ์คนไทย (Asia-Pacific Guidelines / กระทรวงสาธารณสุข)
    if (bmiValue < 18.5) {
      text = 'น้ำหนักน้อย / ผอม';
      color = Colors.blue;
    } else if (bmiValue <= 22.9) {
      text = 'น้ำหนักปกติ / สมส่วน';
      color = Colors.green;
    } else if (bmiValue <= 24.9) {
      text = 'น้ำหนักเกิน / ท้วม';
      color = Colors.orange;
    } else if (bmiValue <= 29.9) {
      text = 'อ้วน / อ้วนระดับ 1';
      color = Colors.deepOrange;
    } else {
      text = 'อ้วนมาก / อ้วนระดับ 2';
      color = Colors.red;
    }

    // อัปเดตหน้าจอด้วย setState
    setState(() {
      _bmi = bmiValue;
      _resultText = text;
      _resultColor = color;
    });
  }

  // ป๊อปอัปแจ้งเตือนเมื่อกรอกข้อมูลไม่ครบถ้วน
  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('ตกลง'),
          ),
        ],
      ),
    );
  }

  // ล้างข้อมูลเพื่อเริ่มใหม่
  void _resetFields() {
    setState(() {
      _weightController.clear();
      _heightController.clear();
      _bmi = null;
      _resultText = '';
      _resultColor = Colors.black;
    });
  }

  @override
  void dispose() {
    // คืนหน่วยความจำของ Controller เมื่อไม่ใช้งาน
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('คำนวณดัชนีมวลกาย (BMI)'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.monitor_weight_outlined,
              size: 80,
              color: Colors.teal,
            ),
            const SizedBox(height: 20),
            
            // ช่องกรอกน้ำหนัก
            TextField(
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'น้ำหนัก (กิโลกรัม)',
                hintText: 'เช่น 65.5',
                prefixIcon: Icon(Icons.scale),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // ช่องกรอกส่วนสูง
            TextField(
              controller: _heightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'ส่วนสูง (เซนติเมตร)',
                hintText: 'เช่น 170',
                prefixIcon: Icon(Icons.height),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            
            // ปุ่มดำเนินการ
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _calculateBMI,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('คำนวณ BMI', style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: _resetFields,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  ),
                  child: const Text('ล้างข้อมูล'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            
            // แสดงผลลัพธ์การคำนวณ
            if (_bmi != null)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'ค่า BMI ของคุณคือ',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _bmi!.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: _resultColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _resultText,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: _resultColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}