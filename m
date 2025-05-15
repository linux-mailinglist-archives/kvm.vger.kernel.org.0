Return-Path: <kvm+bounces-46725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D9B4DAB90A5
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 22:16:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 853901BC2845
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 20:16:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 879D9297A48;
	Thu, 15 May 2025 20:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="htANr33H";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tem7rD3a"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C301F17BD9;
	Thu, 15 May 2025 20:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747340179; cv=fail; b=uZR8DSpji1noHZ4Dj8KOUZIcWlfM90EgSNRQwbl4CxS2g6nFWN8inu/tW7n8QiHcuMz+84XjZwRa6QWBVHGi3GU874xyHLtJJ+jyde+f6AfWJRz1ZedD/fHqClp4RGAd9YUqB3F1MUVs2q8CCYFA1HixeVdaOrwG8oJPRpTbNbY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747340179; c=relaxed/simple;
	bh=05svDdN8YgqVChkigdUmOrFdbwiJTWl3QzJ/fSc3vjk=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=hHzYrU7MeI1KNL3Cc4sLluhQZzbRo127FbSW0qsfxc1UQSTiUNuGZjBERmgBuEg0zsXRxeEkONWlzO2pqTys5zlo6GGvi4U9GHuchsrdDH+9YiKWuw9RKfAMbZZBWqrI2bEdTg33C9Cz7NjDSkmqiaTt0ohlpUHbQNftlvPODJk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=htANr33H; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tem7rD3a; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54FJaHBD016623;
	Thu, 15 May 2025 20:15:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=PcZPbw3fRHZmpPt1
	DnafyF1iZQ4IXU4t1dKsAcgyTfU=; b=htANr33Hv+Jh+xHGIIDJlNrEZRak+FbR
	jb9gjULwlPWIrXmHmYMPincZuPyi+HK/jR1fLB2sfKACdvoNGDpbSLaSjLqp2ANV
	I4uBY8g1MYj0xHXmxwSMTvfp4XK/wBnwphcbrekwcZU1LEp09/QOvCNLe2WTk3Ni
	tQb0UskY2fo8RBRMr9ti9tVZJ5sp5pStLLDAxY5KsnpRaZtSMHSrK4KDHRmzHnSe
	jOBSTLT/m9Q08+eJd7n2FrIzAJwZc6kgDYYwMb/qWyARSgQGRgZSxhMffUWq0/pa
	Im9mjMElrXakwOHAxYZOroOrheQ0hDFUXmhSBrahoQsxtZjjfeb2Hw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbcrn76w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 20:15:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54FJBSbo004463;
	Thu, 15 May 2025 20:15:56 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazlp17010007.outbound.protection.outlook.com [40.93.13.7])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46mrmek50k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 20:15:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hIKKoHHnHuVKKYC28dLB4OwIA6XvSEaT45fzNYrw2dspHW8Q3qdGFuARF4e0Prp863MXpiyyaJ36spna+vtAgcweEYk2yyr80j9iAIk6tRWlPYHjrLtTn8Yy8B7cnW5OVDWfs82uXn0ehc4od5ZV/fRtefKNvqEWq5QNG6vZIDwWoEIhKVfD5zLqWUac/0HmCCeHiWBfm7NBLwJcOJZoxbsjX0BzFbOAOyzuOLN8GGNKsvQsCN80Ms/ZJKvimxT47vxQbh035lnls83M3S/PSWKgRbVJYrwVHDhfYM93sGN9HSUMyuA86chNwEAXcUuW1NXVBsLvlqnKYkaCDuSwSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PcZPbw3fRHZmpPt1DnafyF1iZQ4IXU4t1dKsAcgyTfU=;
 b=RN7AiblIlfK8i7sto1Vwxx1DlbPEhSWhp+f971LfpCnZNyth77cIcRPjYj36njNOxs4sAZdnivifcKLVRCypyKhWnLedgientMmBu0Hz7u3OBcwIkQkbDhyyjUV1GvpdafDH8+LvnGKt45bXHr4I9P5IA8uneOT+wqCcmj3H8qTAuqbkF1bWl01dWby9LHQpc3Ax5E2svFKH5MY2bjHdZGhXz217r7ASwNQQc2G5+w32NeLlEwiUT9vIFdEW/s7HUtH9N36JP4Xtuhr/LHod/qGtWGKa+eBWCN2+axD/+I7eAueAeMFVz3WxAHlGYPrbyr+x9pOt6ktKAz7vfo7zgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PcZPbw3fRHZmpPt1DnafyF1iZQ4IXU4t1dKsAcgyTfU=;
 b=tem7rD3a1neCUhPXiGY6xj596A4QUuWLKc2qa92RHlUDZcVkndzl4WUHHZdAUrePaMu/hobYIX4hmZCaMqmicw0oEqzPiHiaVqL5bDu3KE6u5OlYwNj4CEi999m9xq9/OAJktUo1BeR5h8qBloDRui/CO8TeV8W1fome/FUBxvc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA0PR10MB7275.namprd10.prod.outlook.com (2603:10b6:208:3de::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Thu, 15 May
 2025 20:15:52 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.8699.022; Thu, 15 May 2025
 20:15:52 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Houghton <jthoughton@google.com>,
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
Subject: [PATCH 0/2] mm: madvise: make MADV_NOHUGEPAGE a no-op if !THP
Date: Thu, 15 May 2025 21:15:44 +0100
Message-ID: <cover.1747338438.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.49.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0274.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA0PR10MB7275:EE_
X-MS-Office365-Filtering-Correlation-Id: 39c604d2-48a1-48a6-28dc-08dd93ed4a69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j5eqZg0+jXdKS4KMMhOhD69555QTkBH3OBg6wfqDRTVH6jxnFI2lNSntMDHV?=
 =?us-ascii?Q?dar4FYNy+ydRQpt9JI7yCDr7YdPiD8VHHrJVGL3a/JmAhgMpsGWgNhv/zcnn?=
 =?us-ascii?Q?99NikLWllLgqmx9aIr3RgjHa5qRDQvVFTGVKDoQNlXHYM4RHD3KLTNQ6hUiO?=
 =?us-ascii?Q?shYFSc/tkRUDLiYo9Z8noKEFVS4295lACk1TbVRFxMUvX10e4sLMnxjItBBd?=
 =?us-ascii?Q?ktgYqM/SplCK6kJTqg1GYWeKBne1Ti/aCct35zX1hImi7TuM+K/WZ0YF9PRV?=
 =?us-ascii?Q?UTL/jySFRd0aZ06zu25xNDUSHVxb1MfrvxxBijl1LMtqR7YqGNYDYhfwDgZo?=
 =?us-ascii?Q?myzBHKA1EOiSivRMcczfWzze9PK+gingKe/pb92WAuNzhvr4Wb1UCi2kzADM?=
 =?us-ascii?Q?yhrhM9esNUd7EPtNPzXSUfFenZsjsCZ+qxPQQOrZGguS+/lf+WG/NTAutbPo?=
 =?us-ascii?Q?mfyFRV9JGc7X5vE9N/T6rRlo1YWaWNvNlSE3CAipZZ7lTl/v2Vlh4clVq0Px?=
 =?us-ascii?Q?Jpu2GPuNAo11+8bjRfMAphnfQNRATZX5JHj16ADfjVbHIbUFMvfK/qNMwzMM?=
 =?us-ascii?Q?UT8SKA1EhRQsxs83rSsqDW84nQKPU/VyiOkvmZNv6YLpC864sirhDC7+QXbf?=
 =?us-ascii?Q?6gw0sRi0EBgb0pBSuzioFeEI+Q8RzgjzlgYFLA+c+2aJXmDDvV1dG+lP/jo0?=
 =?us-ascii?Q?S6UEvzr2niJtHMOXXeq+QgYoG14Y+6iHXQD4dLdk+hKEB/RHInbsylCEQVW/?=
 =?us-ascii?Q?tMPEDL2nwwxT6uep8d7T5qxK722UkALhSN+YjQOWm+Bu6yP7BGMF7g0uOTva?=
 =?us-ascii?Q?7/8B1sSJgbjffNYKjm+WA1EFddnLCNT6dftnohfAje7cgzmOOmXF4LOWbI2e?=
 =?us-ascii?Q?YMX3wnDEHNZ0ddLn2Z8uqV8FM+XKfRjCiM5Llv0mxUTPJ26mSuc97xu22JQj?=
 =?us-ascii?Q?raxBySizrURjMHfpAtaDuMy2ikdl9EelU+GH5qtLKz18gkoO8BZicf7Lcux9?=
 =?us-ascii?Q?T/Wfkj47lenhptWmf/o+5pUFSB63rR32Hsa6W9KVz3adtifMfeEVezSRItuO?=
 =?us-ascii?Q?Q+UbbxYPb9GYXfJMQWivDOfupwwQBW3cncmjzUaVKE0Kl/jqA/zu1pnoxhXz?=
 =?us-ascii?Q?zxC+Jpy78kb+yqMxnFwvr3/tBh7UiFP8ZKPA9x70Oq/ttCYwoZ9JVzwzOPRa?=
 =?us-ascii?Q?JyHdorGWa7y6zVLQdY0aqVT6Ao5bVAkPlpVqW8o+PfjHMwC0Ljb6nH6fFbw3?=
 =?us-ascii?Q?CDknF3rlYlkWlzmc9gcQ8dis5cu0Y/O3pGWNS9ptcXL7nPHh4G/ou75ayLv9?=
 =?us-ascii?Q?beXfPGYWuRFwuRBWqMVdmSQIowqionAmrc39w4ZCgYj+8QK5pLhzQQj7sNFI?=
 =?us-ascii?Q?JohJ1WaHHGPuOn28SfUw8VnNw3nL/dPtEX7j5fxYrz1dDd97maeiTAl+maKX?=
 =?us-ascii?Q?SIyVsZfoDyM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?84vbfDii24ZBxRWhxqr0hBHKAM0x1o9RdWLcUlMzR+eS7AaO0yG2DFB5FNCe?=
 =?us-ascii?Q?PEXcdWN0vi8nqXiabaOCossgRKsZWXzqSl0TgP6j79UxEJlhxgtKI8SoKPx9?=
 =?us-ascii?Q?4ws7u8cnoxlwGbttNpvqzIddSDSmFOHq8EdPbXcxjlsMcN9JLH5gxqHrVQgb?=
 =?us-ascii?Q?odY9+wr+mIbPp1D6IwSy7k9g9zjvUrU7Qzg7rc1wHoBVPtou6YzbY1sGSt5W?=
 =?us-ascii?Q?cebbT2P4WlEDSI4y1tZ2MRcL1+ojjkNDpDkJjGHZMuXe+MS5ScGAl8ZK0DOx?=
 =?us-ascii?Q?L6Rr1fDdL9ZddVnMf1tR0934rXkNAzpBSUjUSCwVIQuTtwh7llSeJC1QjYpm?=
 =?us-ascii?Q?XW/Kqa5J+aJoaBGwVEelXeSXS1YsrcGnv1SB7JegPRL5CQNvlyLLp6bdNI8m?=
 =?us-ascii?Q?lV7MGrqBbxxhtZ+5vh+u2uPfoRusJdlsUXmbl08/i0K595Rf3AAL8Qh0TgxT?=
 =?us-ascii?Q?E13QAMLFjbl4RlMZ8+7b3b5VD3txfUjUW+QnMEBmu8VX9nx8bqZYP+lyY69O?=
 =?us-ascii?Q?2AA93mwpsJnXTirCYLjUBCyk5lwocCRo1PdAjp8KTYVKYFuP9gcQukn7o17D?=
 =?us-ascii?Q?Y4DGlazdYCAaMsAycHhSCi41FctFVGdzi4126Tr7DNEuYZnZrlTm/9PTVSRD?=
 =?us-ascii?Q?sQB71UCvVE5i7RNsaKd9YCJtgqdZMkBltCbdQLetSA1jcTLjn2SuSiFokUOC?=
 =?us-ascii?Q?2txmK4NjnNZevWKpsTFBRtQ66+vaeBnYDYqtAY+3tN3yCroWVHeNUyAb+YXe?=
 =?us-ascii?Q?NhZDDLbho6nOyePDS0MwhTepUnUCuhQlOCfeYXZQeuOC7w7HcoTyTCVe+eYl?=
 =?us-ascii?Q?wO1N8cqTR3zFheDasbJS8fCKhwsbsLiRlp7dwdHVqH06MHZPOA07POBHottG?=
 =?us-ascii?Q?eyEjCh+7FFudgn0RHxMqMELyzU32HfPyEb+HK38VfNZhs0CphKkJB0d5hcbM?=
 =?us-ascii?Q?TQipS2iiSW9HzullGiv688Wfxzem5ndXCHNUPNSsXBhQYLXo870tV4OrNktM?=
 =?us-ascii?Q?qihIrW+LivGpc+m9fU661b66eqZBr1RhPfhrmFD7u/fHWcnZA8FtqLEO1CVu?=
 =?us-ascii?Q?9/licOROyYp7e7rL8wApXIeOk6YchurAkeydPAjNmEKEN2nlGn8y99/aLrWx?=
 =?us-ascii?Q?R9dl+kk/YKL+QyvP9zmPtKtarSd7qGgrwYmXun6ABepJSHvPpwcRN4JAWJQd?=
 =?us-ascii?Q?dSpvqszkAe6AnWmns9LO09w+gNRsSQTSvGuy9x6QF8LugBjw4kzz8DyRsgSq?=
 =?us-ascii?Q?XwPyPt1ekUee5gjxItK8PpXn9wygj4LjGab49ccheLP197X2qfvfIp7umEBE?=
 =?us-ascii?Q?G3ed5nDLZtO7J0hdrj2QGKq5T3+Uo7vgndw5NtFlm1fI3AIBuZ87o119meui?=
 =?us-ascii?Q?2tqdyp/Ydkq7CrHLzBwvisQ7LEzgAmt2OBeMqPnnodeilh9ixdTAuuBkBe5D?=
 =?us-ascii?Q?GbPFYdIZpuJ+9PiWNuWPaqOvuk632eiX++xK5IQ4y3jH/grg1YoSX02UBmdh?=
 =?us-ascii?Q?Tp7v19h85NTYuTrTymwDjNK+NBMz1Nv4YXywJipZ1BNIJ287RqUAZUgxJ3rG?=
 =?us-ascii?Q?eWbK5ofgPxynGjRi2rqHBWzcHNHXOoFXoLrosvEYTWLXvUVoLFZPBVYk4GMW?=
 =?us-ascii?Q?4w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FC3AFjgG6CDxHFoat9eQKhZi7rgJ2RwUo6VHYrzK7e9YrZA6k5l3jtOW/3q6zpy0qe18yl2l6dGn83QWWFq+vxCEISOXYMUB32pDNNkDTJHlsv9kyPkCDfxK05EV/nFM2Ue7XslDplEyHF0SJGzBy/dd5ZbQ6fEUUTYlzGw3OEUzdCIMufFFcffqeT39TUJxi/qxX+8s+4v7XG+KGHzt37cB4Bg1IRThU9aXkVCdkxfm6B91rus75JcoJH7GiCLfFOFnISQkwiUIU5cT1rK/9v2aq3h/2FjBe0kLL/z9fuAfnydmTO26OrUq9siuXBrFLT/A3yEFxavzx6psxPLA/g4UlWpwGKCl/4ZzwJahdfw5kIRaBosDC+z9Ic+LI7d2mwL+EfADRQ/YHWKBndU+cYxTrWwvd165FCEJxUCyss7tbUejdjjjo08R2oUJ9DU4GyFcugB25E8jKnf7CObEjX95OX2J5w+DPxXaksi2stNsvaLGyfistBc0VWc49/XL750HKQ+UyscAueqUTBDZL8ErHCwSshE1y70jmEJ3AVNELtmdUrYHehROobNeDUDSPJyB6Ag8jlxNPgylDuXc2nhSe/LpRAT4usMaU774Tz0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39c604d2-48a1-48a6-28dc-08dd93ed4a69
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2025 20:15:52.2286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DdaIW+TaVC24JksbrFrfbI7q/EtLNOfdJkmz4oPEKvrrasD1/sRk93NcxnuaqvDkpQ+D3LIa9xymS/vJbbs0p7ksO0No4GxI9T6cepV/9jU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7275
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-15_09,2025-05-15_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505150198
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE1MDE5OCBTYWx0ZWRfXzwco4GEHOImk fZL1W4nv0EH6APXAAsTxcC8pUiVFu9gPEniAcTZnOyBY2nSokfGDsJNORJQEyiAQjK2hoM260vR KNFZEJnJ5lN4heZACY39TrsZF6b60jan3bVjagTXfzC4uzdh4Nc3bSvtU2x7l7AZr9Mkef6Yxt2
 7JjBj8KszD2vPgu0VZHArVCNbPShLmSIaw0lvRSI8288TxsDfDQ9OVSA7s+UDmdkHSYS0QFOYR6 ZqHJUMA4R9odIkvCb6CpuIgrUNYEITlFpjixY+IbzQeoAu8e6racoYC9fPoVwpobADBE0X/26ft Sl4JKRZqwFUAkDcJGmewtNGfR/WusTyD1cBdg/JsyKjEZEFsqBuCiJF1mYt1F6jTiwtVYgE98Bi
 sAAuxuQ7eDhY2hyE7hZciqQe2vowZeIlzuTzVHSDXXEXt00cux+L9kTsiFk6BDOgBJeBCJkt
X-Proofpoint-GUID: Z94D1RQC6E0CO1wehbo0xuTeUQTod2TW
X-Proofpoint-ORIG-GUID: Z94D1RQC6E0CO1wehbo0xuTeUQTod2TW
X-Authority-Analysis: v=2.4 cv=cuWbk04i c=1 sm=1 tr=0 ts=68264b7d cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=TAZUD9gdAAAA:8 a=yPCof4ZbAAAA:8 a=Z4Rwk6OoAAAA:8 a=Em9YDhLq9z12hQOAIxIA:9 a=f1lSKsbWiCfrRWj5-Iac:22 a=HkZW87K1Qel5hWWM3VKY:22

Andrew -

I hope the explanation below resolves your query about the header include
(in [0]), let me know if doing this as a series like this works (we need to
enforce the ordering here).

Thanks!

[0]: 20250514153648.598bb031a2e498b1ac505b60@linux-foundation.org



Currently, when somebody attempts to set MADV_NOHUGEPAGE on a system that
does not enable CONFIG_TRANSPARENT_HUGEPAGE the confguration option, this
results in an -EINVAL error arising.

This doesn't really make sense, as to do so is essentially a no-op.

Additionally, the semantics of setting VM_[NO]HUGEPAGE in any case are such
that, should the attribute not apply, nothing will be done.

It therefore makes sense to simply make this operation a noop.

However, a fly in the ointment is that, in order to do so, we must check
against the MADV_NOHUGEPAGE constant. In doing so, we encounter two rather
annoying issues.

The first is that the usual include we would import to get hold of
MADV_NOHUGEPAGE, linux/mman.h, results in a circular dependency:

* If something includes linux/mman.h, we in turn include linux/mm.h prior
  to declaring MADV_NOHUGEPAGE.
* This then, in turn, includes linux/huge_mm.h.
* linux/huge_mm.h declares hugepage_madvise(), which then tries to
  reference MADV_NOHUGEPAGE, and the build fails.

This can be reached in other ways too.

So we work around this by including uapi/asm/mman.h instead, which allows
us to keep hugepage_madvise() inline.

The second issue is that the s390 arch declares PROT_NONE as a value in the
enum prot_type enumeration.

By updating the include in linux/huge_mm.h, we pull in the PROT_NONE
declaration (unavoidably, this is ultimately in
uapi/asm-generic/mman-common.h alongside MADV_NOHUGEPAGE), which collides
with the enumeration value.

To resolve this, we rename PROT_NONE to PROT_TYPE_DUMMY.

The ordering of these patches is critical, the s390 patch must be applied
prior to the MADV_NOHUGEPAGE patch, and therefore the two patches are sent
as a series.

v1:
* Place patches in series.
* Correct typo in comment as per James.

previous patches:
huge_mm.h patch - https://lore.kernel.org/all/20250508-madvise-nohugepage-noop-without-thp-v1-1-e7ceffb197f3@kuka.com/
s390 patch - https://lore.kernel.org/all/20250514163530.119582-1-lorenzo.stoakes@oracle.com/

Ignacio Moreno Gonzalez (1):
  mm: madvise: make MADV_NOHUGEPAGE a no-op if !THP

Lorenzo Stoakes (1):
  KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY

 arch/s390/kvm/gaccess.c | 8 ++++----
 include/linux/huge_mm.h | 5 +++++
 2 files changed, 9 insertions(+), 4 deletions(-)

--
2.49.0

