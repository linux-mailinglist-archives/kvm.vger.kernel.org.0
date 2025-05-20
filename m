Return-Path: <kvm+bounces-47145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 532C2ABDF0A
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 17:30:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A02D8162794
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 15:24:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B0872620E5;
	Tue, 20 May 2025 15:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QRJ2cEH8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gDMOQgSM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FA025FA29;
	Tue, 20 May 2025 15:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747754673; cv=fail; b=QcjhZUW6PCramEurp3zrfSBvmuL/CDd/5GXAdC/p1xfSnxgDmo1zW/b4U1F1HSYYI3VVgr/WvQZFaq02Zx6MQAqsWFxK+w3SZuPmRDbm0qPVaIfNX7t6wHwNgiQzeQFoLzt5D5owStm1svgkMqwOpV2q5ILbpy3QKqNQMGoAL1g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747754673; c=relaxed/simple;
	bh=+JkufXq4ZY5riYXFH/y7IU04PgPVvYVdHzN4MgYIoP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rfuTY6Gs/sfu8xDrnbTIVDI27bcWZkr1sdIbEVBD6nhdquv5ykIob57ImSjD7xxIAIT7eZN1owHO54pbVGQUs6AY2RWHYpP84z3IbsfSPN5HRTZwoPEJu3JF1Bron+JY+9wI/UDQRDeauAf0NcEP48FZMN7XBH4MWDWYUA0zH5c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QRJ2cEH8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gDMOQgSM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54KEONln020012;
	Tue, 20 May 2025 15:24:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=y6Mwnl603OVZkBI5vb
	8WPJrDKTtl8d2+3qERxchfmOc=; b=QRJ2cEH8otLg7zx6BizP3EiMIZF2WF88By
	gQInr/pHBvwCYgpYVhj67keAK54PY+rtCAr8vqWG6wirgS+gICDzfD7MKb64sfos
	4uNAKTt6h/uZdd/uElHlFXeUB+mK2xVYdiGJWa0f11E6jsdkOcWgfDJ7RLUUQwMI
	FUCiEZJR3oD7jX98zMehFyDpnlF5sf20UfE8PuIglWQpqb0Pzdb0OuOWrYd4gKtb
	Ai2VBmfWgqLEuB1Et1gLVSLRJiZTrk/DdxtEC/S91lJpN/hFaBWIDMEmq0B77PTU
	5jgxhOIqDqXdd6KbcxL4yFU/zivyeAtzMbfc4+0Yrg2q90Yllf5w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46rufdr6ny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 15:24:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54KFGqu5000896;
	Tue, 20 May 2025 15:24:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46pgw86d28-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 15:24:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ex0ELsxDwX4nU8h3vL8z8/0zKYA5U4g471p0R8PXcQw1je/64tCfaqxegUSxekjuPkb1Lb9IdPHAj6sPhdL4rwSkokFLmbroLoqhoACJuPBnCKAlUEfNR3TgkpTO2MSUy1y4gdZ1hdoAFnf9anFJqK5hPIKtRlm16dBZqQTSD5xrNmUotX5KCYYDi3DKy9+V7s5Tm7DvIuqqfU8lEKJFuIhsQWKrS6p/pssYy7VIutbalF/8j6nVx6U3f62aqaZt2dHj7uctBxi4wFlXvrC9RQCQ6enA7dVZh9YU0eGsdGf/UY50luMzvk3PuwBUgHJLTZxbhlzczuQp1jac4huk2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y6Mwnl603OVZkBI5vb8WPJrDKTtl8d2+3qERxchfmOc=;
 b=oFG46rA5LnZcYNkkboipQiZ7sxwGM4RzKegdyFunLHChcwYOvcC3pF+lLSZaAGgpDBA9ptpeK6Ceh2XAtRVbmmCG4nJb5srUN1PIBVlhC6BCy4mzFfc3Wv2e0V5sUMoF1RfYwXW8LdVpGQHxiZpF4qgwOXg+4qg/9e9lhNxJZ9Yl+CQ3cUFo4f2pQ+aUiS+mIBssa6myephf9Fn3jhbVHVMJbS/mZrOCXCRceE/JZN7fAC9zGL0eJmPYvWwlqm31N29QZsOJz0KfGbtyovSWDpWpxMse7wdDlO2EzvyZz+GeWo6kG/v3ZBzNlqwRqDFSTvLygt4CrhYPjekmmjUpVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y6Mwnl603OVZkBI5vb8WPJrDKTtl8d2+3qERxchfmOc=;
 b=gDMOQgSMBei7tNpYnonv6OCSnEVLjVUTe18zdgpnPz3RB9JwHYk/wNOCbwZenTkZ6x+oU13Mc8HRWnybjVV9Alb9nxHSqc0qpXnI2PTo2pS0191ybB/7uR1FNge27vyTclUUHqNS3VRSI5uUKDtCnTax3m8cvWOYuGYvUPBHpWs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB5646.namprd10.prod.outlook.com (2603:10b6:a03:3d0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Tue, 20 May
 2025 15:24:12 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 15:24:12 +0000
Date: Tue, 20 May 2025 16:24:10 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Houghton <jthoughton@google.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>,
        Yang Shi <yang@os.amperecomputing.com>,
        David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY
Message-ID: <cb0894b6-3c41-4850-a077-2d18f5547d2e@lucifer.local>
References: <20250519145657.178365-1-lorenzo.stoakes@oracle.com>
 <20250520171009.49b2bd1b@p-imbrenda>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250520171009.49b2bd1b@p-imbrenda>
X-ClientProxiedBy: LO4P265CA0124.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB5646:EE_
X-MS-Office365-Filtering-Correlation-Id: 28237671-93d0-4302-c2e8-08dd97b25fc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6Sm2jAFPsp4yddt+fci1thcFFob62HqaN6mj8HqTTTRY1iacx3Vlq39IB5h3?=
 =?us-ascii?Q?selhgNVlv/wrKkcxKHpMXbnRVrcxbN2t48vE6k5xaWryW0sfSLz59QD711d1?=
 =?us-ascii?Q?TG0NbpBJh+oqIBdbdkqcfSoLwEhr3Tw5FAsq6K7TX79fcjLegC+akuqs+xqp?=
 =?us-ascii?Q?SyM0Kw8w49+ld4MPvX/TZCd2Q6iPS9SYw66SlMbegrqFgFx/DLX01bOs9iMR?=
 =?us-ascii?Q?jldor3T1oFQLg33E9dP90LqNW/RN3ZFlDvYA7qvIKDjB5VmeyguUSrhfzLy8?=
 =?us-ascii?Q?dNMjBSHEbAxIi4V3vdf2O13cXNRmmLg642Pb0nTnR3hNEl2yH2NR2WHGODqq?=
 =?us-ascii?Q?1YyCmkjgcJIAPlET7Zgg/96nWeSD7jizPgYURcny6kWEIeHWboLEUVgtKv9b?=
 =?us-ascii?Q?IVx4dLt1MuY3N8heJPzBm0DC7ZICgdk9aNLlJZsBl7HebrskSiXna+9bAScc?=
 =?us-ascii?Q?b6NfJ3kuJL8vwvHk/O+nLU9P/PbCADFrR7vmumCDp7SLnnLVYpp0DswTKo1/?=
 =?us-ascii?Q?PYeTSfY1cqX2c4v6iqnlI2EmFHp3LMoQ4ea10eVcVafN/o9HgcX7u7JQHrqx?=
 =?us-ascii?Q?15nYE0059SZJK64dJQ8OPV75ZQ6BPbvqnp5X4M0xL1tbHT0NnCh6V7CRRhSD?=
 =?us-ascii?Q?qqcL7yFPo/OIBkwCf9JcbCq7LSVGyRtUjYVkEVXzmtQXkL0b2Jpm50NiPXOW?=
 =?us-ascii?Q?VLde+CU8C07Q3lqq8DB/RaqJJU5orfCBYKko7VJoc9mr0C57zivpWG6UBVQY?=
 =?us-ascii?Q?9lLc0eO+uYJ3YyZIYHzER5/1DMbqr8gq/r04WZzMlvTG4Qz6vFMNxZbp524J?=
 =?us-ascii?Q?a1D09H4hBWPv7qHHrZFgKL/Dl/Y+KaU2q7d33RRXJEz4HuOxvUU2CvnDzYsF?=
 =?us-ascii?Q?x6MqEPlaXuVYjXTzfOKPYIqb8k0ZQpelJt0p4x1iOZf6w8U7U0K3FY3HQYIH?=
 =?us-ascii?Q?vc52uP+kn3/g1iBYJ8PU7pSxyZRr49qPp4hgfAWRYOokCtij/8EJoCgQIVIA?=
 =?us-ascii?Q?0bsxn8+zPz6weUsTaFI3VmlI66J1K1hcX0NgQtbmeodfwOlxKPmEFC87Ybha?=
 =?us-ascii?Q?NdU0XCtrk6zGvwqZr9B1kSdIKXTqMY1PuqafnujkWt7gF1Y9G34/vWnIaZKp?=
 =?us-ascii?Q?hkYS3ea+IsF9a6Csbeh+rgB3VlmddPKua9uIoKryB3X1TzrR4DtKXSPpT8/z?=
 =?us-ascii?Q?R/6j88LKSAEvqSKbEX2eyhtTRX2/L6oyYuK66XpJ97wECLEXUzie/8nvQBix?=
 =?us-ascii?Q?HtbIyCBwn7uJi8QEXArgtgYYlspbzXppTPCwEVg5aoNWxHvhZrE4B8Z0gU/9?=
 =?us-ascii?Q?RdaVtjGMoA+iWyR2aSXw3rkz7BnxPhfyAsGV29mASvsQifBOnfctdDAOcoKg?=
 =?us-ascii?Q?ySQZkY41urA5C01PvgID4pihsOjm?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s7LCXv/4xeWUYvMJQmPS7JHa0T/zTk2+apux27EbGs0Du0yhVdPlJlhZiztK?=
 =?us-ascii?Q?zebLtyYuiql+jChs+nNBqmimtYaM5dbFsB8ZS1moFIgj9FWUDbSouPaMBY8C?=
 =?us-ascii?Q?IGQvppXMEDRl/Vata3YLgu/L6+1QMi1hqKTsXJa8UpshQ+4Kgk9MnQmXYaoQ?=
 =?us-ascii?Q?kk/tO+/W14IQYIfv3z8gvw2AEnOW04Mw03TtpH8odegLMNc7JRnq2rz/ewhe?=
 =?us-ascii?Q?l86UTuBhqv0016jQdkncVSj7kpw6Z2FQQ65842BZabF0g31p5UxZzmxaP00H?=
 =?us-ascii?Q?YHACwAA6c46d32HMv3p/o8Zd9fP258/RsmedEseO4LPaJNv2HCTUZj4FHcrZ?=
 =?us-ascii?Q?vxL26EGzZjFbbc5Ccm7gTJNdVe56pCKysECFe9fD2fLLTAYKLJS9auLUqU/5?=
 =?us-ascii?Q?ttKfy8au6xUpuNPXuX9eAAa0S7qgTysdudA+zmRilz1cZNqkgn0IM92SsQWX?=
 =?us-ascii?Q?7ZAabcYHb5COdAGcA6R1A7NlRQG9VTkYeaedDGwdY3OYeAUjEFSuxxY4P6do?=
 =?us-ascii?Q?UIM+8SWG/kygm41QRrp95tLY0+Srdu1SXeMBzIIiEmOHcWwc5Vao2Z7lmobT?=
 =?us-ascii?Q?Xv9NR+cEOOWB+RlzFQbdM1Lz3Gr24eIP/w004MRZUz4Y9DatCzJlbfa6tsMY?=
 =?us-ascii?Q?IifYBmWKPoAXmM6jJGx3AkTh+iAu7JTTR7mAkca8gtgS4UaBVpBusYo/V5t/?=
 =?us-ascii?Q?lD3Q+uK/77uD1dijJeM9j5K1V0IoXGvSPr/w6XXBkSOAYZiixnQbAd1muad5?=
 =?us-ascii?Q?YGgTTEJd9+3fkGY+kEeym4wjTx27fWVodph6X7mFKZEmYVwYXxYnvIF5M4UQ?=
 =?us-ascii?Q?5/dFMJq4b7IjgfCUyuFDLQg86kOc98qKyFemlvhxHMy+Ehg0/Lk2lglaw3JB?=
 =?us-ascii?Q?2+6xYQx6AzTCJIP7e3r6YgQOqDo/9c3nXUxDYlU8WfeZ3rBn9wz46/rKQGCT?=
 =?us-ascii?Q?2NcTMSbCpm/EHaGXWdN7yVLYztN7dIMUkgfdogBqKFKtFi/SXZ+lYjN3hysR?=
 =?us-ascii?Q?HdedrG15bQ/oOC+ifTiWP4m5w4DKePUvNDSmHYbH0pKToAl1nSuWgz+jaND9?=
 =?us-ascii?Q?YLdga0f+2SSj5PF8xa9fwKmkznhTpUviz6WpK1sQYUdGFnsjCLcqA/A82giw?=
 =?us-ascii?Q?qDnnOffjR8bdWXENP8nuzOjIHZGv9B8iSbL+HZSM/F2IVm4ryTw9n5uUFn/c?=
 =?us-ascii?Q?Ov2BnDJfQNPPdMGgsUBJoYYqjsHxk+7QkSc0UksTMhAIlJFIsbvxKgSjNBAw?=
 =?us-ascii?Q?W1CizKP1lReslncC2fDQbsnCxtMKxFPyJSV2QiI0J2N1Ijrxf4bqaAonYYxG?=
 =?us-ascii?Q?J0or3ZBC8Me3SXru1oA79Ws3NCG60hEZ6DJMKwy89JFtn1IFCvt0QgM4wH6F?=
 =?us-ascii?Q?pEBzKjp9B/evydInfVbvqjMmzF/NRnII3UQ6fhtIOD3gE+WAUzXSpT4jefPH?=
 =?us-ascii?Q?G/GOO22Xgt2n62V88AhjPVAetkYGorPUOlfYXH9h7yQSc9Ut1rCArkIaUE3+?=
 =?us-ascii?Q?qymC88VOL10zfRL4QC0fiVb+z0nA/8+cMze0phKAWRRJ+80kcXZuBlARKnDe?=
 =?us-ascii?Q?gjjysJUPmnorKk9WWMYRYHNvZoiJZRsJChQ4AyCPw5Lv6RVd7iXrRIBJvLrX?=
 =?us-ascii?Q?bw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cVnXgAkx5aKYhGEKke1n5+58N/GBLFH5cKPTn9klUpaLlTBxsQq8861cVdP4Ig5kwnGlQUOlzac/QFYH8i9PowkGSU8N3xvmB5hh5sQeHp8NYQhuG3Z35el7NcBjmOEgOx1k/LYBv6pcQBCPpos1kTBe+CAf1rmCoW6RajSsPUjnQT2aeTDP2W44ZkoKCDJLub+lem5cmIn0qV7qxUjoDd2jQug6xrWosI2wZxJgnhR0Y9bOT3PRCWeFc2scC6j3SD/gTfaSLIU0SIwxfJcXLo/namuPSkw4fIBgBoWxrpXgh8YMuBpvzX8s8zLikZsf4q4nAV6wltGghu5qkGSJjPYSqeHV7cYS3iOFSue+vKFsZNwIxkPuInMA6093byE2C0IzKOWfiQnSHiwm6R0fEQcVHXqcl5VCv0ajueDZhyOoB2F6/EKQ6T0xEkY7qvMuzLXA/7Iu+0byJEby68KMvVo66C78VTx5dbO65ugw7Mzjd/2cUpYukqos28YAW4qxamY/4DOXRihOaYikY9t3kYidPYBUdScuCa7vVqAvtYkxLcpcTBzSkdV29puE7Qr0f80UQE9Ao3wSWKM0XS8Byn85yjXGiAunQ5NVdmTBBQo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28237671-93d0-4302-c2e8-08dd97b25fc4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 15:24:12.4034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +99ZVW+hVm6nLkJ5bX6955uOBhPj9jIsLfMjUBRdY3nUXB3UvzMpHOPynb59/4YqPdWw9WOn+D1aNtMT/rPyzpp8sLqIsKE1+IjoR2WClcI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5646
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_06,2025-05-20_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505200125
X-Proofpoint-GUID: rUtZaIN0jcvaFy115QkBDx1Yx9QQYB15
X-Proofpoint-ORIG-GUID: rUtZaIN0jcvaFy115QkBDx1Yx9QQYB15
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDEyNSBTYWx0ZWRfXwW26WJRs715W TTYWtXZetc8qCTAAE9Z3mKC5UBqL0JHnk2QIYAZ7EtC9hjeOeX4sBDz2YmgvkhmSmqbdviX89w6 FeN2WoiXjDIVkbQbFijFjYEwu/NXuxrPdZax/QdqPdjVA7jqdJ8AbSW7hmYKqaLgdpYXiNpkz01
 WEcEHLvIOXQr5XYKi6Pspu+BxL9fiI2WslltCp15dt+WIHkl6dNAob2dZSHUJ32FbQqMJWHd6rQ wHPbEc2dbE94NX7qt7ZsLQprMjcbo8zOKSMOaN0g5cdwIlv/lIghVXgh5f9GI+Vaa6Uwc5hwOw7 sg1WL3d07qtNhaazsFSsk+RVst0QC2xt6zmh7bomLJdPSgMrMAFTteFjPWJMUbh2zsYsMWwVrjQ
 pKg9VLv/1j9+K8J2ncF5RJqKDiPlxpm2FBMQlK6fOwaRNiy6MwhW3TJDy/FIjccpFj3+66LX
X-Authority-Analysis: v=2.4 cv=c/SrQQ9l c=1 sm=1 tr=0 ts=682c9e9f b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8 a=TAZUD9gdAAAA:8 a=VnNF1IyMAAAA:8 a=vzhER2c_AAAA:8 a=20KFwNOVAAAA:8 a=tigQPNLc1hilJ32vbdMA:9 a=CjuIK1q_8ugA:10
 a=f1lSKsbWiCfrRWj5-Iac:22 a=0YTRHmU2iG2pZC6F1fw2:22 cc=ntf awl=host:14695

On Tue, May 20, 2025 at 05:10:09PM +0200, Claudio Imbrenda wrote:
> On Mon, 19 May 2025 15:56:57 +0100
> Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> > The enum type prot_type declared in arch/s390/kvm/gaccess.c declares an
> > unfortunate identifier within it - PROT_NONE.
> >
> > This clashes with the protection bit define from the uapi for mmap()
> > declared in include/uapi/asm-generic/mman-common.h, which is indeed what
> > those casually reading this code would assume this to refer to.
> >
> > This means that any changes which subsequently alter headers in any way
> > which results in the uapi header being imported here will cause build
> > errors.
> >
> > Resolve the issue by renaming PROT_NONE to PROT_TYPE_DUMMY.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Suggested-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
> > Fixes: b3cefd6bf16e ("KVM: s390: Pass initialized arg even if unused")
> > Cc: stable@vger.kernel.org
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/oe-kbuild-all/202505140943.IgHDa9s7-lkp@intel.com/
> > Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> > Acked-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
> > Acked-by: Yang Shi <yang@os.amperecomputing.com>
> > Reviewed-by: David Hildenbrand <david@redhat.com>
> > Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
>
> if you had put me in CC, you would have gotten this yesterday already:
>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Thanks and apologies for not cc-ing you, clearly my mistake.

Though I would suggest your level of grumpiness here is a little over the
top under the circumstances :) we maintainers must scale our grumpiness
accordingly...

>
> > ---
> > Separated out from [0] as problem found in other patch in series.
> >
> > [0]: https://lore.kernel.org/all/cover.1747338438.git.lorenzo.stoakes@oracle.com/
> >
> >  arch/s390/kvm/gaccess.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> > index f6fded15633a..4e5654ad1604 100644
> > --- a/arch/s390/kvm/gaccess.c
> > +++ b/arch/s390/kvm/gaccess.c
> > @@ -318,7 +318,7 @@ enum prot_type {
> >  	PROT_TYPE_DAT  = 3,
> >  	PROT_TYPE_IEP  = 4,
> >  	/* Dummy value for passing an initialized value when code != PGM_PROTECTION */
> > -	PROT_NONE,
> > +	PROT_TYPE_DUMMY,
> >  };
> >
> >  static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva, u8 ar,
> > @@ -334,7 +334,7 @@ static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva,
> >  	switch (code) {
> >  	case PGM_PROTECTION:
> >  		switch (prot) {
> > -		case PROT_NONE:
> > +		case PROT_TYPE_DUMMY:
> >  			/* We should never get here, acts like termination */
> >  			WARN_ON_ONCE(1);
> >  			break;
> > @@ -804,7 +804,7 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
> >  			gpa = kvm_s390_real_to_abs(vcpu, ga);
> >  			if (!kvm_is_gpa_in_memslot(vcpu->kvm, gpa)) {
> >  				rc = PGM_ADDRESSING;
> > -				prot = PROT_NONE;
> > +				prot = PROT_TYPE_DUMMY;
> >  			}
> >  		}
> >  		if (rc)
> > @@ -962,7 +962,7 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
> >  		if (rc == PGM_PROTECTION)
> >  			prot = PROT_TYPE_KEYC;
> >  		else
> > -			prot = PROT_NONE;
> > +			prot = PROT_TYPE_DUMMY;
> >  		rc = trans_exc_ending(vcpu, rc, ga, ar, mode, prot, terminate);
> >  	}
> >  out_unlock:
> > --
> > 2.49.0
> >
>

