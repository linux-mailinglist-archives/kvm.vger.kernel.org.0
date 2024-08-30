Return-Path: <kvm+bounces-25575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 682F9966C6E
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:31:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21A2528435E
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 22:31:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AE561C4EFE;
	Fri, 30 Aug 2024 22:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="brcVIV56";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Q85vuaqg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45E01C1AAE;
	Fri, 30 Aug 2024 22:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725056995; cv=fail; b=VBcKWOAX/nFTUmLHFkbpbhCPOYdemJH9oQ/tydGNtXrUgAp553AfwmjvHbZoIwfTF6PfrYzomglA67LpzFcsQL/yFWhrUMUNg5KKf01uO2oyISXkiItFxpgFiFsQpS/A3ubdCM10Z4N5PnvyZKXt+VuwbGEpe5D4VDjJ26tITxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725056995; c=relaxed/simple;
	bh=hmBjSAZEGVN4TYdG4CaKeEw9xz+lO2ew9QRPnimUa54=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BO3BKljWUK7CyQbHBc6mKug5ynsPR14YUytU+DZE/R7V42nOIeUhMx4f2G8YNifneKpHFwYh9UdiriM7HRgHoERq8mSBAjA9tz8rJAQdO7MdPeXGP0fwsbOWFCXInlrYxOHYRaiysPlPwRwKt2uHNVeB0xjtSZEy+2kpKhjpOKg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=brcVIV56; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Q85vuaqg; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47UMMUnr004044;
	Fri, 30 Aug 2024 22:29:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=GoDd3Vvw0olxHaOCVP9OMVVOWSX6s/h3L5eCSJMIZTA=; b=
	brcVIV56QmHJLvVHilXE8FQ3OQzZxsH3vPZ/ri7S2BITXTy8gVgR8/m6zuv+yLaP
	UKPqqlExw4HLElkcGvmIyv0m6rVPrNxEDAFqy7aYD2dWqjC0S+ld+E47FqFbwAGU
	pH6dmI1DV/Sf4iSapgqH0XXkRbG1AyO+D/m/KY8EgZBDzxlKpeg0Qeaf96/jXc+h
	Q/s1qaUgT/4fxk9iZyxYKDD0fVhqaWVYVgjJVeibFKE/P/e4h2pouDnj4nJTqF8h
	DUHxPJypFjyvLT/2cZocjzjMvx4thgOzEVVhZNF46VclrAQhI2c2YIYXsLz8iWBb
	gVKfpshR/csxDgMwC9SYKg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41bfgj0wkg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Aug 2024 22:29:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47ULj9dP009920;
	Fri, 30 Aug 2024 22:29:19 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2042.outbound.protection.outlook.com [104.47.55.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41894sjau8-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Aug 2024 22:29:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZbsVq35kPBUNTFpR2c5/5BXnOWSpfqVeoaHiiyy/RLZQzxfcMZg5+vJsHG38DbORZmNOFrbFxclORjZ4paRCcmsekBcYzh7WswDV7R60o53vC5VchpMT6wJGWFzyiWX5HMOwWZQUxwtzvEHZWPuBcBpksy1FUlhQv4EH/fOrQ4407Ssx0usccZMua6k/lveQ80ur50wuv1OivfJ3qFPLXhqZcrdYeqlw+Dcxcj8BIVFt4FaGdXKTLGyBwkY45pBSRVtD5dp4RFkvIouX09B2T46yaG/rrSI5KMqO5+0bA/+kg7VBQWijiXmFKtQg8QrsNz1Q5oDZy0DPOZo4BmJIhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GoDd3Vvw0olxHaOCVP9OMVVOWSX6s/h3L5eCSJMIZTA=;
 b=LQG1FUW2gOoapzFbybpKXsXfO0S0dl51jZO9mzY4Y6w49Y3iVNoyMX7iXPMUfq/Vlh7uHAp6JO/gDQ11F7I9ELXxhiwaJbt8Cm5e4wl6+1ngh3fccmrvAsbsq/PijLTpHkKohJTD7G5Q1GpPLEKe1vn0NHcbs0MhCAe5kSTbu+KEsYYxRCkUVmxFkCS7SkRZqdiRKxp0KE2VV58azta6VmOtiBGPYgFle74Z3FhGPYzvIJWJgjZ3MK6z1qnLhvfNsm3VUTs3iz9DqXJrzVrRH1tFQahhtZYvsfjXQe5ox+6qJ8IfS4p9/Ijgd0UCk8LLsXla+cIOEBNFqaqRoLpg1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GoDd3Vvw0olxHaOCVP9OMVVOWSX6s/h3L5eCSJMIZTA=;
 b=Q85vuaqgou/JfwGowLBeXRLqfe84MXClTBV6KlDhTrUySJnKlv541oSqInBjGpG5glB5WHCnEs2xZzyEEdxZV1kbfvUT7GlkcIvUhlyvqq5pUG0ahuXB1+r6VljJA2GhVbjXX1+QNj+m9tKdewQkNhaFXHQzd718OSSfNBWgZkk=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA0PR10MB6771.namprd10.prod.outlook.com (2603:10b6:208:43c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.19; Fri, 30 Aug
 2024 22:29:16 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%3]) with mapi id 15.20.7918.020; Fri, 30 Aug 2024
 22:29:16 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        wanpengli@tencent.com, vkuznets@redhat.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
        lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
        mtosatti@redhat.com, sudeep.holla@arm.com, cl@gentwo.org,
        misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: [PATCH v7 10/10] cpuidle/poll_state: limit POLL_IDLE_RELAX_COUNT on arm64
Date: Fri, 30 Aug 2024 15:28:44 -0700
Message-Id: <20240830222844.1601170-11-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240830222844.1601170-1-ankur.a.arora@oracle.com>
References: <20240830222844.1601170-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:303:8f::16) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA0PR10MB6771:EE_
X-MS-Office365-Filtering-Correlation-Id: c9ec3a50-945d-4d9f-0302-08dcc9432e93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?70pBO1WaLyjtDYN/SlJwrgn4+DNNfy+qlwLWvqCH8C/LPB/R1mzMgzQCmzpO?=
 =?us-ascii?Q?/w6tw+hTAH2JLLBuqAeyECIhUEHZn2P714jHa/i3baBkjip2Pc5qCYMLzHe3?=
 =?us-ascii?Q?Bn+fQ2nhqXtWFJX9c/iWfRqirRkB9IxsU3Kj/Plf6G6YL129ZAAKfRBLZOih?=
 =?us-ascii?Q?UPBKNbaWZ178NLGKcYJ7aZJIG3wI0uiN8/cmCFRTuZaVVVnBfcM2T+Sm3wMq?=
 =?us-ascii?Q?f9/87UMKwzEZh8HkDq5aPXcN0xboJPQGoVst30IUGHnvz/c+z+P6bZu4L8gX?=
 =?us-ascii?Q?UkszyYU6tv+jhDuk/KQv4C2Wr5q4yJS52UaHGGcEGFJNqgCZ1LEQAsC8UovJ?=
 =?us-ascii?Q?HK4WixSjb7eSUYsp7WASiqMlvoiTF4IE0l2HgwTkb97O36UImb+ptaZRgkXN?=
 =?us-ascii?Q?9JQF9aKS2WxzLDq+tTx0QX3HZ9gxaHQ8vlqeOI+EvC3mgvnVO7jcvvDhDAOo?=
 =?us-ascii?Q?aKUCiY+8BDyDYBT1NW8uuYD84g9R/zKaSZLJF5wejlRPgaHyP+spOoqMCssL?=
 =?us-ascii?Q?x/6EPFQBsz1t0A6kDr2DR3EGx2nUn3lr4WKbS5D77CxWSajlBFXRgkm5CvtO?=
 =?us-ascii?Q?TSMp9tWNOZMphjh1RLE8Ej1XPcZS1vGW7zHQqU08DS4xbd3dl05s1usEnElr?=
 =?us-ascii?Q?x3+QyEfSCsiR8FE6yQzXqvdNL0ZoyjOYiT5fCX8o9kOh/1d6ZffGD6g74bE5?=
 =?us-ascii?Q?zTCpxRe0ur9zqocSYdCMqzRHRQ3jlFhYW9tBC4VGHUHi71mmvqE9c2RbknsD?=
 =?us-ascii?Q?FdMZdKqW6RfeH9dYQYD/7VFTWCiR3Y/v4eR03ajkQosiKvI6oCm5oX5E6v+u?=
 =?us-ascii?Q?9MsdGwhwJN9IXNoT0uSJN0M/Pu8Wym+WXFGTx/VF4IeWq1kqAryLpBHycnbn?=
 =?us-ascii?Q?Pl3OMjFCdosU4TFgCp4vZSvTKvzsFuWxVXkd7JFlbUo9LuAAKK1qheLeI4QK?=
 =?us-ascii?Q?8LqERBCRc3/P/WDaKPFDpkoTxBPlawW037Mro3iaweV1yWjiyZE6Vsm9l230?=
 =?us-ascii?Q?YwtWSq/hAvmIMwGTCQSV3YAQJvwgswDXW08YsFqQH9cbFQwxkr24CEKAU3Zj?=
 =?us-ascii?Q?4uWjIAQkp+hz7FhZNHS8rDQ1CsgY+J4CrfU6PrfGyRgtpKMsTG6t0u2onbRq?=
 =?us-ascii?Q?bE4I4K0gyLlD4sDN5dXmZFnP74ISwvJdC7TqOaRDOy+QlbxnDoWSBPxIUDDB?=
 =?us-ascii?Q?jNMRKdz33gOIZ/54+bH6OiftYOTTqiVm8nURD+ktgR7mxskqE/dT8u25cq22?=
 =?us-ascii?Q?UaBFMfNqAS5IQYeCB56yA2/Q3F1+xUSD2N+VVfimXwcMUK+fw46RRpCtjW//?=
 =?us-ascii?Q?/mdmEo+ohllExSFibd4nCyhsyryD6m3cDQcjeG2lk4bZrQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?znMxNz5+VVKqyMlTSKuZSR2+iBziAilmTeiVN9K43w+6YuMlIEsGkXP24DL0?=
 =?us-ascii?Q?wKxtfDogYDjDslYt4CSroE/m7hfhXuoI8Z9BGqeLlsjX0WCJjITChtzEOjFQ?=
 =?us-ascii?Q?+i9yKyRrPTmMrKgHCqHzepYoA0I4Ob6oWsg6J3HKL2VY/tkDtnoQ+hJBP6mp?=
 =?us-ascii?Q?zqUsxRFysv32mv++OWBgdEKAeejtfTHBvVmjZz3ZCecV7+AUfYWYnawnVnZ5?=
 =?us-ascii?Q?pD82+Egwv00VaBiuOJTv5WbBraCwmUtwl4SSTdEu86PfKSbm+3tEK/Ek1RAM?=
 =?us-ascii?Q?sDOgL+wHytPomv00b7mmg/Z616sSoRLdlWkppzUwHwQCt62GNpBuo7DGmukC?=
 =?us-ascii?Q?NydUh5P53ASZLukPTqDHlha/MH7i3PvItMoxFCPLrOa93B73eKi3JTazRlFQ?=
 =?us-ascii?Q?F1yeixim0thYnFcCaIKMvVID4JztRrzI9Lh8BLaDoUXyv/yz+HBhMK6dgW9z?=
 =?us-ascii?Q?SWPC1yyh8rohfMni+b0Yqra30a9UER8zK6OHDvUKLhbgJX8VLI3Vu7NlR3D5?=
 =?us-ascii?Q?d1MpdHtp/uyaeekBhcU31yVGVE9Dpqzafs9P6wlFziBR6hYZo0x/IfJ/Vjds?=
 =?us-ascii?Q?92tL937OX3Q9Yy/4cZ+ixZ2V6A9UgrmXzZ4qt4Sr0RXxXLtsmSk8IxyU2ScA?=
 =?us-ascii?Q?rQM2lXhWFhEGFHIae957Y16gGu6sVNXlw/kD92MDEgIC/oOhSF7sRCoFjoEa?=
 =?us-ascii?Q?N+oOa0m8c/x7noERVOOCH/yV7RiYk4xGqDW76R41KA2PYlq7O6t/qydscpAJ?=
 =?us-ascii?Q?spAScjM4uiQmpnQtO7pFqCgctUDHUPvAtH84toPbdD2A8sQDFzY38+84kl2b?=
 =?us-ascii?Q?QyssAcDenCDVOtlQTgC9RTjhxh0AohNBgSJnYiC9sAAHo7VcTibflMwH92Xe?=
 =?us-ascii?Q?ZyuCOTXfMTfKP+cG8Vo/k/Czja+Sehj2+k+l1KvYmiT16KzfOyFZYOp9zccW?=
 =?us-ascii?Q?wa2U/o83h64KMzQnT/1+K5utEq/7BFWliqugmZBOjdhSZCw+TCfs6T+zpuzb?=
 =?us-ascii?Q?c/5tR1QBTAei+/HIGlV6kjzfDN1lmya36smsmLHBVxAD7K6C7SYRl4HmyfU5?=
 =?us-ascii?Q?6tGfAf0UPtLupcOnhA3EGx9GjvtkxYXWSQzRjzH6eK1LxYsjRnOId/Qwuq9Q?=
 =?us-ascii?Q?3dMVqmrQfYw25pKFaiR0khy6m3Z0e+k4OxNV3V0eGmPp0xurvzrxWAFakEXk?=
 =?us-ascii?Q?pVQ55nhH2E3u0B/y7xOJD6VJTJMt779Xg3anvFttrwwHOI6viUqAuFUd2C89?=
 =?us-ascii?Q?p+KO1YqASrAUHTP9+Pbc9v3Cm3zOqAJ68Uk2kwUE6vnJQ8/j+YIlg0KuS/K9?=
 =?us-ascii?Q?S72lFQgI2poXh0JjEEncCMS7RABJqrMrbnEUAA/SfsidcXIfCQ6VjdV39E58?=
 =?us-ascii?Q?3jR+aEfOmC9dd27756sM9O+gmXEqn78DDHLJDGdxRteEfML2SW5msZ6824JP?=
 =?us-ascii?Q?V62fQKQQQNwVgd2aFtuyJNVI3LRiIUjmOXkcVhA9MC1nzNx7+VYZYUkRfwJ5?=
 =?us-ascii?Q?DzjYrUthWHc75orhHnDjO+utx1qeNyX3HNKd4LDbZ8YIP4xHgQ7L3Yn1dC72?=
 =?us-ascii?Q?DKbsVkpfG+kSQmTJknAbrnuSIJsNGtZtMtVYFzB7q0ZpNtRr/p81MJ9TblFm?=
 =?us-ascii?Q?6g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	R4Zggu8y1bDzglZynSd16FLel3ZznnMWw3c1LpfTzqpal4EoALglDqSJoeihIEOPKO71ly0o407q6rMUfwnj4kQ2hNmSMO1HhsIYFBZk2rtKyJ+VpfpUXLpDny5sQ3uvOggwbsXRp0ROjuORA61eoIKd72LGDZwpm3XqAEbvvAd5kTBeorNM+ea5zc95hK9VjMY8uMUST574IcTW8Qf6wYBPZLDDjfX4N3ya1jTM0UVkixPyzT9nVYTE0Vka+lPlFCsjXPG6vV8097Qm0i9el/a5KlVuqEBYE2Affp2pACGt5nDPpJKFU73cO4SH8UpcIN3Rhg9xdOVp9eUk1FgZY+3fPrqyUFW0bkuQ1eJ3A24bSUA9DHD861caejKC2eOTh0oMZQURrsk0NCkLof3iWLZ9nEQ0ezUmSahvpwacOGJyFKHRpk11XqKEgoyAloaxzh1ZQlx8O4y3IPe3UPeztsL7lkKKKW2EG3rVmriEjFoxuaj1IAmiBGMBSgyLLQNRjIWUASDDhAM6CfjvtxFgYSVtyxjxj775UfMkmuplP2cNVsZtqBTEB214NmN4LT4LK0Y1opA72dx2c0VdEv7/NHh89I3UzXuvJdhDq2pny1I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9ec3a50-945d-4d9f-0302-08dcc9432e93
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 22:29:16.3933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EFX3x6X9v25kWlB+4xFBjD/sEnU0QJiTtyNXVc5tBCefw9lqaS3Bq/ZauMlhzQr3nmGehR3N6w+hOXqvhbXK/Zm/K9+bLq/nVZRcQte6pIg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6771
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-30_12,2024-08-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408300174
X-Proofpoint-GUID: IQSQa9jaSBL212KgZuZrHwbPI5wKn32u
X-Proofpoint-ORIG-GUID: IQSQa9jaSBL212KgZuZrHwbPI5wKn32u

smp_cond_load_relaxed(), in its generic polling variant, polls on
the loop condition waiting for it to change, eventually exiting the
loop if the time limit has been exceeded.

To limit the frequency of the relatively expensive time check it is
limited to once every POLL_IDLE_RELAX_COUNT iterations.

arm64, however uses an event based mechanism, where instead of
polling, we wait for store to a region.

Limit the POLL_IDLE_RELAX_COUNT to 1 for that case.

Suggested-by: Haris Okanovic <harisokn@amazon.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 drivers/cpuidle/poll_state.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
index fc1204426158..61df2395585e 100644
--- a/drivers/cpuidle/poll_state.c
+++ b/drivers/cpuidle/poll_state.c
@@ -8,7 +8,18 @@
 #include <linux/sched/clock.h>
 #include <linux/sched/idle.h>
 
+#ifdef CONFIG_ARM64
+/*
+ * POLL_IDLE_RELAX_COUNT determines how often we check for timeout
+ * while polling for TIF_NEED_RESCHED in thread_info->flags.
+ *
+ * Set this to a low value since arm64, instead of polling, uses a
+ * event based mechanism.
+ */
+#define POLL_IDLE_RELAX_COUNT	1
+#else
 #define POLL_IDLE_RELAX_COUNT	200
+#endif
 
 static int __cpuidle poll_idle(struct cpuidle_device *dev,
 			       struct cpuidle_driver *drv, int index)
-- 
2.43.5


