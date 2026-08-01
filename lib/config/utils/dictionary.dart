class Dictionary {
  static const String appTitle = 'AturDompet';
  static const String appDescription =
      'An app to help you manage your finances as a personal financial tracker and management simple tool.';

  /// Splash Screen
  static const String splashTitle =
      'Manage your finances easily and effectively';

  /// Auth
  static const String login = 'Login';
  static const String register = 'Register';
  static const String logout = 'Logout';
  static const String nickname = 'Nickname';
  static const String email = 'Email';
  static const String role = 'User Role';
  static const String password = 'Password';
  static const String newPassword = 'New Password';
  static const String confirmPassword = 'Confirm Password';
  static const String formIsRequired = 'Form is required';
  static const String passwordNotMatch = 'Passwords do not match';
  static const String forgotPassword = 'Forgot Password';
  static const String resetPassword = 'Reset Password';
  static const String deleteAccount = 'Delete Account';

  /// Menu
  static const String home = 'Home';
  static const String profile = 'Profile';
  static const String transactions = 'Transactions';
  static const String category = 'Manage Categories';
  static const String wallets = 'Wallets';
  static const String debts = 'Debts & Loans';
  static const String debtLogs = 'Debt Logs';
  static const String accountSecurity = 'Account Security';
  static const String setReminderBtn = 'Set Reminder';
  static const String aboutBtn = 'About App';

  /// Home
  static const String summary = 'Summary';
  static const String totalBalance = 'Total Balance';
  static const String totalMain = 'Total Main Wallet';
  static const String totalSavings = 'Total Savings';
  static const String expenseChart = 'Expenses by Category';
  static const String savingsChart = 'Savings by Category';
  static const String summaryPDF = 'Export Summary (PDF)';
  // Filter
  static const String today = 'Today';
  static const String sevenDays = '7 Days';
  static const String thisMonth = 'This Month';
  static const String allTime = 'All Time';
  static const String customDate = 'Custom Date';

  /// Transaction
  static const String selectColor = 'Select Color';
  // Options
  static const String all = 'All';
  static const String income = 'Income';
  static const String expense = 'Expense';
  static const String incomeCategory = 'Income Categories';
  static const String expenseCategory = 'Expense Categories';
  static const String main = 'Main';
  static const String savings = 'Savings';
  static const String transfer = 'Transfer';
  static const String debt = 'Debt';
  static const String borrow = 'Borrow';
  static const String loan = 'Loan';
  static const String lend = 'Lend';
  static const String repayment = 'Repayment';
  // Record Trx
  static const String addTransaction = 'Add Transaction';
  static const String editTransaction = 'Edit Transaction';
  static const String transactionDetail = 'Transaction Detail';
  static const String deleteTransaction = 'Delete Transaction';
  static const String searchTransaction = 'Search Transaction';
  static const String transactionType = 'Transaction Type';
  static const String transactionCategory = 'Transaction Category';
  static const String sourceWallet = 'Source Wallet';
  static const String destinationWallet = 'Destination Wallet';
  static const String amount = 'Amount';
  static const String notes = 'Note';
  static const String notesHint = 'Add description...';
  static const String title = 'Title';
  static const String titleHint = 'Add title...';
  static const String selectWallet = 'Select Wallet';
  static const String selectCategory = 'Select Category';
  static const String transactionDate = 'Transaction Date';
  static const String amountLess = 'Amount need to be more than 0';
  static const String walletRequired = 'Choose source wallet first';
  static const String destinationWalletRequired =
      'Choose destination wallet first';
  static const String walletNotSame =
      'Source wallet and destination wallet must be different';
  static const String categoryRequired = 'Choose category first';
  // Category
  static const String addCategory = 'Add Category';
  static const String editCategory = 'Edit Category';
  static const String deleteCategory = 'Delete Category';
  static const String categoryName = 'Category Name';
  static const String categoryType = 'Category Type';
  static const String categoryIcon = 'Category Icon';
  static const String categoryColor = 'Category Color';
  // Wallet
  static const String addWallet = 'Add Wallet';
  static const String editWallet = 'Edit Wallet';
  static const String deleteWallet = 'Delete Wallet';
  static const String walletName = 'Wallet Name';
  static const String walletType = 'Wallet Type';
  static const String initialBalance = 'Initial Balance';
  // Debts
  static const String addDebts = 'Add Debts';
  static const String editDebts = 'Edit Debts';
  static const String debtsDetail = 'Debts Detail';
  // Debt Logs
  static const String addDebtLog = 'Add Debt Log';
  static const String editDebtLog = 'Edit Debt Log';

  /// Notification
  static const String noCategory = 'No category data found.';
  static const String noWallet = 'No wallet data found.';
  static const String noTransaction = 'No transaction data found.';
  static const String noDebt = 'No debts data found.';
  static const String noLoan = 'No loans data found.';
  static const String transactionFieldRequired =
      'Please fill in all fields for the transaction.';
  // Alert
  static const String succLogin = 'Login successfully';
  static const String succRegister = 'Register successfully';
  static const String succUpdateProfile = 'Update profile successfully';
  static const String succResetPassword = 'Update password successfully';
  static const String succChangePassword = 'Change password successfully';
  static const String succAddTransaction = 'Add transaction successfully';
  static const String succAddCategory = 'Add category successfully';
  static const String succAddWallet = 'Add wallet successfully';
  static const String succAddDebts = 'Add debts successfully';
  static const String succAddDebtLog = 'Add debt log successfully';
  static const String succUpdateTransaction = 'Update transaction successfully';
  static const String succUpdateCategory = 'Update category successfully';
  static const String succUpdateWallet = 'Update wallet successfully';
  static const String succUpdateDebts = 'Update debts successfully';
  static const String succUpdateDebtLog = 'Update debt log successfully';
  static const String succDelTransaction = 'Transaction deleted successfully';
  static const String succDelCategory = 'Category deleted successfully';
  static const String succDelWallet = 'Wallet deleted successfully';
  static const String succDelDebts = 'Debts deleted successfully';
  // Error
  static const String failLogin = 'Login failed';
  static const String failRegister = 'Register failed';
  static const String failUpdateProfile = 'Update profile failed';
  static const String failResetPassword = 'Update password failed';
  static const String failChangePassword = 'Change password failed';
  static const String failAddTransaction = 'Add transaction failed';
  static const String failTransfer = 'Transfer failed';
  static const String failSameSourceFund = 'Same source and destination wallet';
  static const String failAddCategory = 'Add category failed';
  static const String failAddWallet = 'Add wallet failed';
  static const String failAddDebts = 'Add debts failed';
  static const String failAddDebtLog = 'Add debt log failed';
  static const String failUpdateTransaction = 'Update transaction failed';
  static const String failSelectCategory = 'Please select a category first';
  static const String failUpdateCategory = 'Update category failed';
  static const String failUpdateWallet = 'Update wallet failed';
  static const String failUpdateDebts = 'Update debts failed';
  static const String failUpdateDebtLog = 'Update debt log failed';
  static const String failDelTransaction = 'Failed to delete transaction';
  static const String failDelCategory = 'Failed to delete category';
  static const String failDelWallet = 'Failed to delete wallet';
  static const String failDelDebts = 'Failed to delete debts';

  /// Button
  static const String loadingBtn = 'Loading...';
  static const String cancelBtn = 'Cancel';
  static const String confirmBtn = 'Confirm';
  static const String saveBtn = 'Save';
  static const String createBtn = 'Create';
  static const String editBtn = 'Edit';
  static const String updateBtn = 'Update';
  static const String deleteBtn = 'Delete';
  static const String loginBtn = 'Login';
  static const String registerBtn = 'Register';
  static const String logoutBtn = 'Logout';
  static const String updateProfileBtn = 'Update Profile';
  static const String forgotPasswordBtn = 'Forgot Password?';
  static const String updatePasswordBtn = 'Update Password';
  static const String changePasswordBtn = 'Change Password';
  static const String resetPasswordBtn = 'Reset Password';
  static const String deleteAccountBtn = 'Delete Account';
  static const String noAccount = 'Don\'t have an account? Register';
  static const String haveAccount = 'Already have an account? Login';
  static const String sendResetLinkBtn = 'Send Reset Link';
  static const String addTransactionBtn = 'Add Transaction';
  static const String addCategoryBtn = 'Add Category';
  static const String addWalletBtn = 'Add Wallet';
  static const String addDebtsBtn = 'Add Debts';
  static const String editTransactionBtn = 'Edit Transaction';
  static const String editCategoryBtn = 'Edit Category';
  static const String editWalletBtn = 'Edit Wallet';
  static const String editDebtsBtn = 'Edit Debts';
  static const String deleteTransactionBtn = 'Delete Transaction';
  static const String deleteCategoryBtn = 'Delete Category';
  static const String deleteWalletBtn = 'Delete Wallet';
  static const String deleteDebtsBtn = 'Delete Debts';

  // Dialog
  static const String logoutDialog = 'Are you sure you want to logout?';
  static const String deleteTransactionDialog =
      'Are you sure you want to delete this transaction?';
  static const String deleteCategoryDialog =
      'Are you sure you want to delete this category?';
  static const String deleteWalletDialog =
      'Are you sure you want to delete this wallet?';
  static const String deleteDebtsDialog =
      'Are you sure you want to delete this debts?';
  static const String resetPasswordInstructions =
      'Please enter your email address. We will send you an email to reset your password.';
  static const String changePasswordDialog =
      'Are you sure you want to change your password?';
  static const String resetPasswordDialog =
      'Are you sure you want to reset your password?';
  static const String deleteAccountDialog =
      'Are you sure you want to delete your account?';

  // label
  static const String success = 'Success';
  static const String error = 'Error';
}
