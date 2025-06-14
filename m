Return-Path: <kvm+bounces-49556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3016FAD9A33
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 07:24:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 86B797AC87D
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 05:22:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB69F1DE3AA;
	Sat, 14 Jun 2025 05:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aSywCzHV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SWm6VzZh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB692E11DB;
	Sat, 14 Jun 2025 05:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749878641; cv=fail; b=SVzY9WWMMBH6jmC4sqw3K+sagPPkSC2toqTbw22kBZ2Q78M4UcQ4Ac22M7T9zypCio5Wg0FkjDtgSzjkKN3z/nKM3expR6dLGxHHtBm70Hy6bcSaJrybstxeVGTrPRLBqBug+Z1kkYwxxZwusOPll6LJvOFDhRPnA9lTs2YnJqM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749878641; c=relaxed/simple;
	bh=Cfd3D7/DypdJaG0mCQFhdneCmZiD8dEhZR4UX1d8z9U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mPm3O7xLnN73SyvkUn5YBGWqkyqk8wnXL6im7I3ZraZEJ2/6WWEXHnW/NAYP3e8YK7ER0Fo195dOP5qxizqg//6otroOA61NWAUb638b0ZgJEJQpz9rwP+QKWyehk736onVEFEE8noPw75ZJthnREzgVJkC1f5Zx40Lbwb132Y4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aSywCzHV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SWm6VzZh; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55E2xAte032348;
	Sat, 14 Jun 2025 05:23:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ZbJ3v/d2kJNILehS/o
	SVAV+VqWsxdHHlpmOafdPngCk=; b=aSywCzHVISmG1VKCbtBNIElCdQijlxAPBF
	LoI2mnT1LiaImH/21kTkYTKWH/cnSadRUSCNmiIcSmtfy+4eizIixGR+dA0V55/M
	9vefWb/UkQvdTD7BMuF9C0d1JdUtd8m1n29JCljCHunrtgu6tHzi9jqU6HI4Ehzr
	2QuN2jejFb04ivht6vCeYcKUFmyBU3pwMTT6P4wvmEJA3I0Nqvqv6eWAl5waTkeP
	rWy70oRzqqyR5mJs56zy7QR4cXR3IkTFvcCNdtK6c9bzHf9HsOUGiKyOYClkZjyl
	QtKiv3X4LRzPwnAYTx/0rUmWKYoNL8ACYctkO0TT8/pIvf1Tbong==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4790pvg1x3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Jun 2025 05:23:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55E1XeYT000824;
	Sat, 14 Jun 2025 05:23:38 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04on2064.outbound.protection.outlook.com [40.107.101.64])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yh6axnb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Jun 2025 05:23:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mDhjDcEXnBrhrCEJuYxRkvLJYhXoJDfFxLElasI2g1ur84fpq+V2VVy4bzSjbRwAoGP0CRR1Zpk9cu5hoorcvY6Jm/i+JpW1mI0bY/p4MlhZkTM7GyJ9dOCRtyem6RRxgpPTFTBjJ4G5RrkNO5vpDIFY3Zz8kSufIlUgN0urdgWumaXdymsKiLqBg3Ysjgo8fRBCrvHwbdSaguon4kIZNS3YYA3gdI9bzf1zBU3/lFAtonSSHRKOX8Jaa1AeVjylstIcYrRD8w3yLxM7co+2v40sexJqyzuCoWiDgQ4NYA7JYvVtvPaA1mS0iGAKXYVUC3h1e33gJmiC4mPdsTtbLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZbJ3v/d2kJNILehS/oSVAV+VqWsxdHHlpmOafdPngCk=;
 b=iMD5VWMfTcu5ayvXhhQDT7nM4ZvPm6vAKJ+haBKC38e1rfKseZenccUabVBUfU8yqPf4XZHmTl0aBgALNXSIqkPo01PEoYrjs24I4E8NebZbs43ytSla6KWJQarpOzcU8QR1zP+ibEwht5UvqPfkWVuKJJq6fwEIX8NAWeMg1CmMSqZbrE38cmsa/eeDDt8DA2B7FWLC1lZt1mt09zoBdG6FsD8mEQYEWGZfGUhdTBNlMFD7VzgB6xhD40Ma2q3jufRN9VybtkGCFo81lFQOAGAdQNKwNHDgOrHCha/ACYAo+gNb6+Mdp7LV161mFHCRFdFpoDeXU12ZJCxUgVncPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZbJ3v/d2kJNILehS/oSVAV+VqWsxdHHlpmOafdPngCk=;
 b=SWm6VzZh4oEuldjsb2/3WApHJkKbBMf2YwIiZV7LTcun1TYzMcStKvGyL0y9IKQ1T0Fj81djPQFxI46UUXXTWkGGHMy19g5Cslm9W4N8nAZFrNeusBo8UxH6wZbBi1o29yVzzl1JQW+uL6Vr8UoZifKcqf5sG6mMEFLVqzztO+c=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.30; Sat, 14 Jun
 2025 05:23:34 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%6]) with mapi id 15.20.8835.018; Sat, 14 Jun 2025
 05:23:34 +0000
Date: Sat, 14 Jun 2025 01:23:30 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>, Zi Yan <ziy@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, Alex Mastro <amastro@fb.com>,
        David Hildenbrand <david@redhat.com>, Nico Pache <npache@redhat.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>
Subject: Re: [PATCH 3/5] mm: Rename __thp_get_unmapped_area to
 mm_get_unmapped_area_aligned
Message-ID: <77g4gj2l3w7osk2rsbrldgoxsnyqo4mq2ciltcb3exm5xtbjjk@wiz6qgzwhcjl>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Alex Williamson <alex.williamson@redhat.com>, Zi Yan <ziy@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>, 
	Nico Pache <npache@redhat.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-4-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613134111.469884-4-peterx@redhat.com>
User-Agent: NeoMutt/20250404
X-ClientProxiedBy: YT1PR01CA0101.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::10) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH0PR10MB4422:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ffdfa56-1512-4624-0edd-08ddab039b95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?df8KvcWBd+jIIwaL9E+YhMJ1vSyFpHsCSAnzpIzj/gyrofS4URz2pEz86OEH?=
 =?us-ascii?Q?U6ouiZaMKKsitntUJsHXO0gozY0mafxFDtrqMEzXcJE0M1KBnLwvHEdLi6/v?=
 =?us-ascii?Q?6VsROiXTRALNKXEFnA9/s/Qt3AOoh4FJsCZN52nVLEYZIXpkq/673c0BXD2V?=
 =?us-ascii?Q?y0CaD/r7ZNp0zD7QV/vu9/dmKantLu/Y1dzBlWFMZ9iuigKUYHGdZAWaouOu?=
 =?us-ascii?Q?XZFb6khh7+vsULAfFDxzqrtkpeH3pFovxSVoiuZ5IF13R9A9x8B/xyvl0Nuc?=
 =?us-ascii?Q?PEje2NA7Z2bzbdESvrzLxhaPIY3lmti/eGpxgzflrtdvm3/0Ly+4ZkaR+bmd?=
 =?us-ascii?Q?PbibaiMMyKnhJWFqe2VvPs+BivEU3I2iyCXNysZDiCz0BMpACiDCZWmsFF3r?=
 =?us-ascii?Q?+4kOb7BRSx9tbDcInd9WleiEFKhIUkJVwu09WwVouazvRT08KxgF5bhJ7Jzs?=
 =?us-ascii?Q?RYLIRx8VnZaBKQS905OwucSopj6Ky7KCcvj3SorQzzTnFfLCvDLQzZp5nL6c?=
 =?us-ascii?Q?7hlR3zoPrvKLbv5N4KofCa0FnuKtPp+njhjN8AcTNfQFuaQC2lgYzYaJjxWJ?=
 =?us-ascii?Q?GiFo8UfYmIPV3Se5n8EzBk9jp4tZ1YJP0PLIrRbjBSoweHO+jL/AvMGbi6B/?=
 =?us-ascii?Q?MQkonG3hnyQV1+L0NVOZtJDWTBqN6AnD4pE5dT7Ji67yBtLPYLaw62SY8qPc?=
 =?us-ascii?Q?msA95/t8eNOq0bwvoi4HTX7wAR3J7wg8VY/e9vQdeof/+i0fvRoKZ3enPfGh?=
 =?us-ascii?Q?b6veEnZBW7Pij23CjzpHDHik+UQBVJqfTFpspch5FduEnTA+aZXR6N7lnlG/?=
 =?us-ascii?Q?IREduKhryZ1gfIlcHfUKCPLDg6IbrRVTzGqIskblSXEDvxkVeTe7TmJ5NRIX?=
 =?us-ascii?Q?FQH56uzlDAlBTX3PMqFqSav2/vt8X6oCCKBjY6/kVcgSc8hxqcyTzwh9ZVTv?=
 =?us-ascii?Q?pcBebfWlOJDCi9yThFbDPl2zybhApMSm0AmFGrOaVslXIzzpr2suhc7Po1Ou?=
 =?us-ascii?Q?yO7W7h2KYt1phkUjt1KnkeXG8Q5+LeutvOGkKRBbVM7WixTymr8mA5eKfR+j?=
 =?us-ascii?Q?USq4oj1kT/sB1I9MMLBcAVI1OhUuJbp/bzXXCWXmnW55b60DQWZlVJYgT459?=
 =?us-ascii?Q?PQXYfJBQHu1+nJOdS62x8HhvJkb0hQOHDE0IpzGt8HtfS6JUglsh7dk461p5?=
 =?us-ascii?Q?wBJ04PU2UbR/S1PovAYu3dbsvSm4EmpsiXxUDSp9T6Ri1/xpNXyArSBiFd1e?=
 =?us-ascii?Q?L09hZ323UTkzxSoYKOthTw4s/I5LnJWmz1Kzs8nn4NjUbo02t9PkcLkKR4/G?=
 =?us-ascii?Q?3rfJMc9xGlYniXeP/Chj53zGDmupYlyscS33mDI+fV2wOwPKgxxx+adylRw3?=
 =?us-ascii?Q?AHSHYhwTmgd0Cj3X4fpQo/xm78fS0R1+fx6TxE+V8YSuu/TUg7p37psQmmnq?=
 =?us-ascii?Q?z8kHfytEuZU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OCwak1Sh84ZPZVQUx+Jw4KcsNKYbbBj0c7w2uhWMbPczhEMDww5xwRU4R2JB?=
 =?us-ascii?Q?BS0t2XpyjLenxkLUUSuqMXKBVJKC6UbtVFoBAYA8ovrfBb2zYc/3qPamyWoi?=
 =?us-ascii?Q?ID1DE5RhVfb2009pED0yrmcdNV2BD0nacJEFG7Zdzq8tyGcWby3KYHkRGc73?=
 =?us-ascii?Q?QrFxa0KOB2x7cdxO27IV34NYZHH+cqN+0ba4a4yvwnHUG6wm9oIN5T3BSaaN?=
 =?us-ascii?Q?aSzhjnR5R5gPb8hz/Ydxgu5R2VrFle4NS06+trG03YkmW/0XbviSE2XK3D8v?=
 =?us-ascii?Q?NtW9cYp6NKE415vzZ+XGPEwzPJVLWrkTSBI9JeRtaCIccJGsg3qRHfIBq0kn?=
 =?us-ascii?Q?ZT7RYDtE9FmeYwZtaSstnym7QnYlSlJRMULb9+tRjEmy4lqD3IaMXvyQSwA7?=
 =?us-ascii?Q?KRHO2XlA2Qc7qsISRikerHU8U0WF+IGkx3dtwE1krfBVActxtHAq414n8Oz7?=
 =?us-ascii?Q?3D9fNJyLOmpCIKV6K1nYEuZEEesmno8ao8L4Acc5xfdZ6lXJnjyHXkuGiFZZ?=
 =?us-ascii?Q?UWm6hUWfe0LmcaGMXXvRcQC5sRd2vDPgWDECMs3qoZ9HMRregK3ImPUMej3O?=
 =?us-ascii?Q?CPVkhwZrHzc3H9uSfCPF/6vEVJ6yl6Yqa/lZYsKw5wedU5dj55rxqwWW1ZMw?=
 =?us-ascii?Q?2qLsbSu7QyvArlSnnRffMrwzXUCvsSa5xs/EZHwZOW0vDKqu7tLV0bYT5koa?=
 =?us-ascii?Q?qB9KO6IrluYpjKXAePJPKHKYkIsdJwQafOyoerGE9Q+Ik/qJP3P9T22+04zg?=
 =?us-ascii?Q?NDkwAsua2rT2+3xNz9hNZ9jd7lBe7/uhP61hh1g8avf/wgS1YyFKaIRE5qOZ?=
 =?us-ascii?Q?EvbEUMVwKK1dTUVNXJrkb7SeAC5MSSGsY+v+pdAtB+nX5/vqjmCLX5fPzWvf?=
 =?us-ascii?Q?AbBRb7wMLSyBdaLdtrkPXmNsM+p24wyW4e8/kPRPtOhHPNYc4P4vg/mzmMpq?=
 =?us-ascii?Q?n+O8jc1smBP8AMCPB7xU9T/wyhdAvfi+INScWlUrHcWEnjABHMnxAAr7zkiU?=
 =?us-ascii?Q?YJFSctw4o77FAcHvN20p7rqpHiE0AOdDFTW2eMIe2qgpQsKUv0JbaEqjAllY?=
 =?us-ascii?Q?8vIPxkzLr8gRNDTBWAe/LY4NUtmUcS68jAMI1ZVzPU9p3jcLpB6NkVhN50s4?=
 =?us-ascii?Q?6bvgKV8bvSeQiKkVAA+5TET4/zxEGeXPqw7YEgGybz+aLc0R0vjH9qw/zLnz?=
 =?us-ascii?Q?W4+A0BJMxSQB9RFgdcGuHnMksw/RWRd3fwuxYFA4+6CejK4N6B0hUwGwaYQK?=
 =?us-ascii?Q?BoOMvFYd4dY7KbdgKeOtzNxzys+rGyPR3WNVL+O83pE5lJIEgZWxWxrT/VwO?=
 =?us-ascii?Q?oq3YbB4Hyct4Aeh4bbhzVZPXDh8fLQgym1ieeNgb6tezkXs00SqXHtlHV1MY?=
 =?us-ascii?Q?AVH98v36O/V7c0LG8ktwm4wPzVoTt8NHqEwmP8fUbQODfxHgKrtdwcCZUC3a?=
 =?us-ascii?Q?IajCLo0kWwOuCCgKqQkpftZib+2zXOp45AKF8OgS1QYdUrFheuFMkf36Pj32?=
 =?us-ascii?Q?AyrI3OX6qyYon8j3zb8Ja6O+eoFj7orAZaPOR2gsuwjNQW989dqWiQrLevMz?=
 =?us-ascii?Q?XoghG4nJ1BAOq5lj2+DdSbipiQGhTcHRkqe2yBb+?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EWeTNTrzzl32mT6tzHT34JHfI/ryUeYoww0a1NNPsTmNKAY29rqfAhWNRLRBnKesElZvB0UG/BuVO16kb6ZmKHldsp/pIyTyQbQ40ymypErQtPq5kEhmc5FxCB/YNWABeGjelfqstGtE7Ol0bmn7akiAO7a0K1ry2gCbqNUZYRM07WfTkGbT+WsT5RmkFm3v8BIvhp/5+t3erWr9v5YHjF9Lj8vrYbIQvnxHimNROSsM9ytEShe6kd/l1WABFh08OfxJcGVap8uHKhdDOuC5I43/QucHQNSma8Qp9WuxqQGTwWT+ZYKAl80pQexxIsBTZacnojoAaH29aDTE7QvP1mO+2PDjoTCex87LOOcRYC+9ayR4/jqjq+ZOyTBoiJFUuXTmoEc3WgMEr2B72D6DO4E30d3GVTiaiobEE+brGhBni2MSITUM2krZPmiuqVeHTBfYXN82obifLoPlsnQU88HIrUyR8BO/dSmijFn+gUQD/YrPBpY3jEM0AHMXCFq2SxJGNlGhQl4CFZdxnVnfpcy1VYDJh78LIpx9jwZWNbwe/VHjqgcLwYbSVWIkp/lUmipUeDW3toR+f7BUF8bhK38FYk2Kg4D4f2q23mGYbHo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ffdfa56-1512-4624-0edd-08ddab039b95
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2025 05:23:34.1978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2/90HmDg+M8/VdN08gYZ2qW1ysmVQWwYnmxNOV3uddd8+UfymX3nthh7tGQqEk40FNBqWJ6r/D8jHOxlZYDtGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-14_01,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506140042
X-Authority-Analysis: v=2.4 cv=b6iy4sGx c=1 sm=1 tr=0 ts=684d075a b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=Pwurc4Ftf1I_wWrZqvYA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13206
X-Proofpoint-GUID: 5EQ1ZMiq1JdKFrwToGOA8X-7dgKNwDzf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE0MDA0MiBTYWx0ZWRfX9KJglSviaZ9L az1D5HuQWAfLFMRwYTMsQMY5Gu8BYZnGrLlo7ROv3VbRUMegu1vIfP0s9Ovak7Wj6YfWKwu5CFq Cxmz/4FfLRaOtKCgGUyMGauKNSjy5rmtFNpNVBRZg5P14+QpW/UpQLsnbkoENB2gzrxjZJBajrq
 YeiEr+KkZi4m5tIBSGRBwdgNJZCA6+lrOrZv7SE63KIj3ScxctgMLtNcJ6T4ft2kpXIIfV2MNE6 FJR43eWitnIcQ43/eZE/t++/vhz4p05fgBdDPtlOEQS1OEx+bUHxQ3iRr7kdCNGqsSuOaT6KGZj Dw9qQpYV3RTETaoNW6W8ha2os8kHS2juA/WFePmmqXhut/c2lgtPFTdWC6ptuPKD7gCmEAwCjA8
 1PaBwM7hL6U4+BklZtGB+gmNAjG4/bzDlgkr3pa8Nj2Z/mA/ieKLZKBFEr7CSgwHLgH3gI1D
X-Proofpoint-ORIG-GUID: 5EQ1ZMiq1JdKFrwToGOA8X-7dgKNwDzf

* Peter Xu <peterx@redhat.com> [250613 09:41]:
> This function is pretty handy for any type of VMA to provide a size-aligned
> VMA address when mmap().  Rename the function and export it.
> 
> About the rename:
> 
>   - Dropping "THP" because it doesn't really have much to do with THP
>     internally.
> 
>   - The suffix "_aligned" imply it is a helper to generate aligned virtual
>     address based on what is specified (which can be not PMD_SIZE).

I am not okay with this.

You are renaming a function to drop thp and not moving it into generic
code.  Either it is a generic function that lives with the generic code,
or drop this change all together.

If this function is going to be generic, please make the return of 0
valid and not an error.  You are masking all errors to 0 currently.

vm_unmapped_area_info has an align_mask, and that's only used for
hugepages. It is wrong to have a generic function that does not use the
generic struct element that exists for this reason.  Is there a reason
that align_mask doesn't work, or why it's not used?

The return of mm_get_unmapped_area_vmflags() is not aligned with the
return of this function.  That is, the address returned from
mm_get_unmapped_area_vmflags() differs from __thp_get_unmapped_area()
based on MMF_TOPDOWN, and/or something related to off_sub?

Anyways, since it's different from mm_get_unmapped_area() in this
regard, we cannot rename it mm_get_unmapped_area_aligned() - it sounds
like a helper and is different, by a lot.

I also am not okay to export it for no reason.

Also, is it okay to export something as gpl or does the copyright holder
need to do that (I have no idea about this stuff, or maybe you work for
the copyright holder)?

The hint (addr) is also never checked for alignment in this function and
we are appending _aligned() to the name.  With this change we can now
get an unaligned _aligned() address.  This (probably) can happen with
MAP_FIXED today, but I don't think we imply it's going to be aligned
elsewhere.


Hate for the Pre-existing code in this function:

Dear lord:
off_sub = (off - ret) & (size - 1);
Using ret here is just (to be polite) unclear to save one assignment.  I
expect the one assignment would be optimised out by the compilers.

My hate for the unsub off_sub grows:
ret += off_sub;
return ret;

It is extremely frustrating that the self-documenting parts of this
function have documentation while poorly named variables are used in
puzzling calculations without any.

...

Thanks,
Liam

