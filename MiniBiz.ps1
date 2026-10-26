Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[System.Windows.Forms.Application]::EnableVisualStyles()

# Keep the running sales total while the app is open.
$script:totalSales = [decimal]0

$form = New-Object System.Windows.Forms.Form
$form.Text = "MiniBiz - Sales Recorder"
$form.ClientSize = New-Object System.Drawing.Size(720, 520)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $false
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)

$title = New-Object System.Windows.Forms.Label
$title.Text = "MiniBiz - Sales Recorder"
$title.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$title.Location = New-Object System.Drawing.Point(24, 18)
$title.AutoSize = $true

$instructions = New-Object System.Windows.Forms.Label
$instructions.Text = "Enter the product details, then select Record Sale."
$instructions.Location = New-Object System.Drawing.Point(26, 58)
$instructions.AutoSize = $true

$productLabel = New-Object System.Windows.Forms.Label
$productLabel.Text = "Product name"
$productLabel.Location = New-Object System.Drawing.Point(26, 100)
$productLabel.AutoSize = $true

$productBox = New-Object System.Windows.Forms.TextBox
$productBox.Location = New-Object System.Drawing.Point(26, 126)
$productBox.Size = New-Object System.Drawing.Size(250, 28)

$quantityLabel = New-Object System.Windows.Forms.Label
$quantityLabel.Text = "Quantity"
$quantityLabel.Location = New-Object System.Drawing.Point(294, 100)
$quantityLabel.AutoSize = $true

$quantityBox = New-Object System.Windows.Forms.TextBox
$quantityBox.Location = New-Object System.Drawing.Point(294, 126)
$quantityBox.Size = New-Object System.Drawing.Size(100, 28)

$priceLabel = New-Object System.Windows.Forms.Label
$priceLabel.Text = "Price per item"
$priceLabel.Location = New-Object System.Drawing.Point(412, 100)
$priceLabel.AutoSize = $true

$priceBox = New-Object System.Windows.Forms.TextBox
$priceBox.Location = New-Object System.Drawing.Point(412, 126)
$priceBox.Size = New-Object System.Drawing.Size(130, 28)

$recordButton = New-Object System.Windows.Forms.Button
$recordButton.Text = "Record Sale"
$recordButton.Location = New-Object System.Drawing.Point(558, 124)
$recordButton.Size = New-Object System.Drawing.Size(130, 32)

$salesTitle = New-Object System.Windows.Forms.Label
$salesTitle.Text = "Sales recorded:"
$salesTitle.Location = New-Object System.Drawing.Point(26, 184)
$salesTitle.AutoSize = $true
$salesTitle.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)

$salesList = New-Object System.Windows.Forms.ListView
$salesList.Location = New-Object System.Drawing.Point(26, 212)
$salesList.Size = New-Object System.Drawing.Size(662, 220)
$salesList.View = [System.Windows.Forms.View]::Details
$salesList.FullRowSelect = $true
$salesList.GridLines = $true
$salesList.HideSelection = $false
$null = $salesList.Columns.Add("Product", 280)
$null = $salesList.Columns.Add("Quantity", 90)
$null = $salesList.Columns.Add("Price per item", 130)
$null = $salesList.Columns.Add("Sale total", 130)

$totalLabel = New-Object System.Windows.Forms.Label
$totalLabel.Text = "Total sales: $0.00"
$totalLabel.Location = New-Object System.Drawing.Point(26, 452)
$totalLabel.Size = New-Object System.Drawing.Size(662, 32)
$totalLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleRight
$totalLabel.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)

$recordButton.Add_Click({
    $product = $productBox.Text.Trim()
    $quantity = 0
    $price = [decimal]0

    if ([string]::IsNullOrWhiteSpace($product)) {
        [void][System.Windows.Forms.MessageBox]::Show(
            "Please enter a product name.",
            "Missing product name",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )
        $productBox.Focus()
        return
    }

    if (-not [int]::TryParse($quantityBox.Text.Trim(), [ref]$quantity) -or $quantity -le 0) {
        [void][System.Windows.Forms.MessageBox]::Show(
            "Enter a whole number greater than zero for quantity.",
            "Invalid quantity",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )
        $quantityBox.Focus()
        return
    }

    if (-not [decimal]::TryParse($priceBox.Text.Trim(), [ref]$price) -or $price -le 0) {
        [void][System.Windows.Forms.MessageBox]::Show(
            "Enter a price greater than zero, such as 2.50.",
            "Invalid price",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )
        $priceBox.Focus()
        return
    }

    $saleTotal = $quantity * $price
    $script:totalSales += $saleTotal

    $row = New-Object System.Windows.Forms.ListViewItem($product)
    [void]$row.SubItems.Add($quantity.ToString())
    [void]$row.SubItems.Add(('{0:C2}' -f $price))
    [void]$row.SubItems.Add(('{0:C2}' -f $saleTotal))
    [void]$salesList.Items.Add($row)

    $totalLabel.Text = "Total sales: {0:C2}" -f $script:totalSales

    $productBox.Clear()
    $quantityBox.Clear()
    $priceBox.Clear()
    $productBox.Focus()
})

$form.Controls.Add($title)
$form.Controls.Add($instructions)
$form.Controls.Add($productLabel)
$form.Controls.Add($productBox)
$form.Controls.Add($quantityLabel)
$form.Controls.Add($quantityBox)
$form.Controls.Add($priceLabel)
$form.Controls.Add($priceBox)
$form.Controls.Add($recordButton)
$form.Controls.Add($salesTitle)
$form.Controls.Add($salesList)
$form.Controls.Add($totalLabel)

[void]$form.ShowDialog()