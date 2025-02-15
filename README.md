
# **File Organizer**

**File Organizer** is a command-line tool designed to automatically sort files by their type and organize them into structured directories. This tool helps users manage their files efficiently, making it easier to declutter and locate specific files.

---

## **How It Works**

The File Organizer scans a specified directory, identifies files based on their extensions, and categorizes them into corresponding folders (e.g., `PDF`, `JPG`, `DOC`). It ensures that your workspace remains clean and organized.  

### **Key Workflow**:
1. **Scan**: Detects all files in the chosen directory.
2. **Categorize**: Identifies file types using extensions (e.g., `.pdf`, `.jpg`) and groups them.
3. **Organize**: Moves files into folders named after their types.

---

## **Why Use File Organizer?**

### **Automation**  
Eliminates manual effort by automatically organizing files into well-defined folders.  

### **Customizability**  
Provides options to include or exclude specific file types to suit your preferences.  

### **Backup Security**  
Creates a timestamped backup before organizing files, ensuring your data is safe from accidental changes.  

---

## **Technologies Used**

- **Dart SDK**: Core programming language used for development.
- **Logging Package**: Captures logs for events and errors during file organization.
- **Path Package**: Simplifies file path handling and extension management.
- **Colorize Package**: Enhances the user interface with colorful console outputs for better readability.

---

## **Features**

### **1. Automatic File Organization**  
Sorts files into categorized folders (e.g., `Documents`, `Images`, `Videos`).  

### **2. Preview Before Organizing**  
Displays a preview of the changes to be made, so users can review before executing.  

### **3. File Type Filtering**  
Organize only specific file types by specifying extensions like `pdf`, `jpg`, `doc`.  

### **4. Bulk File Renaming**  
Rename multiple files at once by:  
- Adding prefixes or suffixes.  
- Replacing parts of filenames.  

### **5. Backup System**  
Creates a backup folder with a timestamp to ensure no data is lost during the process.  

### **6. User-Friendly Guide**  
Provides detailed usage instructions directly within the tool.  

---

## **Getting Started**

Follow these steps to set up and use the File Organizer:

### **Prerequisites**  
- Install **Dart SDK**.  
- Ensure your system meets Dart's requirements.  

---

### **Installation**

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/file-organizer.git
   ```
2. **Navigate to the project directory**:
   ```bash
   cd file-organizer
   ```
3. **Install dependencies**:
   ```bash
   dart pub get
   ```

---

### **Usage**

1. **Run the tool**:
   ```bash
   dart run lib/main.dart
   ```

2. **Optional Arguments**:
   - `--path`: Specify the directory to organize (default is the current directory).  
   - `--types`: Define file types to organize (e.g., `pdf,jpg,doc`).  
   - `--backup`: Enable/disable backup creation (default is enabled).  

---

## **Contributing**

We welcome contributions to improve this project!  

### **Steps to Contribute**:
1. **Create a new branch**:
   ```bash
   git checkout -b feature-name
   ```
2. **Make your changes**.
3. **Commit and push**:
   ```bash
   git commit -m "Description of changes"
   git push origin feature-name
   ```
4. **Submit a pull request**:  
   Go to the GitHub repository and create a pull request.  
