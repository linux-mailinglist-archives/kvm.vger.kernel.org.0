Return-Path: <kvm+bounces-29036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 008409A154E
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 23:58:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4F9F286F5A
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 21:58:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19BCB1D4356;
	Wed, 16 Oct 2024 21:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="grf3DC9w";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JzAOmC8h"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A619C1D2B1A;
	Wed, 16 Oct 2024 21:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729115777; cv=fail; b=XD/3/PXeix7220PNVrqQvy/me2GGdsSX0x+1twphxMTKsSzgoKB5iXu2UC9IM6U5C9dIvmye7RD1TEmInxo9R8ubxSnZBdZ6uncgFBZqg/ty60iauLUmBHyFlFi0v+qitsPQkoLGFVfU7dOkJ0AaJ6odGvWUbJLqjlSizATjbTc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729115777; c=relaxed/simple;
	bh=k9IRkPxjfGqzvw1GbPuESj/eZIvIlP8DYDN0LTdLeW0=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=f+tRSXmOSH+1KYqi7saqVVRXSP/QElRO59GKB/LABpjf9Z9CgYIXDG7K5p0OHZb9Giw3T0HfXBOGkZZtLHLC6ZoxrClBegJUxbWcU3EboiKIzlmjHDyabi0IMHB1RlE+5c+SMGrbQEtgP+gE+g7mutmKOfsqfIbbOVStIh1xTr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=grf3DC9w; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JzAOmC8h; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49GKtheP001227;
	Wed, 16 Oct 2024 21:55:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=x4AvTb3zlqmSvAt+q7
	EetleSvRMqPNc3muJW4ddwqr4=; b=grf3DC9w4B2LfvucMbgL+Oeq7BFLCSzqwM
	yAp0DlC6gs1zVNtvXECb441uVqCIBgB7iQt9tHdpjXPkc/+6ydeyG40HiqwPepQJ
	8Y1gGqQ8t9zsugBP7UkUXKuHp+JRsQi5qNouYHyDlN/ofp4a3mSGbLbmOS2QK1yX
	nDWL9x9MweFFOcHT1xsuAyJTi5zzfQ4YOPq7s8NbPuZojkcxA/igEiVepqyXxex+
	tpfNIta7uIZQXbAXmfbKIS8OivFsSjf07a+n0jhQFoWf5TWE891j0Tgk260626Qk
	lSzzYRMC7a4sDE2WGMylLRkYQ61qFqKwWKxfOyp/UQ9Xr6c0I9Ig==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427h09mf1q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 21:55:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49GKcZd7012214;
	Wed, 16 Oct 2024 21:55:13 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2042.outbound.protection.outlook.com [104.47.56.42])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjfra74-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 21:55:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jjZXDOYx+bvL+9r5DuDtf2AugtSApI+1wJuRzCR5zZPDbmp3/LFPihtvu3bmscDwFXlJPp+M8zgk1OQzpv6G3XUr1Sq9M4mtb2h+JY60JNMTIKc+Tt3336hOumSsXIrUOAcwbvM2VMB6shZEl8KEhLz1PD/xjjfd24LWA6tl5GtuSQ41YSwJq5QDaKGM8i1pjdFYtksQTqy7UCaB0E84xcqJceLc4LmxDfAY/nllpI8qU5C/CXdN6EAzi6xCl6fCJt5zff6Gnep9ojT74UJF+cotNb0Ac37FUFeeyGpzCqcojbYq7wnjXu76eVEtlQmjuLLMy0N58ghSSM0Uhhr6mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x4AvTb3zlqmSvAt+q7EetleSvRMqPNc3muJW4ddwqr4=;
 b=vbrri7gGi/J7bcpKmQQfb29o8jSG0jIdOdJ/my6A+EoRU2T4WBZtlAueUbctCoPOAQJCD2WRk7XfqYG324wrGCFWl+kuzE3eB/EFDn0RTYmOoXtHgrtEA6pYKXSTbbce9XTdeawJxvgRGBcnzl9Djr4awMQYBW2NgiKP4jrTYd7eNUlmz8Me0b+BTTWWblBsyROBY+HLy9ikti6Nk72KGoep5i9o7Q3QhY/KqrI91gu9BPGV+VvWN8s4sthxr8A5N+rXzZLV4GRcZAV4L6vSVtakPL/ns6J2bsbNUNNdImFH7jQ0GKF8Ow7CTw9n1lVfkTnnc8miSvy8L0initwT7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x4AvTb3zlqmSvAt+q7EetleSvRMqPNc3muJW4ddwqr4=;
 b=JzAOmC8hfwlLx3aWeT7Yt2ySyKTViQLVa1zmOxGK3iRA6QzQllouOchuFhxRAGe7lTRhEPWZBspNQdCp02ixYdviWQqzcqwUvWMgjJ2Q1fA0yZS4cI9rFcn2bmqj/vBBU8bzbtyEUzo+pzUulY3iL9lD+AIgbbw0KjpYzuHoOY4=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CY8PR10MB7196.namprd10.prod.outlook.com (2603:10b6:930:72::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Wed, 16 Oct
 2024 21:55:11 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 21:55:10 +0000
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <8634kx5yqd.wl-maz@kernel.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-pm@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
        arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
        harisokn@amazon.com, mtosatti@redhat.com, sudeep.holla@arm.com,
        cl@gentwo.org, misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH v8 00/11] Enable haltpoll on arm64
In-reply-to: <8634kx5yqd.wl-maz@kernel.org>
Date: Wed, 16 Oct 2024 14:55:09 -0700
Message-ID: <87plnzpvb6.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW3PR05CA0029.namprd05.prod.outlook.com
 (2603:10b6:303:2b::34) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CY8PR10MB7196:EE_
X-MS-Office365-Filtering-Correlation-Id: 05e7f0ee-4f0a-4a86-f842-08dcee2d34d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?q93OqQgcBRyzWie8se/aqNaR07SoywaoI8qlRzgVToJT/LkTXvI1eqAjb78B?=
 =?us-ascii?Q?VJuRW3VNwudymHA/6MWvd/OCMxpZFinySOZ6btDhgIHZKQPsW0vUqidw/ta/?=
 =?us-ascii?Q?pf+r+ffDQq+/AN0oPd0nd5TXc5wE3+knovKC2tPw9MtQBmZyEQfze3Dol4nm?=
 =?us-ascii?Q?VgiWPCLZP11D96WPdaubj+3bf+Mqxy4cAK6QYAybNaCDXVXrMAufTyWKf7Nf?=
 =?us-ascii?Q?Ych5mzpjto1YA+C4aQyepHxVxmBVSVJVexv4sXG0yLP8z34XCiAFDT0Ekq8o?=
 =?us-ascii?Q?TF9mM85g6rc+bIyFb9xOYcl6p8xgwGsNG6iq1hrOsScnCdmSccSkWGgGO34u?=
 =?us-ascii?Q?DzXSBi6XtPRxHmSML0wNPPF4e7qvfIFBOoDAo8eYpddBcVNTW9SNSOL7Zokb?=
 =?us-ascii?Q?eKrWg/mobl4zI1bSUJUDBlrq5dKlIlOpGgDWX298zRaTAAmZi8sh3q2VGgJk?=
 =?us-ascii?Q?QrxtuJnkPSZZtrK249s/6kGIO7pQc8nB+FPQ5Q4v9mqCyYGVOjrzdCs0BpgI?=
 =?us-ascii?Q?OExQbsbY+qNpcrr5+QH7mKU2fe0Y27OmS9A2CRUY/8Lr9ueWchw9pHqL8tS3?=
 =?us-ascii?Q?n11ZIBNxl6/7chYzfKIJFaNakDkR2tmbYVA5/kcSkv3BqxXdZXjwoCNkDGJx?=
 =?us-ascii?Q?CRHAE8RDqFYFtowZhgdTiPRlUjvLg7cFuhIdf362N7swwUPOmYZsmWY7nsci?=
 =?us-ascii?Q?ZlkPLqN+9pMFoAX8vd2V9gRvdfbWTi9h3JUOgsVrfql1WSvOOtt9PC1WIrD7?=
 =?us-ascii?Q?Kf7vSAUyL5u68fPmbw99NHYwm3iyiEt0DiCGTVx84jfefkt96qC7fUzPJRwI?=
 =?us-ascii?Q?89XlWIUns8z2WQ8YR93MQcOQSXHLQK5FNchL4INJjA8jwEyqL/PEhJESFnwc?=
 =?us-ascii?Q?WorUvtFLsC8e8mwRsdP/MRBW0YTvZZgwnQ11wjjkm/ukNZc9x1yNPvL2fiBh?=
 =?us-ascii?Q?g2MJnsQ19IE8Fk5FGoyaEzPLRK2L+hSGUMdFJWKEHigJHCuLR2zHelX7QR5n?=
 =?us-ascii?Q?mPjzOQeDaGLP77T2F86+nFLQSDtk5rBZgOjy2YDh/ptr6AST4yvHjYBuedPj?=
 =?us-ascii?Q?VveRYB0BM0oANBrOBk3W+cq0Ua8kbE6cJI+CFulIoLsGtTkvUuXsXnySBvDh?=
 =?us-ascii?Q?KDZyzChN5pPRLi2eCXhzXnkXdoKtcumLGtKTkWZnUSWgXkqiYc6fi9XrQ4YY?=
 =?us-ascii?Q?c+uXNK7rB0tKLtdL9TTKY48c8Tci3s/Da28zM9NdHESPkHIRJWrZu7ECISD5?=
 =?us-ascii?Q?Aq7smTI7TWUN+8rXH+JPAHfmr+fJYIL6tHzrLECGSNiqGbFZfk1U/sOnJ2P+?=
 =?us-ascii?Q?Hr0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Sods/2OEV+N+nYYGy3yp0FFvs0VoBxkxwmFQtBaViSP2ir7RygLk3e//sqQx?=
 =?us-ascii?Q?mx1k1YvC2NsB0PJMvw05KhCpAdhiemAOFCxesZGOkB3180auWvFJSBbiXV4y?=
 =?us-ascii?Q?D0e9/JyI6+T+waApmrzC+daF9Q47JFfucMCSRFAh5YuglAN+dsanZY2pmU/2?=
 =?us-ascii?Q?4x5d9Xp5QNQ7ILnGPMMngTdcJsqPnKDn0s6c0O/nxamlTWdao0tWaOTqlQ3A?=
 =?us-ascii?Q?B43TPSml1N5UM8lxxuJVVJnR5PZfz2ulWoD39yci9uOhhd4IR7iIBVHY4PtQ?=
 =?us-ascii?Q?jISNK9cxbDxQ/KVfErAOmkB8biJkuHZPWv/rJOXGCbggluEgf0diKIjxaOyT?=
 =?us-ascii?Q?ss2B6Qua0L2dEythanUJ3kVwgcN9YEnaAGYC+7Ta2blWeSONkH5+7jOCUkb8?=
 =?us-ascii?Q?Dd0jKlRJIUG/oPUk3RghLbTDdYfgeRPheSBwsusgUhO0QEdv36K6y3CdYXg/?=
 =?us-ascii?Q?2Dc6GX3UVKMrNA1LyCj0NadbJ9zJyzHreUBMG8qJmyOStHTo5wZ+JN9auHvk?=
 =?us-ascii?Q?kTzEeVIA8ukAmboGF11pmQfyaD7ym+TIWpOHsMAtd9yrQq5xtY4NfaNkKZsL?=
 =?us-ascii?Q?+Dp3QQvGxuL0/kejMzHJGA3LdUiHCqr6eiGkRV+6REZpwl/zSirdTuzEhXX9?=
 =?us-ascii?Q?v59g/WqHFSvOAmu5sLR8NIow1nsHMCvXlxclpK0yuAQ1C3mEfudWoPmwEK5c?=
 =?us-ascii?Q?iKH5mtoQMA9GJ1BQ3XMW51+rZULuvWXkmhgA2rCBmd+v/tvnoAe8uhJhT+Tt?=
 =?us-ascii?Q?WfzQxLJ8dtBj5yCOBL8zH+G48i5mCEicE102SlkvfgjR1hJnVLP3T5WssnHK?=
 =?us-ascii?Q?SxSiMuR2993Yn8Wllg3k5XZ+NIR4YkV0/0OpEyqHWUWiVZlJSaS4roKIY0xm?=
 =?us-ascii?Q?PhPHh5i69yhoGIrVjvVzwSPPFBcRJ5u8LgplDOR1kCdnwwcF7HXNnNXibCsB?=
 =?us-ascii?Q?6ymQFN1xZpg2LasLncQxychKbDXBcSA4SH6ltm8fqZrvGuUHHMqApsr/6OZl?=
 =?us-ascii?Q?nHTK6DX55+1J6+LYGfRLLNrEedqmDR5RLMv0zaTyBUMvHNOivKXCc5t78CcE?=
 =?us-ascii?Q?DU5k3Pjyjkf6hVe0C692LxzPzjPQoSNmlXTg6hd3HOsB8l5EfKEHeuKtYCIl?=
 =?us-ascii?Q?wYwW6NMEf9usR11U71Bw5fqQ7CA0WSkgJEEkBIV6Tnif5sNAPpWIPe1mBb3R?=
 =?us-ascii?Q?1ZVbosNvtpBD2IouafDQsBf7TeFt2jxmm8/uxwggfoT0lchlx+LgIvuYbOVW?=
 =?us-ascii?Q?y68zrOhy0gXRwsGa4LUtcpWrd89Puc+1g4UwUvRCb+K5gNz4UrKsYHBllBBr?=
 =?us-ascii?Q?xCBmLMUjILXKrz/ZP/z/kiRWX7s712UAliI+vzA+6TFk5lVvfYnAXBNmxjqf?=
 =?us-ascii?Q?Y2gTvfgmfr97XYcoT1zAuMhoGuY+28oYjafYp0azlaHI8ZpqhSm61ovz18LJ?=
 =?us-ascii?Q?tQBSoVI/TbB4zWRdApLlLMooJ39DsUbXAdo9MPhCjC0s74VGUjUAmDLgvQyt?=
 =?us-ascii?Q?5k/vcRgAfgwbhuTrDR5NVJfX14ptT+hLGdInOajuPEX/BKdSNMIVDjKYV3MG?=
 =?us-ascii?Q?Ekh99zdrpQgoMpELbUJ0+tcd27FACdg/odPerCd/MmPPbtc8WN/2MyOjmqSs?=
 =?us-ascii?Q?1w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lVYrXyFkXU7s25pzD2vl4Q+PjhbFf9Ts9Hq0Hq/2kwzbY/Vc4tqbUQxK8m6KON4AArcNuo3T46kTjoWUqguofpH+NdeJltjSYt939YZGNU15gYNxweVM+fsZUdewv3HQyDfxlEErXfrjNrC4xecQpyJNBRMxYlXml1Ovas1yecOiLzPgqiuVUlUZmGQQ5RfT8b6tBM4fctjlFHr31giOHg1rlgN9YMkzt/DhZyNa5FJbbYP/bcKO0vbBPiHvDFygVhP/cm/naQ1m9t5+bnjodz6hl/NWvgudIjcs4XcEomUAuMAbVAP8XHsNWT4kKFYm11OYgRMwKZD+M0C8eTaQEGEHOHYv/GchAvoZKKbpG84rdLsRJ0L3N0nzaWKfyRlJ6XhaecT24HpFvnQNiYo2GoOlI5r9xQChvSOtKKMwcw1OXROdp7y/oHr49MbBz4cipLTrzac6Z05poDtLNCKtbA2eAI7BENn7vixPX7c3daoT9krTLILgo9MKsXbbKGQ8Qmuk/Bae6h6eqx8+sbfHkwerPzFF9ZMsGmCv3mFzRqGDGZLi4eax/WkP7+FY7F31GaVEhN67tA3chqo7ERDvkQa3ZInQHEDwL0laf6TdVw8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05e7f0ee-4f0a-4a86-f842-08dcee2d34d2
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 21:55:10.8404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h+v112Pk+l5bsmod9x3zB3gAPqJwQbfc0yPQli3hoNeYm/i4FWlXpxzaG+K5W3l38Hsdu0pKcJ5gWvXiVLN6MEcaeSxw06C2Ro+m7WbLPTQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7196
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-16_17,2024-10-16_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 spamscore=0 mlxscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410160140
X-Proofpoint-GUID: HAslzws9PJtM5mq5G2rcBZ7YnoXCbQkz
X-Proofpoint-ORIG-GUID: HAslzws9PJtM5mq5G2rcBZ7YnoXCbQkz


Marc Zyngier <maz@kernel.org> writes:

> On Thu, 26 Sep 2024 00:24:14 +0100,
> Ankur Arora <ankur.a.arora@oracle.com> wrote:
>>
>> This patchset enables the cpuidle-haltpoll driver and its namesake
>> governor on arm64. This is specifically interesting for KVM guests by
>> reducing IPC latencies.
>>
>> Comparing idle switching latencies on an arm64 KVM guest with
>> perf bench sched pipe:
>>
>>                                      usecs/op       %stdev
>>
>>   no haltpoll (baseline)               13.48       +-  5.19%
>>   with haltpoll                         6.84       +- 22.07%
>>
>>
>> No change in performance for a similar test on x86:
>>
>>                                      usecs/op        %stdev
>>
>>   haltpoll w/ cpu_relax() (baseline)     4.75      +-  1.76%
>>   haltpoll w/ smp_cond_load_relaxed()    4.78      +-  2.31%
>>
>> Both sets of tests were on otherwise idle systems with guest VCPUs
>> pinned to specific PCPUs. One reason for the higher stdev on arm64
>> is that trapping of the WFE instruction by the host KVM is contingent
>> on the number of tasks on the runqueue.
>
> Sorry to state the obvious, but if that's the variable trapping of
> WFI/WFE is the cause of your trouble, why don't you simply turn it off
> (see 0b5afe05377d for the details)? Given that you pin your vcpus to
> physical CPUs, there is no need for any trapping.

Good point. Thanks. That should help reduce the guessing games around
the variance in these tests.

--
ankur

