Return-Path: <kvm+bounces-25572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82B34966C65
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:30:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AC4C28506E
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 22:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99AF21C3309;
	Fri, 30 Aug 2024 22:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hrGMZKuQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rLAgACdt"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9001C2DA2;
	Fri, 30 Aug 2024 22:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725056990; cv=fail; b=LkOAWJ3A8m60sOWRg2yS+kTI5uWZyiKS1A3KCYRIY8mdIYCV97ya7vbwyBf1w5bZPVYnbT+41iaBTnPFDZtESH6U157KbUgnW/OA01tWdLiQWI17o7NFbbrTZ3QobSq2KM78NRaYTn0UlLhAoDGEk1e/7kRp7kuwXM8tLiJFb/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725056990; c=relaxed/simple;
	bh=DVVhYd/WrhOtb8aUDHlylIdNS9AATp/2thz35KUD9e4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=o4RnOXHy5mLKuh2OE0q+j2QzdUV/Uyt+uZu7Nyf5AxZjAX5y+I7x8ZN99gb7sOYs3CuKt9LgqufF+Vxsm+ocn2xh6POFz5KLRde6U4voeH9LxSPts/vcs/rSQlVHWsp2wKU4GOqrRwLaov1R9e5+D2hrep675tgKkgi2dAx22ok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hrGMZKuQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rLAgACdt; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47UMQJYb002410;
	Fri, 30 Aug 2024 22:29:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=vbxLcRDXwMau6ojZuyq/zCmmjpfyFtoL4t1auecO12s=; b=
	hrGMZKuQTf3+cpESHUBliY7pCt0YkMEfWgZ0/fFClJ2B4GxLoik/hYPMMDMAGm6T
	RwOO02txsFPe8S9/esWcmSxhQ/w0PqOflbFaCSM1oBRjFcd95pLheCMWE8y+1tsy
	TFXZzonqqwSVVX1XawXs3U1yzLDFfd4WV2gxHbEOd6J8xEhKZyBZ5nFRtq9tu3iL
	5ju0U6lGzY07Dfd2sp2kn3Z4OIrNz7QSOm9Xsiz37KjFg6maF6mBun5NMZpuwwvm
	tMaRWjlSfGbzcg8g1ZM0UkamaOF/iyUc6oB9iAd1tMZL8eZXPOD/Verv056exxS4
	CGScMOi39h0Wl9bTwyuuGg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41bfjvgvw0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Aug 2024 22:29:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47ULid8R010476;
	Fri, 30 Aug 2024 22:29:03 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2040.outbound.protection.outlook.com [104.47.70.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41894sjaq4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Aug 2024 22:29:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iiwRQDDBpLWePKdVkAKRBZ2SPHlWWJxMnZm/SWjoQUwlAIaWjJkUWhZ9eBXMR/TxV/ndT5zQJd06asByKhylcFFbzG5cOXbOQW01A5sNtXCQ4rxtAKYnnCTkuzldaea+MJrl7qUXhlV7Ip6xUrciQlhltbVwgTWTkyeuryuMywX8+wcgYHC/FY6KfkZaBpPdXxtgJWy4HSKf2IIXh6eNK+uwlju3lH+T/nkCOZnEdrVScM//nu5Hl0uHKWbLnSlEogIlC8lun6cub/LC/VKoM2mBfXcySwaFFhGuIZJWHzHjZvtes61k3VmO1d4biEDXDhOu3ttE3Vkjk6d1cThzew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vbxLcRDXwMau6ojZuyq/zCmmjpfyFtoL4t1auecO12s=;
 b=F1irZ/2dv/HrujBuMXD5/rdatLrchwwbZ1X760dhzRypLEK7E2hL6uobD7xnEAFvXxE3HfDMFvU3EvSFfPxvjjXpED9HZy4Pp05x0L1RH9Mwl1nk+iqpvgWQTHJtzWEmYXOQsNjSfUIF5Aai3QHcaAJalp/OG0Q9QaeQ1139Z4ffv3J2CS1MG0SenVdc3IyW0bi9srKIthNlYgMn8Comzgjp4JrnSYDUhikpopAh4CyUmjCCGdt/DWYDgd9YPbR9csUyKj3KdbP07fXD5Tu1vQNw+bToEv/8lrBvQ5s7t2L+6nkVv/djAuvvG6+3iCixcn/UAzCuayFjKC/KFlrlHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vbxLcRDXwMau6ojZuyq/zCmmjpfyFtoL4t1auecO12s=;
 b=rLAgACdtGc0Zwl80BurQKMixJNIjU7MdOS4adshD+uxQfRtkaSJFVnwBrq1CJdvbUHNBQUfETQ4BqM7NFnwU8eZSw6DoTOs86BlusTL1mf7+7TpdTTQhC2T1fbKMESvNp47IQgmhULYq/M7YhhjE6LEdhNKE8QrTqnw5qXpwDHg=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BN0PR10MB5077.namprd10.prod.outlook.com (2603:10b6:408:12e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 22:29:00 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%3]) with mapi id 15.20.7918.020; Fri, 30 Aug 2024
 22:29:00 +0000
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
Subject: [PATCH v7 05/10] governors/haltpoll: drop kvm_para_available() check
Date: Fri, 30 Aug 2024 15:28:39 -0700
Message-Id: <20240830222844.1601170-6-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240830222844.1601170-1-ankur.a.arora@oracle.com>
References: <20240830222844.1601170-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0098.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::39) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BN0PR10MB5077:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dbfa0af-cadc-4451-159b-08dcc94324f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZSHXnVkJ+gmrJ4gVqQv0Q4ihsi1vfDLAF6fJJwwDRSy7s110ikLdUIpTt1RX?=
 =?us-ascii?Q?ZPSWEfXEpn85apJKUPn5VCSXgG5n16kN3/mVNfdccbkfv3TEvJ6UgmpgljoF?=
 =?us-ascii?Q?13KGb6w5oEV2lWbnabGUP1Du7C+hfBZufUm7xctRBwpEh384RgOSqkRgfCqo?=
 =?us-ascii?Q?ICVoHTD3r79lO2Zy2L64shUGXmxvA/Iv8qhRVRJn04NwiMmWw3LZqDyfoy5X?=
 =?us-ascii?Q?N6dB5JZXC7wvG8vSlt9CQddlmFQKYHnU4GhG73GZDUFlH2QZWHhO19PEbDCf?=
 =?us-ascii?Q?hJFbNCIoqQmhurTYzC2WmyAuV/21ZweS9Gp+diHofbj8wLxSH3z77afX5Nbe?=
 =?us-ascii?Q?P7LFFM9pvFPrttHnpHjcIP1M1SZZabECKyWuiAp1y9b6RJCxUezkNdyQOb8D?=
 =?us-ascii?Q?t3Z8PxDFaduwvl0uqLyHIDbblhNixbOVUDOAz+rZHbWEkjEtyLwWwg2srAJb?=
 =?us-ascii?Q?lIHiRnyTi/jxUj4f6LzYKCQCN34VcHNVDwXRGn5u846FwGOozuWOlBN1kJ/2?=
 =?us-ascii?Q?RTC/Rn1KNrlmCBkV1ntOuzueJumCq9baLhw7RXMcqgEB0SRjPNXYsZqivYwc?=
 =?us-ascii?Q?gEKL1zWHZEurVrH+A5VIss6+xZ4Z2KTb58B088fmtiN5V2U2aYe74TQIZwD0?=
 =?us-ascii?Q?YJhIEKrcXID0xquK4GWoIE0cXCORIbnvcDnz4Kt1MAPwJN/np24gIUZmw7eD?=
 =?us-ascii?Q?YkAfiOiZ4t6HACGsxhEy3+6gnkVYtc2e5IDv1oYuOjLbLAMUBKGnlR5NLnJ5?=
 =?us-ascii?Q?srI+VaRcGWnss2poyH3t1n25aW8Avm308NcF08iqWEZ6H1fGhxXk07zg0SD9?=
 =?us-ascii?Q?lVtujz6S44zk2ZITSJKWjoO8vcu93rrk/AW6MnHlFbCEYRKPLpnWO6oVbm52?=
 =?us-ascii?Q?VM8EmxhU0WlBVz2QbIeGf7k0NkYlCNhB3HRO9kKfffa4rXiTsNZqF2MXM8Wa?=
 =?us-ascii?Q?5OCnfmmgCxVTpPdIN34WJAbgnSICN9hAN2drpvUVqsttqMESfZYeyBe/wCXT?=
 =?us-ascii?Q?MkhkMkaE/KQN2wWZRnCYH+J/WGWEfMpHZBHje8V6l/8WBeB4HvyHJlBcsFOT?=
 =?us-ascii?Q?mepJVZ5GlMw2bwzOSpUuHisvTJQ9gD0enY34E3z3NEoFCBQEDzKmH5RuctW2?=
 =?us-ascii?Q?GWknyo4UJVqfnTMlKBOGhdTe2dwE7HkgE3arGOqhOmqAO1GuC7n3ivFCA7RQ?=
 =?us-ascii?Q?c7UNct5lVg9pUfxvOmkSjQO3yYH3uA4ic5CdFDSA86vzTrJdiT/iVjYB5poY?=
 =?us-ascii?Q?ewKVTgOIFgJ1aPNAEmQrBMDRmxeYi6gDszIJhnQtlv9zWXmzrDR/nDC+YJK/?=
 =?us-ascii?Q?I+Hygt4a1fzKBwL+TMSTOO/siebA9utCl0vH8Adiv9Sakg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oj95vTV2loM/ND69VePX8L06SW7BIgynvmRa86zOCDAJdYpeKnz19rCuvfYS?=
 =?us-ascii?Q?yRAUSR2dqxkNbpb2FRNw/M5awbHgYxnMGUIZqU4kh67KmjfDN1zd6DIcEp2g?=
 =?us-ascii?Q?qFbfauzd31l8ZLLhJ7BdrmqgU11hYrs2QVHN1Oft7Oawrp0rQGTsF31XAe63?=
 =?us-ascii?Q?Xc83sk1a6geVbSdZS9YGjzbtGXW0AM99LroV+4GX5grqjvqWWJ3O72fsyhz/?=
 =?us-ascii?Q?oHKI3PfsTurhxW3DLCGEoXJNSAcFqQPdDB/xhQGZCvrFDJEjfF1k1biTNrOD?=
 =?us-ascii?Q?z7TbUIQeTG09IfNj1If7U/uCbSND+8uZEbj/GAPyAIhgTccQAOnBI5zrTEIy?=
 =?us-ascii?Q?fQYxVxZCe7v8mqPJsQjNCdlEhkemspvOB4Mgf0+oeKYKRwbYMDpeEGfCaNYN?=
 =?us-ascii?Q?XLNG0FF4MMDctKvOETmKTHhXgEeyLBpda3DPOWI30kLaMKIWI4fIWX5YjS98?=
 =?us-ascii?Q?ABd+bDLagOKu4tgdP0HL+ZaVYvghPPCvlR1w1pSeaf5evuGX1Iwy7N2Kab8i?=
 =?us-ascii?Q?4jflJJW+JBWdUZBVPNya4kOnncpBnEhOSSG/wJhlHmOWKXg0Nkk1H6v8lCWC?=
 =?us-ascii?Q?xt8SWWTL7Neo51+gMTCMk1qaao8b+3ANpsgTPU3weAtfWm/CvSvU6hIE5D8V?=
 =?us-ascii?Q?V+Lek1b66EijufeSfKTDv2u0z3VXgG/oX/XTnzP3SzM3MeN8Obz21AlDr8bO?=
 =?us-ascii?Q?aArIvPam0LbaxKibNKZiL94rBwk/uudFKEAN699q4zJV3+QnoQPAgj/R+8/e?=
 =?us-ascii?Q?Dbl2BzNgPtAw8s02VBZWXPIRjLAv/q39i/sSc0YMXlezXtRncVXCJr4FGsK6?=
 =?us-ascii?Q?if6IkLQB49HY/O8/03ws4R5u7XJuF06r64yR1ceQQxCsQlE8dSdTGxhAHsjv?=
 =?us-ascii?Q?3bIYvS4MgKaPEjn5Xq1sDMQX+5bfN+/uoIK8X7DM7zH9fmfv4uBe6h1U20br?=
 =?us-ascii?Q?NOfuhDv68Or6RL7OiCujKVAby06WyWx7jnV4CaGL4mREU5pPdM0Md2LQGhiv?=
 =?us-ascii?Q?CvPYJR9ij/fnTDK2qnaWy5wpurtvnl1SWrda/eRSmWboQqfcxyf3+WH7l6LZ?=
 =?us-ascii?Q?a3a61wOnAg1TGL2Mu4N/0aROc1uXonBTFhLvO/6xQB2fTfACM0i8fBCPKn49?=
 =?us-ascii?Q?9C8dmNgYhAN1OF43OciY8NZoQ5fSx0DG+XXMbNY0dhQlxD3WvbBPBFIzQJrP?=
 =?us-ascii?Q?Ps/SXwG+xzeU6evf9k2jEBna150iAcX8WbbyvJnsdJDHyHg2+RZjcraDiBO2?=
 =?us-ascii?Q?xKDDUeCytMM265YB9OWkQ48rrJCbVpv+Vu1PFtm+djQT8TXOiGQ5g3Gc7Ldx?=
 =?us-ascii?Q?o24sIlnrOfsV9pHu3kN8navz3Fd6PrgNrkizf9Fkca7Aaswlek2gSYbnxqA4?=
 =?us-ascii?Q?ILb2JqsMeKinVaYZp2I/DVzuwm4KY3KnQoZHUsDVoh0KkMGXVIqPrg4RS/TP?=
 =?us-ascii?Q?RysQf8ZhYfuKP00Hd29ychDXxuAkJJh4ePdJHpSEM5HJWCGhh3dns/qj9uvX?=
 =?us-ascii?Q?yEHk8mGgoiEi5MDkFLj1iuAhxyfalTTXSvdSHnsQqcc1sTPXQD+Ny6dp24bx?=
 =?us-ascii?Q?/XKG2kFVKk+i36t6LvrGC2qW4tiBL76SEjVtnz68VvEkI2iSj8tm3R9UeY/v?=
 =?us-ascii?Q?wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	G5MRHGXff/bDbGszNUFkAHduWJEU5/2zs0Ew6XUuaorvgLRHohaLhK8dmdg4ok0v7eOBKBM3jELyCm8N6ygHjbdvYBSlVZe/29Hm5YMpZM9erTd/TXiQds1mBcTZuHMJAhQwixDzpdi0jVBkYjBYDT6Id88r50L5fWUo64+n+8ernbIlj0HjM8RYHiMcuqqZawkIAftAMC8KXambVE1T8wLaxHDcAPkFL5wAQBkiohy9FBSmtFRlPaef04PyMpgXcoqcjT4V2MP0oXsJyr+UGzOrN7x4VCw3VquJPBXNOPQQC8ZpdlDM0prIbr9Goz/+21SwiC6K8gmX6uEP0RXd8ly3Iky/nUy+/Hyuy+eyqbu7K6QWEb3xa4vZxth5PepnbcbshbvuPoqdUcHsDdAHCmExCPlNSBPP2OukVNzEGKAo0dsByXf/qXCti70ZxLQRGzGEjvl86orns9LBqFY7AH5VWCSTnmIDqsyLrb9sCaEsrVu9Z3nclx+mctXzel0Nc5wVHT49J70NmO38HEUKXJFJNhsvkVCoR3AH4xp75adCM2V5iskpYMGhG4vOXRzazO/qrg3qb5KGNmqpXaYAU3EFKtcxm5kIJEbAZw5kucE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dbfa0af-cadc-4451-159b-08dcc94324f6
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 22:29:00.1135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tKAO8+CZtS13KiJV893XW/ysNQvdbcDkaNES4ASsQLS8lzo+q4QiapjlK/NErSPUCg3Y+UkDn/G9UPkjj5NfyB2koxvwsVVnyZb7E+3/Lwg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5077
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-30_12,2024-08-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408300174
X-Proofpoint-GUID: XMFxZcVGtIYqtw95Sk0VatDwdmKF9kR9
X-Proofpoint-ORIG-GUID: XMFxZcVGtIYqtw95Sk0VatDwdmKF9kR9

From: Joao Martins <joao.m.martins@oracle.com>

The haltpoll governor is selected either by the cpuidle-haltpoll
driver, or explicitly by the user.
In particular, it is never selected by default since it has the lowest
rating of all governors (menu=20, teo=19, ladder=10/25, haltpoll=9).

So, we can safely forgo the kvm_para_available() check. This also
allows cpuidle-haltpoll to be tested on baremetal.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 drivers/cpuidle/governors/haltpoll.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/cpuidle/governors/haltpoll.c b/drivers/cpuidle/governors/haltpoll.c
index 663b7f164d20..c8752f793e61 100644
--- a/drivers/cpuidle/governors/haltpoll.c
+++ b/drivers/cpuidle/governors/haltpoll.c
@@ -18,7 +18,6 @@
 #include <linux/tick.h>
 #include <linux/sched.h>
 #include <linux/module.h>
-#include <linux/kvm_para.h>
 #include <trace/events/power.h>
 
 static unsigned int guest_halt_poll_ns __read_mostly = 200000;
@@ -148,10 +147,7 @@ static struct cpuidle_governor haltpoll_governor = {
 
 static int __init init_haltpoll(void)
 {
-	if (kvm_para_available())
-		return cpuidle_register_governor(&haltpoll_governor);
-
-	return 0;
+	return cpuidle_register_governor(&haltpoll_governor);
 }
 
 postcore_initcall(init_haltpoll);
-- 
2.43.5


