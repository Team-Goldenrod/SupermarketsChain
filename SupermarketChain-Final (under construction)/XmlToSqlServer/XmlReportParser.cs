﻿using System.Text;

namespace SupermarketChain
{
    using System;
    using System.IO;
    using System.Linq;
    using System.Xml.Linq;
    using System.Xml.XPath;

    public class XmlReportParser : IXmlParser
    {
        public XmlReportParser()
        {
            this.Db = new SupermarketsChainSqlServerEntities();
        }

        public SupermarketsChainSqlServerEntities Db { get; set; }


        public string ImportXmlExpenses(string path)
        {
            var output = new StringBuilder();
            var vendors = this.Db.Vendors.Select(v => v);

            if (File.Exists(path))
            {
                var xmlReport = XDocument.Load(path);
                var vendorNodes = xmlReport.XPathSelectElements("expenses-by-month/vendor");
                foreach (var vendorNode in vendorNodes)
                {
                    var vendorName = vendorNode.Attribute("name").Value;
                    var vendor = vendors.FirstOrDefault(v => v.Name == vendorName);
                    var expensesNodes = vendorNode.Elements("expenses");

                    if (vendor != null)
                    {
                        foreach (var expensesNode in expensesNodes)
                        {
                            var month = DateTime.Parse(expensesNode.Attribute("month").Value);
                            decimal expense = decimal.Parse(expensesNode.Value);
                            var expence = new Expenses
                            {
                                Month = month,
                                Expense = expense
                            };

                            expence.Vendors.Add(vendor);
                            this.Db.Expenses.Add(expence);
                            this.Db.SaveChanges();
                        }
                    }
                }

                output.Append("Report successfully imported");
            }
            else
            {
                throw new ArgumentException("File does not exists");
            }

            return output.ToString();
        }
    }
}
