Return-Path: <kvm+bounces-49510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D36CAD956F
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 21:24:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A4063ACFA2
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 19:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A69524676D;
	Fri, 13 Jun 2025 19:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G8Cae4+c";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qcpBD6Um"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DF32441A7;
	Fri, 13 Jun 2025 19:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749842351; cv=fail; b=bYp2tqdURY3iQ8JpiTbwRpnmFN7AF1JnoqQ9j0LhowI1astz0n8vbCu/kFJVS2M4dKwEj1ls/xPUKPYDFaQOyVukTJZN2eMghRVmGLbzMiyMa7lERLNyBa/VVI57Ey1Vmxn8nQRLtdL8th9Rw2nvcWVykhaYAhaK6LAgPgrDsU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749842351; c=relaxed/simple;
	bh=dZOKHtSwXaQ1NbR7G7QKlpPtoOdVkPq6tWSJ9UNa/qc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rcp8TiD8VCDwmn1ptfgbd7UWAXVD+F8ssDhAc4xupJFzMvPnudVb2aoiIU/OPSF6psdA2XmdvJw1pczFFC0vu10qhZK/c8U3sVv3jIpOYQlkVs97WA4WCfe61f7koh6OD5HqYAFBIHVyNYu0oITJA+6d1FYDvvNFKrUHupRLDc4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=G8Cae4+c; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qcpBD6Um; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55DCtavB032163;
	Fri, 13 Jun 2025 19:18:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=zsynZjduTjEPExsPIE
	K5E+obMqqVaIxJlwbzZEUP084=; b=G8Cae4+c0E7zdWyZQ7Fj64gu+zgcbrPxcb
	8DVUid0a4RfNr2VhkJHbqQxazsJBg4F9/tOy+4GihoRCLZpA2ciDiVHyw/FScJ0Q
	/o2zQ26lLSr5e+9A8GmdrS7BDmDHI7uTx5Rqadwyr2bzfBhizfdB8LEu0/Fnw1U6
	1mJ8bM3Gd2EkTid5Q9z8zfZqp7bUtU4wQJvm8GMDi4gnxMaw8W+h1ND0JrOIo0dc
	F3OtQmDYuAS6M4NGse4/xxfG84srtpV0Wn/7NgYvVnDDw4WPAK5mqxsX+hWtpk0A
	fpOB2/vgrHR/6BQt4gwqTh+YpMovib1UPRUDoD3xTB5KGbD0blLA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474c7546c3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Jun 2025 19:18:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55DHmORX009419;
	Fri, 13 Jun 2025 19:18:48 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2072.outbound.protection.outlook.com [40.107.243.72])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 474bvdysj4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Jun 2025 19:18:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i9VdceutjmH0dgpaBYiwTuWsAyuh/NASbNmON3a8DWBKyy9hKytWgP7LTB7q8wJPRXTUNXOzYVbzqyclw229foku+Mm1jjWfPRHoW1SVu22hmqz/gri0nJS9Q9kvSib+cu/jF42Dad5cSv0ZoiR0P3v1T5X2jX57wlA1UBxZ7RgcNMy5sY3YQMNjHMnay0lVJvR/qDqpkK/mSoWYZmID+6sFaWTkyBUChi9bkZZItcDxjhZv76Qx9x1/VIWuXAGNfu3ZIcM/CyK9mXnuEI+uL0ra9N3jeqYHOMN5zZuDC7Eds4WZ19DH686POGeau/D67QXT/3GBiuk0wRkTAUFIMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zsynZjduTjEPExsPIEK5E+obMqqVaIxJlwbzZEUP084=;
 b=WJNs7GtTxtS7hMvsMPBHXsK4HMY+y5qlMyh6ZU1l63BzWp1Ih+DtYgtoZ6uWOq520pMjKQ3JH9rv1V+SOLc7HNZhf5Ql8b2KPFwnIAdvZD0DIs6OoKhpMbmuzTsVQt4QwdERSnlVhQR5ZJqJnH6k1CpC0aHRpfjm8/vDov76VS1fG9AinrWkUfh7p7EMZfssdZbWuPkrSbSUx7h0EKqTI2pE8JnvFUeLDXloXWVrrewBqP3286Q7LC7cRfGJsKtVnJjetGKVMmYSDzdkDNqnzxbQGGGCCSlGWubcpIPKOoMiNd8G8SZ8cuWXZvf8ZVKnh7x6jaDDEgXWHXN8Fc/yEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zsynZjduTjEPExsPIEK5E+obMqqVaIxJlwbzZEUP084=;
 b=qcpBD6UmFGOQMnYj1/NriWWGTtmZEyQH4a7OxaqhJyImjc3SBTQMIvA2zYKbb/zCp+wPEzFpWY5Myfqi8E1ySmJ3UQgvW0ylHhBnx3wmCtnxox4Q9D3XcwHGf7pvVXwQmHgva55fiBu/lWU5ojDOubjqYoD+hdf41kEIhn0ZfUk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY8PR10MB6540.namprd10.prod.outlook.com (2603:10b6:930:58::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.19; Fri, 13 Jun
 2025 19:18:45 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.8813.024; Fri, 13 Jun 2025
 19:18:45 +0000
Date: Fri, 13 Jun 2025 20:18:42 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>, Zi Yan <ziy@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, Alex Mastro <amastro@fb.com>,
        David Hildenbrand <david@redhat.com>, Nico Pache <npache@redhat.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>
Subject: Re: [PATCH 3/5] mm: Rename __thp_get_unmapped_area to
 mm_get_unmapped_area_aligned
Message-ID: <9733d8cf-edab-4b2b-bf2e-11457ef63dc8@lucifer.local>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-4-peterx@redhat.com>
 <08193194-3217-4c43-923e-c72cdbbd82e7@lucifer.local>
 <aExxy3WUp6gZx24f@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aExxy3WUp6gZx24f@x1.local>
X-ClientProxiedBy: LO2P123CA0033.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::21)
 To DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY8PR10MB6540:EE_
X-MS-Office365-Filtering-Correlation-Id: 1488a1d1-5837-4cff-152a-08ddaaaf1d85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?d1K/aGZ4EeQuoeIaQ3+SgpiB4dR63fm6nBljMALaUkUx2HCE6i7j8diCBRl1?=
 =?us-ascii?Q?PEKofcDU1S0UZhQPBh89e5CRyVhsF2adi4FDqnnPk5FYCtMb3J8qyJR8CTFa?=
 =?us-ascii?Q?iYRHoximyifFJ7GzTfkuzMbHNvM1lJzdDWfkbVUtLvU8thIpYKQvB36e6o0W?=
 =?us-ascii?Q?uAAPos1YTHGDE51Mku29+vk0G4w0OKruSsTIexYBDvyPjqMvRCkDiGwGEvty?=
 =?us-ascii?Q?fLXrX0nYpeg/JOobszv8vl3h0zVwNV8fKW66+y2bPt9dO5i7YI5KuoAlDSXG?=
 =?us-ascii?Q?TY0auBFRLsX+bCFc+tUZBK4IVl98kx5pnlPYxfWJZEnZnCRKq9hiogSm3bJ3?=
 =?us-ascii?Q?L5So5TiBotEV8ihGWKzGis3XhCaA3RwfNKpUsYVv7wIPDk2nGIFfd6Igz/Ld?=
 =?us-ascii?Q?DGz9RYJHQX7H91TXDcKVcx9o3+02ImjV07X6hHUC0NnMfYXYBAAvVRRif+PT?=
 =?us-ascii?Q?509ZL5tNFmQ8eP6F5AHfJU6xNNMQOFaEasCjO2498iZ5Yyj4z1O1mWJJZRSt?=
 =?us-ascii?Q?ULIn+n21JE2993qpi4wHqi1VrdwH4dn+lDSfcuuXxheTWgOpSS5XmouErItZ?=
 =?us-ascii?Q?nhj7uF7Ulvz7Md4tL/iGKNvUzQkmdPunwtoh9BMlwoDi3nyQGHB1ph9HuST4?=
 =?us-ascii?Q?AsDu9ZIQ+vevmCtLWCgenk3Kj8AM2hEqEcQeIdsYsciWMJlPQFP3D3gXc9a+?=
 =?us-ascii?Q?yuLFFsRQ6jOQ1JXQTiq6u7lQwAGCo2QpwfSCo/ydzlcgkSpG11YlcCw93ZeC?=
 =?us-ascii?Q?0Go7Ke6p7n0G/4mg1IOaKFsXrXIA8y4DRzXGUiC6MHQAc8SmiKMUgzVgePvf?=
 =?us-ascii?Q?o9tBL6TEJjKDPzrT2+hWISP3Xiajp+rLDzrplEwxbOY+Gah7Wjqi8M9UE+Sd?=
 =?us-ascii?Q?cvpCpPNWBa+f/C5TUOrfHfkP3Z+8yI2DzjOZIc1ghRFv5HKi8nvjKGseGCUR?=
 =?us-ascii?Q?jLjRW1MBotxhsqeXLAFFlRw+1jivF1CBpwTlghOPavdX0lJ9qMPML2usy838?=
 =?us-ascii?Q?e8ozCo9ldhANNoKLtRZzBt2EQrlryEmCt3vxKDHEYt3t5swkCeTDnmmGWZ80?=
 =?us-ascii?Q?n0AmCZYSCmTKgtXfNrr9oZEBvia73VqxAxVZRNvd40Wvru7JPlwqMFuw0RTL?=
 =?us-ascii?Q?OrjGIOjjmOoau+BNmU2Fkhwj7AlFGTR+/8hlvk3lsbpi7j78lsWKUZCScEE4?=
 =?us-ascii?Q?9GYIUNlTU9zuZdAP+ZLT/oWjB/Oh8ja9soJhFg/yVFPKlKBkvc15X5vAqoEn?=
 =?us-ascii?Q?DrD0u09Gf3Ly2icdPpYQSxVGW/HAjsUo7+H+FByzecGskFDOBLTEZiLUIjo4?=
 =?us-ascii?Q?O8Bn2nYxcn+nzlhmuBfn/E06JQNIOAIV9EcuQduD4UoWyY91pfEhKx45IaZC?=
 =?us-ascii?Q?ZgRAZyeU92oFeVc4ZWXbeEP9CmF+2ehytlJOc9lus5lUq/eJYSTWo4ixuedL?=
 =?us-ascii?Q?rZAM+aaObLw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HS1TiylmH4bJQecLiG6ktq3AHetS8tuIMmrBXZhaH10Hlx0EHSwGpgSSEZfe?=
 =?us-ascii?Q?ZZ3mdhhKFNPeu89zXCNqY4tn5b5t7sWZTwCP1qeewhi4GhEXD0xYtPKVv4Z3?=
 =?us-ascii?Q?IYqyLpkuYNssQQBBJ26vtolMrxE9gkmV7jXPgktVJst1XxE9pRui/QtWVHV+?=
 =?us-ascii?Q?lSAbn9IHgiFHO+8cWLWk0e3T3GhPFx0Irknc/w+5rsQzKFWzvrkTrUdIfO8m?=
 =?us-ascii?Q?dVPdq7vGXmqBfGp9dQ0u+6BA+kAoCiMABNC1v1SuyO8ilMY6yrSnzxYYjGS5?=
 =?us-ascii?Q?5zEAvY8RVXx/r3RA4Pmpfc50TTlio6Tql3X+CRR5y166Jf1+ckO/2hQuumda?=
 =?us-ascii?Q?WxtR9MI36s57uiAm5hJHpoTJBB5b3ePvdU+qx6h7geX6Ixe2m5baNZuw3+34?=
 =?us-ascii?Q?JdE5iueDC2svBQ//nbA0eRiollYsGhotLNKOyYirX4fGZi6wLi+sKiCGHrwu?=
 =?us-ascii?Q?WFIKz6WN8Ucj5Z7xoAR/xCmbFg8DvilFPRfcj+NXrKQLMl37QZ+IYfppop3G?=
 =?us-ascii?Q?VvBmqdm28hotHorHr5+7Atn2W7EyWS3sKGk3ilZTbDGOYtXgWDUxq0Bhlte1?=
 =?us-ascii?Q?HHJwGWJ+7MXqIzisoe2M11iV424wpUx663eI251TA+QNqI24wrolrldSxPrV?=
 =?us-ascii?Q?UeKF7ygFqruWc3pm61xj7fwS+hU2VPSQDc1BiPWs0Jjiqwah0TnloG/FeLN6?=
 =?us-ascii?Q?wD6kVsh3rwEzCHqtOWMl0WASUdMR6jfR9AX5H00W7ceAXqD1sH5Bf5HHvtOA?=
 =?us-ascii?Q?M579wDZRG00sNb+c5DqnrdGYod/AshctRq+dGI3mo5Uab3nka6kt9FqbyzLo?=
 =?us-ascii?Q?LC8k2xqjFdcMYTg8qNB1HlYeqhHNiWZR4P/X1TFp+SpvCM876mstNRjzrvEG?=
 =?us-ascii?Q?UbQXWt3AYQ1ePsSRJtIXnliaqsO96OjPJJOu3InIZLTbqiIYObeAGOzKKsoq?=
 =?us-ascii?Q?Hp7intpUOKEgKt3HU5osZc+EcIYGchRsmqj6oxDfZshcdbFZDaXgIzQUwnHS?=
 =?us-ascii?Q?aN+vvAjt8LW2w47I7wEiZ8hc6tocWuLrPm67X7BrzEiKyKQpwPuvINeG5evD?=
 =?us-ascii?Q?dMM5uw9K6B99umBdWtqUvoWqhyAGUmSj+dIhPfujqcWesZBgChXMIsgSq4gv?=
 =?us-ascii?Q?MW2zMbh8/zOvhr1RWdf1U83pnGqZQuLZn943G5WthlowElb1dl/pYCXFohO4?=
 =?us-ascii?Q?KZxXQxeZ5OKbW3NizAMTe1X8P+CRP9JwJIKAQqcqLIjtSwdR8Jl4mXTZCvqV?=
 =?us-ascii?Q?Q7WEAtotZhIFhsTkueHuZiInYIE+kW24Bg/hzknxREeH2IyD5HdNpndPmfd1?=
 =?us-ascii?Q?rGShHC/VSixDHpXOc7bBYtQbLCgJoG5o41nFw9Y20lU2ibR0qHVJLSh9NnVf?=
 =?us-ascii?Q?7xlbt5f59IUWbBxjrCdE0t+H4otffcjsv8mypQGcgmEK9TYQp6WfmAGsU3Cp?=
 =?us-ascii?Q?GWtfrLPWh8SVGUXOG0dsZKU9olNi0PDeAFoMJzJPf1DjjffT/BaE9atdelcm?=
 =?us-ascii?Q?zxuoUkDTssNVn9ztsAwL4ne7K9tRlZ+HsP27buK+ubORUt4uXY/wz2l5qmpn?=
 =?us-ascii?Q?+qupqK1mdVpeI9q83eg+9cgV8vUUDvKOK1sczHGraX5jJDGBW/SoX2xby3bC?=
 =?us-ascii?Q?jQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QhFD+O5ghsuWvGUWt1n6oegU+Gh60ZkCWQWQxiZ/zhJPstVmTmyJ8krkwd7DjbsS5uOA9H1hMjRACgB34ihlKBDGLUxNqRlM4j7pNaqBO4Vmqf8ntHIotevpb//LqIBjPW+nhYZm9FYpdHYpaYRtmrj1wv/RcTK3wPZpV9NIn0SO/U6AwP0b0Zro0vDpF+RwLacpUDalStHwYRSDZI5yqIT39Yl5zkZcuP4VFJ/36cl7+oppOSEQR+DB5un9e09M87fSfPpF6C0j6cR4Lt/bOnvNIytrfT7Goxom/i0YaKgfbJogRjo8k6mVReZTWgIZUXRAJ1mp6da4qIuiQJIwBWjc+/DNjAtLiYw1hUypRN5D8wGaY+StJuCiQZ2l3jsdUHqCs4BNG12PD54dnaKWWEFQxAoXpecIW/Uyseah0I/8R7uf5wNj0EgwqUY84RYotgE61hl6+tuojBvClrERYJrU3YrXd0arQdF84nh8QRk/cwP4Th1jheDVbQnrGl2qRrrDcM4CdHC8in3qpgsO0SNS2IlE+pOqqhOHbxF9Pqx+fMoiv359pt37EO+/O2bKZBOXnA6Z6eDCrSXq/13u2K7+PT9ZGZQsW+r4PUvJwWw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1488a1d1-5837-4cff-152a-08ddaaaf1d85
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 19:18:44.9398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zqoNgSrtGaYGp0fiVM7HU1nclotO668uwvlO0Mxy8MxDU/AJs5K5RKShZMQu/peyMluRovNysTFfTIwv9SRa49H1/6b9q1U4jHnVTZMEwPI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6540
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-13_02,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506130134
X-Authority-Analysis: v=2.4 cv=LIpmQIW9 c=1 sm=1 tr=0 ts=684c7998 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=Ikd4Dj_1AAAA:8 a=SRrdq9N9AAAA:8 a=yPCof4ZbAAAA:8 a=7CQSdrXTAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=MXXnlAoLNgiQxc2lvNYA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:13206
X-Proofpoint-ORIG-GUID: 528LrmMHupypf0CmaN5HGNn49RYcmF5x
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEzMDEzNCBTYWx0ZWRfX7F89a7zuYZxk M3evKAqo5NkW5BGGRncRWlmyrK1LBixSHe31bjnwc0j1utKaKoZsrSp3DzXhhCnSS18l3rnYOC6 tUWfuO69/JD/xTU30wtPlxOoARjZnf9Hfiqz0tjesJO7dY5DpAIDAzl/yMhw230DEmorzcczuxG
 l35rrQOvhiVGXkiZD02ejyIgGGgLoNph+Q2QCsDLBFaBxZRGKR2reg79NJE+0hRGtVHmJEu8Wqe IfNXTh2/CSFKbI8mgF/g0IYZ7Jj6TF0XjNWrm51lsyjV28YkFAGbtnETJR3qp4/FjOjZ5S726Ki u6HOMses29vakHU4ZGnYQYRSxYzXujZsrZHkb2O54F53+Xdwjz4pkAoNLKy9tUEyJttmHt6vqKa
 thhBTvcSXXAFqDs17HrEKAY2Ocv7qXNwGblngKFAmwz0Zu7DuCzvmJvNL25NbHxqCdxexn3M
X-Proofpoint-GUID: 528LrmMHupypf0CmaN5HGNn49RYcmF5x

On Fri, Jun 13, 2025 at 02:45:31PM -0400, Peter Xu wrote:
> On Fri, Jun 13, 2025 at 04:36:57PM +0100, Lorenzo Stoakes wrote:
> > On Fri, Jun 13, 2025 at 09:41:09AM -0400, Peter Xu wrote:
> > > This function is pretty handy for any type of VMA to provide a size-aligned
> > > VMA address when mmap().  Rename the function and export it.
> >
> > This isn't a great commit message, 'to provide a size-aligned VMA address when
> > mmap()' is super unclear - do you mean 'to provide an unmapped address that is
> > also aligned to the specified size'?
>
> I sincerely don't know the difference, not a native speaker here..
> Suggestions welcomed, I can update to whatever both of us agree on.

Sure, sorry I don't mean to be pedantic I just think it would be clearer to
sort of expand upon this, as the commit message is rather short.

I think saying something like this function allows you to locate an
unmapped region which is aligned to the specified size should suffice.

>
> >
> > I think you should also specify your motive, renaming and exporting something
> > because it seems handy isn't sufficient justifiation.
> >
> > Also why would we need to export this? What modules might want to use this? I'm
> > generally not a huge fan of exporting things unless we strictly have to.
>
> It's one of the major reasons why I sent this together with the VFIO
> patches.  It'll be used in VFIO patches that is in the same series.  I will
> mention it in the commit message when repost.

OK cool, I've not dug through those as not my area, really it's about
having the appropriate justification.

I'm always inclined to not want us to export things by default, based on
experience of finding 'unusual' uses of various mm interfaces in drivers in
the past which have caused problems :)

But of course there are situations that warrant it, they just need to be
spelled out.

>
> >
> > >
> > > About the rename:
> > >
> > >   - Dropping "THP" because it doesn't really have much to do with THP
> > >     internally.
> >
> > Well the function seems specifically tailored to the THP use. I think you'll
> > need to further adjust this.
>
> Actually.. it is almost exactly what I need so far.  I can justify it below.

Yeah, but it's not a general function that gives you an unmapped area that
is aligned.

It's a 'function that gets you an aligned unmapped area but only for 64-bit
kernels and when you are not invoking it from a compat syscall and returns
0 instead of errors'.

This doesn't sound general to me?

>
> >
> > >
> > >   - The suffix "_aligned" imply it is a helper to generate aligned virtual
> > >     address based on what is specified (which can be not PMD_SIZE).
> >
> > Ack this is sensible!
> >
> > >
> > > Cc: Zi Yan <ziy@nvidia.com>
> > > Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> > > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > > Cc: Ryan Roberts <ryan.roberts@arm.com>
> > > Cc: Dev Jain <dev.jain@arm.com>
> > > Cc: Barry Song <baohua@kernel.org>
> > > Signed-off-by: Peter Xu <peterx@redhat.com>
> > > ---
> > >  include/linux/huge_mm.h | 14 +++++++++++++-
> > >  mm/huge_memory.c        |  6 ++++--
> > >  2 files changed, 17 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > > index 2f190c90192d..706488d92bb6 100644
> > > --- a/include/linux/huge_mm.h
> > > +++ b/include/linux/huge_mm.h
> >
> > Why are we keeping everything in huge_mm.h, huge_memory.c if this is being made
> > generic?
> >
> > Surely this should be moved out into mm/mmap.c no?
>
> No objections, but I suggest a separate discussion and patch submission
> when the original function resides in huge_memory.c.  Hope it's ok for you.

I like to be as flexible as I can be in review, but I'm afraid I'm going to
have to be annoying about this one :)

It simply makes no sense to have non-THP stuff in 'the THP file'. Also this
makes this a general memory mapping function that should live with the
other related code.

I don't really think much discussion is required here? You could do this as
2 separate commits if that'd make life easier?

Sorry to be a pain here, but I'm really allergic to our having random
unrelated things in the wrong files, it's something mm has done rather too
much...

>
> >
> > > @@ -339,7 +339,10 @@ unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
> > >  unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
> > >  		unsigned long len, unsigned long pgoff, unsigned long flags,
> > >  		vm_flags_t vm_flags);
> > > -
> > > +unsigned long mm_get_unmapped_area_aligned(struct file *filp,
> > > +		unsigned long addr, unsigned long len,
> > > +		loff_t off, unsigned long flags, unsigned long size,
> > > +		vm_flags_t vm_flags);
> >
> > I echo Jason's comments about a kdoc and explanation of what this function does.
> >
> > >  bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
> > >  int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
> > >  		unsigned int new_order);
> > > @@ -543,6 +546,15 @@ thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
> > >  	return 0;
> > >  }
> > >
> > > +static inline unsigned long
> > > +mm_get_unmapped_area_aligned(struct file *filp,
> > > +			     unsigned long addr, unsigned long len,
> > > +			     loff_t off, unsigned long flags, unsigned long size,
> > > +			     vm_flags_t vm_flags)
> > > +{
> > > +	return 0;
> > > +}
> > > +
> > >  static inline bool
> > >  can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
> > >  {
> > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > > index 4734de1dc0ae..52f13a70562f 100644
> > > --- a/mm/huge_memory.c
> > > +++ b/mm/huge_memory.c
> > > @@ -1088,7 +1088,7 @@ static inline bool is_transparent_hugepage(const struct folio *folio)
> > >  		folio_test_large_rmappable(folio);
> > >  }
> > >
> > > -static unsigned long __thp_get_unmapped_area(struct file *filp,
> > > +unsigned long mm_get_unmapped_area_aligned(struct file *filp,
> > >  		unsigned long addr, unsigned long len,
> > >  		loff_t off, unsigned long flags, unsigned long size,
> > >  		vm_flags_t vm_flags)
> > > @@ -1132,6 +1132,7 @@ static unsigned long __thp_get_unmapped_area(struct file *filp,
> > >  	ret += off_sub;
> > >  	return ret;
> > >  }
> > > +EXPORT_SYMBOL_GPL(mm_get_unmapped_area_aligned);
> >
> > I'm not convinced about exporting this... shouldn't be export only if we
> > explicitly have a user?
> >
> > I'd rather we didn't unless we needed to.
> >
> > >
> > >  unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
> > >  		unsigned long len, unsigned long pgoff, unsigned long flags,
> > > @@ -1140,7 +1141,8 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
> > >  	unsigned long ret;
> > >  	loff_t off = (loff_t)pgoff << PAGE_SHIFT;
> > >
> > > -	ret = __thp_get_unmapped_area(filp, addr, len, off, flags, PMD_SIZE, vm_flags);
> > > +	ret = mm_get_unmapped_area_aligned(filp, addr, len, off, flags,
> > > +					   PMD_SIZE, vm_flags);
> > >  	if (ret)
> > >  		return ret;
> > >
> > > --
> > > 2.49.0
> > >
> >
> > So, you don't touch the original function but there's stuff there I think we
> > need to think about if this is generalised.
> >
> > E.g.:
> >
> > 	if (!IS_ENABLED(CONFIG_64BIT) || in_compat_syscall())
> > 		return 0;
> >
> > This still valid?
>
> Yes.  I want this feature (for VFIO) to not be enabled on 32bits, and not
> enabled with compat syscals.

OK, but then is this a 'general' function any more?

These checks were introduced by commit 4ef9ad19e176 ("mm: huge_memory:
don't force huge page alignment on 32 bit") and so are _absolutely
specifically_ intended for a THP use-case.

And now they _just happen_ to be useful to you but nothing about the
function name suggests that this is the case?

I mean it seems like you should be doing this check separately in both VFIO
and THP code and having the 'general 'function not do this no?

>
> >
> > 	/*
> > 	 * The failure might be due to length padding. The caller will retry
> > 	 * without the padding.
> > 	 */
> > 	if (IS_ERR_VALUE(ret))
> > 		return 0;
> >
> > This is assuming things the (currently single) caller will do, that is no longer
> > an assumption you can make, especially if exported.
>
> It's part of core function we want from a generic helper.  We want to know
> when the va allocation, after padded, would fail due to the padding. Then
> the caller can decide what to do next.  It needs to fail here properly.

I'm no sure I understand what you mean?

It's not just this case, it's basically any error condition results in 0.

It's actually quite dangerous, as the get_unmapped_area() functions are
meant to return either an error value or the located address _and zero is a
valid response_.

So if somebody used this function naively, they'd potentially have a very
nasty bug occur when an error arose.

If you want to export this, I just don't think we can have this be a thing
here.

>
> >
> > Actually you maybe want to abstract the whole of thp_get_unmapped_area_vmflags()
> > no? As this has a fallback mode?
> >
> > 	/*
> > 	 * Do not try to align to THP boundary if allocation at the address
> > 	 * hint succeeds.
> > 	 */
> > 	if (ret == addr)
> > 		return addr;
>
> This is not a fallback. This is when user specified a hint address (no
> matter with / without MAP_FIXED), if that address works then we should
> reuse that address, ignoring the alignment requirement from the driver.
> This is exactly the behavior VFIO needs, and this should also be the
> suggested behavior for whatever new drivers that would like to start using
> this generic helper.

I didn't say this was the fallback :) this just happened to be the code
underneath my comment. Sorry if that wasn't clear.

This is another kinda non-general thing but one that makes more sense. This
comment needs updating, however, obviously. You could just delete 'THP' in
the comment that'd probalby do it.

The fallback is in:

unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
		unsigned long len, unsigned long pgoff, unsigned long flags,
		vm_flags_t vm_flags)
{
	unsigned long ret;
	loff_t off = (loff_t)pgoff << PAGE_SHIFT;

	ret = __thp_get_unmapped_area(filp, addr, len, off, flags, PMD_SIZE, vm_flags);
	if (ret)
		return ret;

So here, if ret returns an address, then it's fine we return that.

Otherwise, we invoke the below (the fallback):

	return mm_get_unmapped_area_vmflags(current->mm, filp, addr, len, pgoff, flags,
					    vm_flags);
}

>
> >
> > What was that about this no longer being relevant to THP? :>)
> >
> > Are all of these 'return 0' cases expected by any sensible caller? It seems like
> > it's a way for thp_get_unmapped_area_vmflags() to recognise when to fall back to
> > non-aligned?
>
> Hope above justfies everything.  It's my intention to reuse everything
> here.  If you have any concern on any of the "return 0" cases in the
> function being exported, please shoot, we can discuss.

Of course, I have some doubts here :)

>
> Thanks,
>
> --
> Peter Xu
>

To be clearer perhaps, what I think would work here is:

1. Remove the CONFIG_64BIT, in_compat_syscall() check and place it in THP
   and VFIO code separately, as this isn't a general thing.

2. Rather than return 0 in this function, return error codes so it matches
   the other mm_get_unmapped_area_*() functions.

3. Adjust thp_get_unmapped_area_vmflags() to detect the error value from
   this function and do the fallback logic in this case. There's no need
   for this 0 stuff (and it's possibly broken actually, since _in theory_
   you can get unmapped zero).

4. (sorry :) move the code to mm/mmap.c

5. Obviously address comments from others, most importantly (in my view)
   ensuring that there is a good kernel doc comment around the function.

6. Put the justifiation for exporting the function + stuff about VFIO in
   the commit message + expand it a little bit as discussed.

7. Other small stuff raised above (e.g. remove 'THP' comment etc.)

Again, sorry to be a pain, but I think we need to be careful to get this
right so we don't leave any footguns for ourselves in the future with
'implicit' stuff.

Thanks!

