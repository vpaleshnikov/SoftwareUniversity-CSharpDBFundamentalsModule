		 SELECT p.PartId,
				p.Description,
				SUM(pn.Quantity) AS Required,
				AVG(p.StockQty) AS [In Stock],
				ISNULL(SUM(op.Quantity), 0) AS Ordered
		   FROM Parts AS p
	 INNER JOIN PartsNeeded AS pn 
			 ON pn.PartId = p.PartId
	 INNER JOIN Jobs AS j
			 ON j.JobId = pn.JobId
LEFT OUTER JOIN Orders AS o
			 ON o.JobId = j.JobId
LEFT OUTER JOIN OrderParts AS op
			 ON op.OrderId = o.OrderId
		  WHERE j.Status <> 'Finished'
	   GROUP BY p.PartId, p.Description
		 HAVING AVG(p.StockQty) + ISNULL(SUM(op.Quantity), 0) < SUM (pn.Quantity)
	   ORDER BY p.PartId