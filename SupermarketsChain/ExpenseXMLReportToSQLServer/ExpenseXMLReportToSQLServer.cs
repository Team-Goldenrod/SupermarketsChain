﻿namespace SupermarketsChain
{
    using System;

    class ExpenseXMLReportToSQLServer
    {
        static void Main()
        {
            var dbContext = new SupermarketsChainEntities();
            var vendors = dbContext.Vendors;

            foreach (var vendor in vendors)
            {
                Console.WriteLine(vendor.Name);
            }
        }
    }
}