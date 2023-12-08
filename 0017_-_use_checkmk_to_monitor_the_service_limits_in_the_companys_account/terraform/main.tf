# https://docs.checkmk.com/latest/en/monitoring_aws.html

resource "aws_iam_access_key" "key" {
  user = aws_iam_user.check_mk.name
}

resource "aws_iam_user" "check_mk" {
  name = "check-mk"
}

resource "aws_iam_user_policy_attachment" "check_mk_ro_access" {
  user = aws_iam_user.check_mk.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_user_policy_attachment" "check_mk_billing_view" {
  user = aws_iam_user.check_mk.name
  policy_arn = aws_iam_policy.billing_view.arn
}

resource "aws_iam_policy" "billing_view" {
  name = "BillingViewAccess"
  policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "BillingAndCostExplorerReadOnly",
          "Effect": "Allow",
          "Action": [
            "billing:GetBillingData",
            "billing:GetBillingDetails",
            "billing:GetBillingNotifications",
            "billing:GetBillingPreferences",
            "billing:GetContractInformation",
            "billing:GetCredits",
            "billing:GetIAMAccessPreference",
            "billing:GetSellerOfRecord",
            "billing:ListBillingViews",
            "ce:DescribeCostCategoryDefinition",
            "ce:DescribeNotificationSubscription",
            "ce:DescribeReport",
            "ce:GetAnomalies",
            "ce:GetAnomalyMonitors",
            "ce:GetAnomalySubscriptions",
            "ce:GetApproximateUsageRecords",
            "ce:GetConsoleActionSetEnforced",
            "ce:GetCostAndUsage",
            "ce:GetCostAndUsageWithResources",
            "ce:GetCostCategories",
            "ce:GetCostForecast",
            "ce:GetDimensionValues",
            "ce:GetPreferences",
            "ce:GetReservationCoverage",
            "ce:GetReservationPurchaseRecommendation",
            "ce:GetReservationUtilization",
            "ce:GetRightsizingRecommendation",
            "ce:GetSavingsPlanPurchaseRecommendationDetails",
            "ce:GetSavingsPlansCoverage",
            "ce:GetSavingsPlansPurchaseRecommendation",
            "ce:GetSavingsPlansUtilization",
            "ce:GetSavingsPlansUtilizationDetails",
            "ce:GetTags",
            "ce:GetUsageForecast",
            "ce:ListTagsForResource"
          ],
          "Resource": "*"
        }
      ]
    }
  EOF
}
